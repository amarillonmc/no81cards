--方舟骑士的深层归还
c29065511.named_with_Arknight=1
function c29065511.initial_effect(c)
	aux.AddCodeList(c,29065500,29065502)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,29065511)
	e1:SetTarget(c29065511.target)
	e1:SetOperation(c29065511.activate)
	c:RegisterEffect(e1)
end
function c29065511.spfilter(c,e,tp)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c29065511.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(29065502) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c29065511.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c29065511.spfilter(chkc,e,tp) end
	if chk==0 then return (Duel.IsExistingTarget(c29065511.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)) or (Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,29065500) and Duel.IsExistingMatchingCard(c29065511.spfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c29065511.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if (Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,29065500) and Duel.IsExistingMatchingCard(c29065511.spfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)) and Duel.SelectYesNo(tp,aux.Stringid(29065511,0)) then
	e:SetLabel(0)
	else
	e:SetLabel(114514)
	end 
end
function c29065511.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==114514 then
	if Duel.GetMatchingGroupCount(c29065511.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)>0 then
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if aux.NecroValleyNegateCheck(tc) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
		end
	end
	else
	local g=Duel.GetMatchingGroup(c29065511.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>=1 then
	local xg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(xg,0,tp,tp,false,false,POS_FACEUP)
	end
	end
end