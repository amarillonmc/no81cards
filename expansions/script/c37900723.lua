--五彩斑斓的曙光
function c37900723.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),4,3,c37900723.ov,aux.Stringid(37900723,0),3,c37900723.xyzop)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37900723,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_GRAVE_SPSUMMON+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,37900723)
	e3:SetCost(c37900723.cost)
	e3:SetTarget(c37900723.tg)
	e3:SetOperation(c37900723.op)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(37900723,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,37900723+100)
	e4:SetCondition(c37900723.con4)
	e4:SetTarget(c37900723.tg4)
	e4:SetOperation(c37900723.op4)
	c:RegisterEffect(e4)
end
function c37900723.ov(c)
	return c:IsFaceup() and c:IsCode(37900721) 
end
function c37900723.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,37900723-1000)==0 end
	Duel.RegisterFlagEffect(tp,37900723-1000,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c37900723.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c37900723.q(c)
	return (c:IsSetCard(0x381) or c:IsSetCard(0x389)) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c37900723.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37900723.q,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c37900723.w(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,4)>0 and not c:IsHasEffect(291)
end
function c37900723.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c37900723.q,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
	Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c37900723.w,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(37900723,3)) then
		Duel.BreakEffect()
		Duel.Hint(3,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c37900723.w,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end	
	end
end
function c37900723.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c37900723.ov,tp,4,0,1,nil)
end
function c37900723.e(c)
	return c:IsType(6) and c:IsAbleToHand() and (c:IsSetCard(0x381) or c:IsSetCard(0x389))
end
function c37900723.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c37900723.e,tp,1,0,nil)
	if chk==0 then return #g>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,1-tp,1)
end
function c37900723.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c37900723.e,tp,1,0,nil)
	if #g>=3 then
	Duel.Hint(3,tp,HINTMSG_OPERATECARD)
	local sg=g:Select(tp,3,3,nil)
	local g1=sg:RandomSelect(1-tp,1)
	local g2=sg:Filter(aux.TRUE,g1)
	Duel.SendtoHand(g1,tp,REASON_EFFECT) 
	Duel.SendtoHand(g2,1-tp,REASON_EFFECT) 
	end
end