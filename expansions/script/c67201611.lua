--复转之再开
function c67201611.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,67201611+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c67201611.cost)
	e1:SetTarget(c67201611.target)
	e1:SetOperation(c67201611.activate)
	c:RegisterEffect(e1)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetCondition(c67201611.condition)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c67201611.condition(e)
	return e:GetHandler():GetOriginalAttribute()==ATTRIBUTE_WIND and e:GetHandler():IsSetCard(0x367f)
end
--
function c67201611.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local spct=0
	if Duel.CheckRemoveOverlayCard(tp,LOCATION_MZONE,0,1,REASON_COST)
		and Duel.SelectYesNo(tp,aux.Stringid(67201611,1)) then
		spct=Duel.RemoveOverlayCard(tp,LOCATION_MZONE,0,1,1,REASON_COST)
	end
	e:SetLabel(spct)
end
function c67201611.filter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x367f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67201611.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)  and chkc:IsSetCard(0x367f) and c67201611.filter(chkc,e,tp) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c67201611.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c67201611.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c67201611.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local spct=e:GetLabel()
		if spct>0 and c:IsRelateToEffect(e) and c:IsCanOverlay() 
			and Duel.SelectYesNo(tp,aux.Stringid(67201611,2)) then
			Duel.BreakEffect()
			c:CancelToGrave()
			Duel.Overlay(tc,Group.FromCards(c))
		end
	end
end

