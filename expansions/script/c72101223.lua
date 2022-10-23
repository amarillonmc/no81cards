--深空的掠夺宣言
function c72101223.initial_effect(c)

	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72101223,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,72101223)
	e1:SetTarget(c72101223.thtg)
	e1:SetOperation(c72101223.thop)
	c:RegisterEffect(e1)
	
	--be remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72101223,4))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,72101224)
	e2:SetTarget(c72101223.brtg)
	e2:SetOperation(c72101223.brop)
	c:RegisterEffect(e2)
end

--to hand
function c72101223.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c72101223.filter1(c,e,tp)
	return c:IsSetCard(0xcea) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c72101223.filter2(c,e,tp)
	return c:IsSetCard(0xcea) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c72101223.filter3(c,e,tp)
	return c:IsSetCard(0xcea) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c72101223.hfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c72101223.hfilter2(c,e,tp)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c72101223.hfilter3(c,e,tp)
	return c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c72101223.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=e:GetLabel()
	--monster
	if  Duel.IsExistingMatchingCard(c72101223.filter1,tp,LOCATION_DECK,0,1,nil) 
		and opt==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local r1=Duel.SelectMatchingCard(tp,c72101223.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if r1:GetCount()>0 then Duel.SendtoHand(r1,nil,REASON_EFFECT) end
	--spell
	elseif Duel.IsExistingMatchingCard(c72101223.filter2,tp,LOCATION_DECK,0,1,nil) 
		and opt==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local r2=Duel.SelectMatchingCard(tp,c72101223.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if r2:GetCount()>0 then Duel.SendtoHand(r2,nil,REASON_EFFECT) end
	--trap
	elseif Duel.IsExistingMatchingCard(c72101223.filter3,tp,LOCATION_DECK,0,1,nil) 
		and opt==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local r3=Duel.SelectMatchingCard(tp,c72101223.filter3,tp,LOCATION_DECK,0,1,1,nil)
		if r3:GetCount()>0 then Duel.SendtoHand(r3,nil,REASON_EFFECT) end
	else return end
	--show hand
	local h=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if h:GetCount()>0 then
		Duel.ConfirmCards(tp,h)
		--monster
		if Duel.IsExistingMatchingCard(c72101223.hfilter1,tp,0,LOCATION_HAND,1,nil)and opt==0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(72101223,1))
			local h1=h:FilterSelect(1-tp,c72101223.hfilter1,1,1,nil)
			local hc1=h1:GetFirst()
			if hc1 then
				Duel.SendtoHand(hc1,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,hc1)
			end
		--spell
		elseif  Duel.IsExistingMatchingCard(c72101223.hfilter2,tp,0,LOCATION_HAND,1,nil) and opt==1 then
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(72101223,2))
			local h2=h:FilterSelect(1-tp,c72101223.hfilter2,1,1,nil)
			local hc2=h2:GetFirst()
			if hc2 then
				Duel.SendtoHand(hc2,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,hc2)
			end
		--trap
		elseif  Duel.IsExistingMatchingCard(c72101223.hfilter3,tp,0,LOCATION_HAND,1,nil) and opt==2 then
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(72101223,3))
			local h3=h:FilterSelect(1-tp,c72101223.hfilter3,1,1,nil)
			local hc3=h3:GetFirst()
			if hc3 then
				Duel.SendtoHand(hc3,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,hc3)
			end
		else 
			--zisu 1
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_TO_HAND)
			e1:SetTargetRange(1,0)
			e1:SetTarget(c72101223.tohlimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		return end
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
	end
	--zisu 1
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_TO_HAND)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c72101223.tohlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c72101223.tohlimit(e,c)
	return c:IsLocation(LOCATION_DECK) and not c:IsSetCard(0xcea)
end

--be remove
function c72101223.czfilter(c)
	return c:IsCode(72101215) and (c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)
		or c:IsLocation(LOCATION_GRAVE))
end
function c72101223.tgfilter(c)
	return c:IsSetCard(0xcea)
end
function c72101223.brtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c72101223.brop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g1==0 then return end
	Duel.HintSelection(g1)
	local tc=g1:GetFirst()
	if Duel.Destroy(tc,REASON_EFFECT)~=0 
		and Duel.IsExistingMatchingCard(c72101223.czfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c72101223.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(72101223,5)) then
		Duel.BreakEffect()
		local g2=Duel.SelectMatchingCard(tp,c72101223.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.Destroy(g2,REASON_EFFECT)
		end
		Duel.ShuffleDeck(tp)
	end
	--zisu 2
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c72101223.sklimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c72101223.sklimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsSetCard(0xcea)
end