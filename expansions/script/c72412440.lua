--神花姬的祝祷
function c72412440.initial_effect(c)
	c:SetUniqueOnField(1,0,72412440)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72412440,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c72412440.sccon)
	e2:SetTarget(c72412440.sctg)
	e2:SetOperation(c72412440.scop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72412440,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,72412440)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c72412440.thtg)
	e3:SetOperation(c72412440.thop)
	c:RegisterEffect(e3)
end
function c72412440.thfilter(c)
	return c:IsSetCard(0xe728) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c72412440.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72412440.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c72412440.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c72412440.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c72412440.filter1(c)
	return c:IsDiscardable(REASON_EFFECT)
end
function c72412440.scfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xe728) and c:IsControler(tp)
end
function c72412440.sccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c72412440.scfilter,1,nil,tp)
end
function c72412440.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c72412440.filter1,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c72412440.scop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return end
	Duel.Draw(p,d,REASON_EFFECT)
end