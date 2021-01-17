--人理之诗 邀至心荡神驰的黄金剧场
function c22020140.initial_effect(c)
	aux.AddCodeList(c,22020130)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22020140+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22020140.target)
	e1:SetOperation(c22020140.activate)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetCondition(c22020140.con)
	c:RegisterEffect(e2)
end
function c22020140.filter(c)
	return c:IsCode(22020130) and c:IsAbleToHand()
end
function c22020140.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22020140.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22020140.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22020140.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22020140.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22020140.con(e)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return Duel.IsExistingMatchingCard(c22020140.atkfilter,c:GetControler(),LOCATION_MZONE,0,1,nil) and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE )
end