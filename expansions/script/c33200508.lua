--法律的执行者
function c33200508.initial_effect(c)
	aux.AddCodeList(c,33200500)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33200508+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c33200508.activate)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c33200508.atkcon)
	e2:SetTarget(c33200508.atktg)
	e2:SetOperation(c33200508.atkop)
	c:RegisterEffect(e2)
end

--e1
function c33200508.filter(c)
	return aux.IsCodeListed(c,33200500) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
end
function c33200508.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c33200508.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(33200508,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoHand(sg,nil,REASON_EFFECT) then
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

--e2
function c33200508.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetFlagEffect(33200500)>0 and re:IsActiveType(TYPE_MONSTER) and rp==tp
end
function c33200508.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c33200508.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-500)
		tc:RegisterEffect(e1)
	end
end