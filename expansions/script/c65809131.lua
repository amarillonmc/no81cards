--资源获取·联合剥削
function c65809131.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c65809131.cost)
	e1:SetTarget(c65809131.target)
	e1:SetOperation(c65809131.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65809131,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65809131)
	e2:SetCondition(c65809131.thcon)
	e2:SetTarget(c65809131.thtg)
	e2:SetOperation(c65809131.thop)
	c:RegisterEffect(e2)
end
function c65809131.tgfilter(c)
	return c:IsCode(65809001) and c:IsAbleToGraveAsCost()
end
function c65809131.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65809131.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c65809131.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c65809131.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c65809131.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_FACEUP)
	local sg1=g:Select(1-tp,1,#g,nil)
	Duel.HintSelection(sg1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg2=g:Select(tp,#sg1,#sg1,nil)
	Duel.HintSelection(sg2)
	sg1:Merge(sg2)
	--atk
	for tc in aux.Next(sg1) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(65809131,3))
		e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_QUICK_F)
		e1:SetCode(EVENT_CHAINING)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
		e1:SetCondition(c65809131.atkcon)
		e1:SetOperation(c65809131.atkop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65809131,2))
	end
end
function c65809131.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler()
end
function c65809131.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:GetAttack()<500 or c:GetDefense()<500 or c:IsStatus(STATUS_BATTLE_DESTROYED) then return end
	local preatk=c:GetAttack()
	local predef=c:GetDefense()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetValue(-500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	if preatk~=0 and c:GetAttack()==0 or predef~=0 and c:GetDefense()==0 then Duel.Destroy(c,REASON_EFFECT) end
end
function c65809131.cfilter(c,tp)
	return c:GetOwner()==1-tp and c:IsControler(tp)
end
function c65809131.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65809131.cfilter,1,nil,tp)
end
function c65809131.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c65809131.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
