--多元闪刀术式-剪斗交刃
function c978210024.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c978210024.condition)
	e1:SetTarget(c978210024.target)
	e1:SetOperation(c978210024.activate)
	c:RegisterEffect(e1)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e10)
end
function c978210024.cfilter(c)
	return c:GetSequence()<5
end
function c978210024.thfilter(c,e,tp)
	return c:IsSetCard(0x2115) and c:IsLevel(4) and (c:IsAbleToHand() or (spchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c978210024.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c978210024.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c978210024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c978210024.thfilter(chkc,e,tp,spchk) end
	if chk==0 then return Duel.IsExistingTarget(c978210024.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,spchk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c978210024.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,spchk)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,0,0,0)
end
function c978210024.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.SelectOption(tp,1190,1152)==1 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end