--泽塔计划
function c98921048.initial_effect(c)
	aux.AddCodeList(c,64382839)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98921048+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c98921048.target)
	e1:SetOperation(c98921048.activate)
	c:RegisterEffect(e1)	
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98921048,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c98921048.rmtg)
	e2:SetOperation(c98921048.rmop)
	c:RegisterEffect(e2)
end
function c98921048.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,64382840,0,TYPES_TOKEN_MONSTER,500,500,2,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c98921048.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,64382840,0,TYPES_TOKEN_MONSTER,500,500,2,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP) then return end
	local token=Duel.CreateToken(tp,64382840)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c98921048.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(98921048,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c98921048.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
end
function c98921048.thfilter(c)
	return c:IsCode(64382839) and c:IsAbleToHand()
end
function c98921048.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c98921048.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end