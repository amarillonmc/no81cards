--Beetrooper Descent
function c10105504.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10105504+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10105504.target)
	e1:SetOperation(c10105504.activate)
	c:RegisterEffect(e1)
--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10105504,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10105504)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10105504.thtg)
	e2:SetOperation(c10105504.thop)
	c:RegisterEffect(e2)
end
function c10105504.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10105500,0x7ccd,TYPES_TOKEN_MONSTER,1000,1000,2,RACE_BEAST,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c10105504.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,10105500,0x7ccd,TYPES_TOKEN_MONSTER,1000,1000,2,RACE_BEAST,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,10105500)
	local ec=aux.ExceptThisCard(e)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0
		and Duel.IsExistingMatchingCard(c10105504.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c10105504.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ec)
		and Duel.SelectYesNo(tp,aux.Stringid(10105504,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Duel.SelectMatchingCard(tp,c10105504.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,ec)
		Duel.BreakEffect()
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c10105504.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAttackAbove(1500)
end
function c10105504.dfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c10105504.thfilter(c)
	return c:IsSetCard(0x7ccd) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c10105504.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105504.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10105504.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10105504.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end