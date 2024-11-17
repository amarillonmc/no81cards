--翠帘开幕的黎明-“CHU²”
function c67201268.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa67b),4,2,c67201268.ovfilter,aux.Stringid(67201268,0),2,c67201268.xyzop)
	c:EnableReviveLimit()  
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67201268,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCost(c67201268.spcost1)
	e1:SetTarget(c67201268.sptg1)
	e1:SetOperation(c67201268.spop1)
	c:RegisterEffect(e1)	
end
function c67201268.ovfilter(c)
	return c:IsFaceup() and c:IsCode(67201253)
end
function c67201268.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,67201268)==0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c67201268.cfilter,1,1,REASON_COST+REASON_DISCARD)
	Duel.RegisterFlagEffect(tp,67201268,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
--
function c67201268.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c67201268.spfilter(c,e,tp)
	return c:IsSetCard(0xa67b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_XYZ)
end
function c67201268.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c67201268.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c67201268.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and c:IsCanOverlay() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c67201268.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c67201268.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		if not c:IsRelateToEffect(e) or not c:IsCanOverlay() or not aux.NecroValleyFilter()(c) then return end
		if c:IsFacedown() then return end
		Duel.BreakEffect()
		if not tc:IsImmuneToEffect(e) then
			 Duel.Overlay(tc,Group.FromCards(c))
		end
	end
end