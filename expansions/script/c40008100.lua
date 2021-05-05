--星辉士 星圣武装龙
function c40008100.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,7,2,c40008100.ovfilter,aux.Stringid(40008100,0),99,c40008100.xyzop)   
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008100,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c40008100.descost)
	e1:SetTarget(c40008100.destg)
	e1:SetOperation(c40008100.desop)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008100,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c40008100.spcon2)
	e3:SetTarget(c40008100.sptg2)
	e3:SetOperation(c40008100.spop2)
	c:RegisterEffect(e3)
end
function c40008100.ovfilter(c)
	if Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_GRAVE,0,nil,ATTRIBUTE_LIGHT)~=3 then return false end
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and (c:IsLevelBelow(5) or c:IsRankBelow(5)) and Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c40008100.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40008100)==0 end
	Duel.RegisterFlagEffect(tp,40008100,RESET_PHASE+PHASE_END,0,1)
end
function c40008100.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
end
function c40008100.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(c40008100.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c40008100.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c40008100.filter(c)
	return not c:IsType(TYPE_TOKEN)
		and c:IsAbleToChangeControler()
end
function c40008100.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c40008100.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c40008100.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c40008100.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c40008100.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c40008100.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x9c) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c40008100.spfilter2(c,e,tp)
	return c:IsSetCard(0x9c) and c:IsType(TYPE_XYZ) and not c:IsCode(40008100) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40008100.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c40008100.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40008100.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40008100.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.Overlay(tc,Group.FromCards(c))
		end
	end
end