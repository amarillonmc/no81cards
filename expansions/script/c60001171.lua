--少佐的眼
function c60001171.initial_effect(c)
	aux.AddCodeList(c,60001179)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c60001171.con)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c60001171.thcon)
	e1:SetTarget(c60001171.thtg)
	e1:SetOperation(c60001171.thop)
	c:RegisterEffect(e1)

	if not c60001171.global_check then
		c60001171.global_check=true
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SSET)
		e2:SetCondition(c60001171.setcon)
		e2:SetOperation(c60001171.setop)
		Duel.RegisterEffect(e2,0)
	end
end
function c60001171.confil(c)
	return c:IsCode(60001179) and c:IsFaceup()
end
function c60001171.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60001171.confil,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c60001171.setter(c)
	return c:IsCode(60001171) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c60001171.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60001171.setter,1,nil)
end
function c60001171.setop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(c60001171.setter,nil)
	for tc in aux.Next(tg) do
		tc:RegisterFlagEffect(60001168,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c60001171.cdter(c)
	return c:IsFaceup() and c:IsCode(60001179)
end
function c60001171.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60001171.cdter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c60001171.filter(c)
	return c:IsCode(60001171) and c:IsAbleToHand()
end
function c60001171.filter2(c)
	return aux.IsCodeListed(c,60001179) and not c:IsCode(60001179,60001171) and c:IsAbleToHand()
end
function c60001171.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60001171.filter2,tp,LOCATION_DECK,0,1,nil) end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60001171.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c60001171.filter2,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c60001171.filter2,tp,LOCATION_DECK,0,1,1,tc)
		if #g>0 then
			local sl=Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			if sl>0 and c:GetFlagEffect(60001168)>0 and c:IsLocation(LOCATION_SZONE) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(60001171,1)) then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end