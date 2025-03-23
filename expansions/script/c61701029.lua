--黑森林的正义裁决
function c61701029.initial_effect(c)
	aux.AddCodeList(c,61701001)
	c:SetSPSummonOnce(61701029)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WINDBEAST),8,2,c61701029.ovfilter,aux.Stringid(61701029,0),2,c61701029.xyzop)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c61701029.thcon)
	e1:SetTarget(c61701029.thtg)
	e1:SetOperation(c61701029.thop)
	c:RegisterEffect(e1)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1)
	e2:SetCondition(c61701029.condition)
	e2:SetOperation(c61701029.operation)
	c:RegisterEffect(e2)
end
function c61701029.ovfilter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup()
end
function c61701029.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_REMOVED,0,5,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_REMOVED,0,5,5,nil)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
end
function c61701029.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c61701029.cfilter(c,e,tp)
	return c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceupEx()
		and (c:IsAbleToHand() or Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c61701029.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c61701029.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
end
function c61701029.chkfilter(c)
	return c:IsCode(61701001) and c:IsFaceup()
end
function c61701029.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c61701029.cfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetMZoneCount(tp)<=0 or Duel.SelectOption(tp,1190,1152)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if not tc:IsLocation(LOCATION_HAND) then return end
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	if Duel.IsExistingMatchingCard(c61701029.chkfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(61701029,1)) then
		Duel.BreakEffect()
		Duel.SetLP(1-tp,4000)
	end
end
function c61701029.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and not re:IsActiveType(TYPE_CONTINUOUS+TYPE_FIELD+TYPE_EQUIP) and ep==tp
end
function c61701029.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil)
	if c:GetFlagEffect(61701029)~=0 or not (b1 or b2) then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(61701029,3)},
		{b2,aux.Stringid(61701029,4)},
		{true,aux.Stringid(61701029,5)})
	if op==3 then return end
	Duel.Hint(HINT_CARD,0,61701029)
	if op==1 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	c:RegisterFlagEffect(61701029,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(61701029,6))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetLabelObject(e1)
	e2:SetOperation(c61701029.regop)
	Duel.RegisterEffect(e2,tp)
end
function c61701029.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,61701029)
	e:GetHandler():ResetFlagEffect(61701029)
	e:GetLabelObject():Reset()
	e:Reset()
end
