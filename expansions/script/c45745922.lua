--极翼灵兽 暴风
function c45745922.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45745922,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c45745922.condition)
	e1:SetTarget(c45745922.target)
	e1:SetOperation(c45745922.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45745922,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c45745922.tg1)
	e2:SetOperation(c45745922.op1)
	c:RegisterEffect(e2)
end
function c45745922.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x881)
end
function c45745922.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c45745922.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c45745922.filter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c45745922.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c45745922.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c45745922.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c45745922.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c45745922.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end
--e2
function c45745922.tfilter1(c)
	return c:IsLinkSummonable(nil) and c:IsSetCard(0x323)
end
function c45745922.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c45745922.tfilter1,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
--
function c45745922.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c45745922.tfilter1,tp,LOCATION_EXTRA,0,1,1,nil)
	if tg:GetCount()<1 then return end
	Duel.LinkSummon(tp,tg:GetFirst(),nil)
end