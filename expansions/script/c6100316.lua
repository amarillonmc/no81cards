--落日残响·奈美
local s,id,o=GetID()
function s.initial_effect(c)
	--①：自己把怪兽召唤·特召的场合触发
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.effcost)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	--①：卡被解放的场合触发
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCode(EVENT_RELEASE)
	e3:SetCondition(s.relcon)
	c:RegisterEffect(e3)

	--②：自身解放，盖放墓地·除外的陷阱
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,id)
	e4:SetCost(s.setcost)
	e4:SetTarget(s.settg)
	e4:SetOperation(s.setop)
	c:RegisterEffect(e4)
end

-- === 效果① ===
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	-- 自己把怪兽召唤·特殊召唤
	return eg:IsExists(Card.IsSummonPlayer,1,nil,tp)
end

function s.relcon(e,tp,eg,ep,ev,re,r,rp)
	return true
end

function s.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	-- 将这张卡直到结束阶段公开
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,4))
end

-- 选项1：自己场上陷阱卡解放
function s.trapfilter(c)
	return c:IsType(TYPE_TRAP)
end
-- 选项2：卡组特召落日残响
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x614) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
-- 选项2：手卡·场上落日残响解放
function s.relfilter(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1 = Duel.IsExistingMatchingCard(s.trapfilter,tp,LOCATION_ONFIELD,0,1,nil)
	local b2 = Duel.GetFlagEffect(tp,id)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(s.relfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		
	if chk==0 then return b1 or b2 end
	
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	end
	e:SetLabel(op)
	
	if op==0 then
		-- 选项1 无特定分类信息
	else
		-- 选项2：注册1回合1次限制标志位
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		-- ●自己场上1张陷阱卡解放（里侧表示卡翻开确认）
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,s.trapfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		if #g>0 then
			local tc=g:GetFirst()
			if tc:IsFacedown() then
				Duel.ConfirmCards(1-tp,tc)
			end
			Duel.Release(tc,REASON_EFFECT)
		end
	else
		-- ●从卡组把1只特召，之后解放怪兽
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local rg=Duel.SelectMatchingCard(tp,s.relfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
			if #rg>0 then
				Duel.Release(rg,REASON_EFFECT)
			end
		end
	end
end

-- === 效果② ===
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end

function s.setfilter(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_TRAP) and c:IsSSetable()
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsSSetable() then
		Duel.SSet(tp,tc)
	end
end