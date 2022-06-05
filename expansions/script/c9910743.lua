--远古造物收藏家
require("expansions/script/c9910700")
function c9910743.initial_effect(c)
	--flag
	Ygzw.AddTgFlag(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9910743)
	e1:SetCost(c9910743.spcost)
	e1:SetTarget(c9910743.sptg)
	e1:SetOperation(c9910743.spop)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(9910743)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c9910743.condition)
	c:RegisterEffect(e2)
end
function c9910743.cfilter(c,ft)
	return c:IsSetCard(0xc950) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsAbleToGraveAsCost()
		and (ft>0 or c:GetSequence()<5)
end
function c9910743.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	if ft==0 then loc=LOCATION_MZONE end
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c9910743.cfilter,tp,loc,0,1,e:GetHandler(),ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910743.cfilter,tp,loc,0,1,1,e:GetHandler(),ft)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9910743.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910743.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(c9910743.thcon)
		e1:SetOperation(c9910743.thop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910743.thfilter(c)
	return c:IsSetCard(0xc950) and not c:IsCode(9910743) and c:IsAbleToHand()
end
function c9910743.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c9910743.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
end
function c9910743.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(9910743,0)) then
		Duel.Hint(HINT_CARD,0,9910743)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910743.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c9910743.condition(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) and e:GetHandler():IsSummonLocation(LOCATION_HAND)
end
