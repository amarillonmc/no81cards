--荒败之城 盐风
function c29010022.initial_effect(c)
	aux.AddCodeList(c,29010023)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29010022+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c29010022.activate)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c29010022.totg)
	e1:SetOperation(c29010022.toop)
	c:RegisterEffect(e1)
end
function c29010022.filter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsRace(RACE_FISH) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c29010022.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c29010022.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(29010022,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c29010022.totg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29010025,nil,TYPES_TOKEN_MONSTER,1500,1500,1,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c29010022.toop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)<=0 
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,29010025,nil,TYPES_TOKEN_MONSTER,1500,1500,1,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP,1-tp) then return end
		local token=Duel.CreateToken(tp,29010025)
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			token:RegisterEffect(e2,true)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			token:RegisterEffect(e3,true)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			token:RegisterEffect(e4,true)
			local e5=e4:Clone()
			e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			token:RegisterEffect(e5,true)
			Duel.SpecialSummonComplete()
end
function c29010022.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c29010022.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29010022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29010022.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c29010022.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c29010022.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end