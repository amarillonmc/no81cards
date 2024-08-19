--元素创想
function c60010101.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c60010101.cfmop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60010101,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c60010101.thcon)
	e2:SetTarget(c60010101.thtg)
	e2:SetOperation(c60010101.thop)
	c:RegisterEffect(e2)	
end
--
function c60010101.cfmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=3 then return end
	if Duel.ConfirmDecktop(tp,3)~=0 then
		local g=Duel.GetDecktopGroup(tp,3)
		if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
			e:GetHandler():RegisterFlagEffect(60010095,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60010095,2))
		end
		if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then
			e:GetHandler():RegisterFlagEffect(60010096,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60010095,3))
		end
		if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then
			e:GetHandler():RegisterFlagEffect(60010097,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60010095,4))
		end
	end
end
--
function c60010101.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Card.GetFlagEffect(c,60010095)~=0 and Card.GetFlagEffect(c,60010096)~=0 and Card.GetFlagEffect(c,60010097)~=0
end
function c60010101.thfilter(c)
	return c:IsSetCard(0x634) and c:IsAbleToHand() 
end
function c60010101.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c60010101.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil) end
end
function c60010101.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c60010101.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(60010101,0)) then
				Duel.BreakEffect()
				Duel.ShuffleDeck(tp)
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end


