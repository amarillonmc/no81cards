--竹子 无声的画卷
function c60002006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60002007+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c60002006.accost)
	e1:SetTarget(c60002006.actg)
	e1:SetOperation(c60002006.acop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c60002006.spcost)
	e2:SetTarget(c60002006.sptg)
	e2:SetOperation(c60002006.spop)
	c:RegisterEffect(e2)
end
function c60002006.tgfil(c)
	return c:IsCode(98818516) and c:IsAbleToGrave()
end
function c60002006.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(60002006,0))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(60002006,0))
end
function c60002006.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x623) and Duel.IsExistingMatchingCard(c60002006.thfil,tp,LOCATION_DECK,0,1,nil) end 
	local tc=Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_MZONE,0,1,1,nil,0x623)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c60002006.thfil(c,code)
	return c:IsAbleToHand() and c:IsSetCard(0x623) and not c:IsCode(code)
end
function c60002006.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c60002006.tgfil,tp,LOCATION_DECK,0,1,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	local code=sg:GetFirst():GetCode()
	if Duel.IsExistingMatchingCard(c60002006.thfil,tp,LOCATION_DECK,0,1,nil,code) and Duel.SelectYesNo(tp,aux.Stringid(60002006,2)) then 
	local dg=Duel.SelectMatchingCard(tp,c60002006.thfil,tp,LOCATION_DECK,0,1,1,nil,code)
	Duel.SendtoHand(dg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,dg)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c60002006.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c60002006.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_EARTH)
end
function c60002006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SelectOption(tp,aux.Stringid(60002006,0))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(60002006,0))
	Duel.SendtoDeck(e:GetHandler(),nil,REASON_COST)
end
function c60002006.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(98818516)
end
function c60002006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60002006.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c60002006.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60002006.spfil,tp,LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		sg:GetFirst():RegisterEffect(e1)
	end
end









