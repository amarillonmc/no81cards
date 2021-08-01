--喜欢恰糕点的竹子
function c60002002.initial_effect(c)
	--Recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c60002002.rccon)
	e1:SetCost(c60002002.rccost)
	e1:SetTarget(c60002002.rcop2)
	e1:SetOperation(c60002002.rcop)
	c:RegisterEffect(e1)
	--to hand and to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c60002002.ttcost)
	e2:SetTarget(c60002002.tttg)
	e2:SetOperation(c60002002.ttop)
	c:RegisterEffect(e2)

end
function c60002002.cfilter1(c)
	return not c:IsRace(RACE_PLANT) and not c:IsRace(RACE_BEAST)
end
function c60002002.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and not Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil) and not Duel.IsExistingMatchingCard(c60002002.cfilter1,tp,LOCATION_MZONE,0,1,nil) 
end
function c60002002.rccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SelectOption(tp,aux.Stringid(60002002,0))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(60002002,0))
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c60002002.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(6230130)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,6230130)
end
function c60002002.rcop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.SetLP(tp,Duel.GetLP(tp)-6298763)
end
function c60002002.rcop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)+6230130)
end
function c60002002.ctfil(c)
	return c:IsAbleToRemoveAsCost() and c:IsCode(98818516)
end
function c60002002.ttcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c60002002.ctfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SelectOption(tp,aux.Stringid(60002002,0))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(60002002,0))
	local g=Duel.SelectMatchingCard(tp,c60002002.ctfil,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c60002002.thfil(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL) and c:IsSetCard(0x623)
end
function c60002002.tttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60002002.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60002002.ttop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60002002.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	Duel.BreakEffect()
	local dg=Duel.SelectMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil)
	Duel.SendtoDeck(dg,tp,2,REASON_EFFECT)
end










