--落日残响·奈美
local s,id,o=GetID()
function s.initial_effect(c)
	--①：公开手卡发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.con1)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1b)
	local e1c=e1:Clone()
	e1c:SetCode(EVENT_RELEASE)
	e1c:SetCondition(s.con1_rel)
	c:RegisterEffect(e1c)

	--②：检索后发动（盖放场上卡）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.con2)
	e2:SetCost(s.cost1) -- 共用公开手卡的Cost
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end

-- === 效果①：手卡触发 ===
function s.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.con1_rel(e,tp,eg,ep,ev,re,r,rp)
	return #eg>0
end

function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	Duel.ConfirmCards(1-tp,c)
	-- 直到回合结束时公开
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x614) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.relfilter(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end

function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 选项1：回复200
	local b1=true
	-- 选项2：特召+解放 (有1回合1次的限制)
	-- 检查：能特召、且有东西能解放（通常这张卡本身在手卡且已公开，所以只要能特召即可满足解放条件）
	local b2=(Duel.GetFlagEffect(tp,id+1)==0) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(s.relfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)

	if chk==0 then return b1 or b2 end

	local ops={}
	local opval={}
	local off=1
	
	ops[off]=aux.Stringid(id,1)
	opval[off]=1
	off=off+1
	
	if b2 then
		ops[off]=aux.Stringid(id,2)
		opval[off]=2
		off=off+1
	end

	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op+1]
	e:SetLabel(sel)

	if sel==1 then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,200)
	elseif sel==2 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
		-- 记录选项2已使用
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
	end
end

function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Recover(tp,200,REASON_EFFECT)
	elseif sel==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			-- 那之后，解放1只
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local rg=Duel.SelectMatchingCard(tp,s.relfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
			if #rg>0 then
				Duel.Release(rg,REASON_EFFECT)
			end
		end
	end
end

-- === 效果②：检索后发动 ===
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	-- 被「落日残响」卡的效果加入手卡
	return bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0x614)
end

function s.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup() and c:IsCanTurnSet()
end

function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end

function s.op2(e,tp,eg,ep,ev,re,r,rp)
	-- 选场上1张表侧永续魔陷盖放（不取对象）
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ChangePosition(tc,POS_FACEDOWN)
		-- 手动触发 EVENT_SSET 以配合本家陷阱的“盖放回合可发动”检测
		Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end