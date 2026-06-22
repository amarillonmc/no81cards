-- 防御阵线快速构建
local s,id=GetID()
function s.initial_effect(c)
	-- 允许从手卡发动的条件
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCost(s.cost)
	e0:SetDescription(aux.Stringid(id,4))
	c:RegisterEffect(e0)

	-- ①：可以从以下效果选择1个发动。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	-- ②：自己场上的表侧表示的「防御阵线」卡因对方从场上离开的场合才能发动。墓地的这张卡在自己场上盖放。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end

-- 字段号 0x5a31
local SETCODE = 0x5a31

---------------- 手卡发动机制 ----------------
function s.hcfilter(c)
	-- 手卡或场上的其他「防御阵线」卡
	return c:IsSetCard(SETCODE)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.hcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.hcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end

---------------- ①效果：选项执行 ----------------
function s.spfilter(c,e,tp)
	return c:IsSetCard(SETCODE) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.setfilter(c)
	-- 被除外的卡必须是面向上才能识别字段
	return c:IsSetCard(SETCODE) and c:IsType(TYPE_TRAP) and c:IsSSetable()
		and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 通过 id+1 和 id+2 两个独立的Flag，完美实现“以下效果各能选择1次”
	local b1 = Duel.GetFlagEffect(tp,id+1)==0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b2 = Duel.GetFlagEffect(tp,id+2)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	
	if chk==0 then return b1 or b2 end
	
	local op=0
	if b1 and b2 then
		op = Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		op = Duel.SelectOption(tp,aux.Stringid(id,1))
	else
		op = Duel.SelectOption(tp,aux.Stringid(id,2))+1
	end
	e:SetLabel(op)
	
	if op==0 then
		-- 记录选项1已经使用过
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else
		-- 记录选项2已经使用过
		Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(0)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
	end
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		-- ● 召唤额外怪兽并挂载离场回卡组
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			-- 赋予离场回到卡组(额外卡组)的能力
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(id,5))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(LOCATION_DECK)
			tc:RegisterEffect(e1,true)
		end
	else
		-- ● 盖放最多2张陷阱
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if ft<=0 then return end
		if ft>2 then ft=2 end -- 最多2张
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		-- NecroValleyFilter 兼容王家之谷
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil)
		if #g>0 then
			Duel.SSet(tp,g)
		end
	end
end

---------------- ②效果：离场诱发盖放 ----------------
function s.lvfilter(c,tp)
	-- 原本是表侧表示，且是自己的防御阵线，并且原因是对方（无论效果还是战斗）
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsPreviousSetCard(SETCODE) and c:GetReasonPlayer()==1-tp
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.lvfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
	end
end