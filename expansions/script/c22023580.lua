--人理之基 堂·吉诃德
function c22023580.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c22023580.ffilter,2,true)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023580,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,22023580)
	e1:SetCondition(c22023580.thcon)
	e1:SetOperation(c22023580.thop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023580,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22023581)
	e2:SetCondition(c22023580.tdcon)
	e2:SetTarget(c22023580.thtg1)
	e2:SetOperation(c22023580.thop1)
	c:RegisterEffect(e2)
	--search ere
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023580,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22023581)
	e3:SetCondition(c22023580.tdcon1)
	e3:SetCost(c22023580.erecost)
	e3:SetTarget(c22023580.thtg1)
	e3:SetOperation(c22023580.thop1)
	c:RegisterEffect(e3)
end
function c22023580.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0xff1) and c:IsLevelBelow(4)
end
function c22023580.atfilter(c)
	return c:IsSetCard(0xff1) and c:IsFaceup()
end
function c22023580.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22023580.atfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c22023580.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c22023580.atfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	if #g==0 then return end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetValue(0)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)
	end
	Duel.NegateAttack()
end
function c22023580.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackBelow(1800)
end
function c22023580.thfilter(c)
	return c:IsCode(22023590) and c:IsAbleToHand()
end
function c22023580.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023580.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22023580.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22023580.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22023580.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22023580.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackBelow(1800) and Duel.IsPlayerAffectedByEffect(tp,22020980)
end