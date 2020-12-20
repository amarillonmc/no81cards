--甜心机仆 暖风的礼物
function c9910553.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910550+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9910553.spcon)
	e1:SetOperation(c9910553.spop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9910553)
	e2:SetCost(c9910553.discost)
	e2:SetTarget(c9910553.distg)
	e2:SetOperation(c9910553.disop)
	c:RegisterEffect(e2)
end
function c9910553.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
end
function c9910553.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910553,0))
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_RETURN)
end
function c9910553.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable()
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c9910553.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_MZONE,1,1,nil)
end
function c9910553.rmfilter(c)
	return c:IsSetCard(0x3951) and c:IsAbleToRemove()
end
function c9910553.tdfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c9910553.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsFaceup() or tc:IsDisabled() or tc:IsImmuneToEffect(e) then return end
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DISABLE_EFFECT)
	e4:SetValue(RESET_TURN_SET)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e4)
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910553.rmfilter),tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(c9910553.tdfilter,tp,0,LOCATION_ONFIELD,nil)
	if g1:GetCount()>1 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910553,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,2,2,nil)
		if Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg2,nil,2,REASON_EFFECT)
	end
end
