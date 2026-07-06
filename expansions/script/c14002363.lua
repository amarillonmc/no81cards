--宇宙根源 哈斯塔
local m=14002363
local cm=_G["c"..m]
cm.named_with_Hastur=1
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e0)
	--act
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_DISABLE+CATEGORY_REMOVE+CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(2,m)
	e1:SetCondition(cm.actcon)
	e1:SetCost(cm.actcost)
	e1:SetTarget(cm.acttg)
	e1:SetOperation(cm.actop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(2,m)
	e2:SetCost(cm.setcost)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
end
function cm.Hastur(c)
	local m_code=_G["c"..c:GetCode()]
	return m_code and m_code.named_with_Hastur
end
function cm.Urara(c)
	local m_code=_G["c"..c:GetCode()]
	return m_code and m_code.named_with_Urara
end
function cm.lv3filter(c)
	return c:IsFaceupEx() and c:IsLevelBelow(3)
end
function cm.urara_filter(c)
	return c:IsFaceupEx() and cm.Urara(c)
end
function cm.tdfilter(c)
	return cm.Hastur(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end

function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.IsExistingMatchingCard(cm.lv3filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil)
end
function cm.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsStatus(STATUS_ACT_FROM_HAND)
	if chk==0 then
		if b1 then
			return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		else
			return true
		end
	end
	if b1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
		e:SetLabel(14002381) 
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	end
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,14002381,0,TYPES_TOKEN_MONSTER,1500,1500,3,RACE_AQUA,ATTRIBUTE_WATER)
		local b2=Duel.IsExistingMatchingCard(cm.lv3filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil)
		local b3=Duel.IsExistingMatchingCard(cm.urara_filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) and Duel.IsChainNegatable(ev)
		return b1 or b2 or b3 
	end
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local b1 = Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,14002381,0,TYPES_TOKEN_MONSTER,1500,1500,3,RACE_AQUA,ATTRIBUTE_WATER)
	local b2 = Duel.IsExistingMatchingCard(cm.lv3filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil)
	local b3 = Duel.IsExistingMatchingCard(cm.urara_filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) and Duel.IsChainNegatable(ev)
	if not (b1 or b2 or b3) then return end
	local op = aux.SelectFromOptions(tp,
		{b1, aux.Stringid(m,1)},
		{b2, aux.Stringid(m,2)},
		{b3, aux.Stringid(m,3)}
	)
	if op==1 then
		local token=Duel.CreateToken(tp,14002381)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	elseif op==2 then
		local g=Duel.GetMatchingGroup(cm.lv3filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)
		if #g>0 then
			for tc in aux.Next(g) do
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	elseif op==3 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function cm.get_available_field(tp,code)
	if not UraraG_fieldcheck then return nil end
	local c=nil
	if code==14002341 and UraraG_fieldcheck.release then
		c=UraraG_fieldcheck.release[tp]
	elseif code==14002342 and UraraG_fieldcheck.counter then
		c=UraraG_fieldcheck.counter[tp]
	end
	if c and type(c)=="userdata" and c:IsHasEffect(code)~=nil and c:GetFlagEffect(code)==0 then
		return c
	end
	return nil
end
function cm.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fc=cm.get_available_field(tp,14002342)
	local has_counter=Duel.IsCanRemoveCounter(tp,1,1,0x1402,1,REASON_COST)
	if chk==0 then return fc~=nil or has_counter end
	if fc and (not has_counter or Duel.SelectYesNo(tp,aux.Stringid(14002341,0))) then
		fc:RegisterFlagEffect(14002342,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	else
		Duel.RemoveCounter(tp,1,1,0x1402,1,REASON_COST)
	end
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
	end
end