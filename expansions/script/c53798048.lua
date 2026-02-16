local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	
	--Activate Limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.aclimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTargetRange(0,1)
	e2:SetValue(s.aclimit2)
	c:RegisterEffect(e2)
	
	--Destroy and Send to Grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end

--Helper: Filter for Field, Continuous Spell, Continuous Trap
function s.typefilter(c)
	return c:IsType(TYPE_FIELD) or c:IsType(TYPE_CONTINUOUS)
end

--Effect 1: Activation Limit Logic
function s.aclimit(e,re,tp)
	--Check if the player trying to activate (tp) has duplicate Field/ContSpell/ContTrap in GY
	local g=Duel.GetMatchingGroup(s.typefilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetClassCount(Card.GetCode)<g:GetCount() then
		return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
	end
	return false
end
function s.aclimit2(e,re,tp)
	local g=Duel.GetMatchingGroup(s.typefilter,1-tp,LOCATION_GRAVE,0,nil)
	if g:GetClassCount(Card.GetCode)<g:GetCount() then
		return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
	end
	return false
end

--Effect 2: Target Filter
function s.tgfilter(c,tp)
	if not s.typefilter(c) then return false end
	if c:IsFacedown() and c:IsType(TYPE_CONTINUOUS) then return false end
	--Special ruling: If targeting own card, Deck must have same type. 
	--If targeting opponent's, ignore Deck check (always true).
	if c:IsControler(tp) then
		return Duel.IsExistingMatchingCard(s.sendfilter,tp,LOCATION_DECK,0,1,nil,c)
	else
		return true
	end
end

--Helper: Match specific sub-type for sending to GY
function s.sendfilter(c,tc)
	--Must be same specific type (Field, Cont Spell, or Cont Trap)
	if tc:IsType(TYPE_FIELD) and c:IsType(TYPE_FIELD) then return true end
	if tc:IsType(TYPE_SPELL) and tc:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) then return true end
	if tc:IsType(TYPE_TRAP) and tc:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) then return true end
	return false
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	--Note: We don't set TOGRAVE info strictly for Deck because if target is opponent's, we don't know if they have cards
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=tc:GetControler()
		--Cache type info before destruction to ensure accuracy
		--However, effect text says "same type as that card", usually implies checking the card on field or as it was.
		--We check validity based on the card object provided to sendfilter.
		
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			--Controller sends 1 card of same type from Deck to GY
			local g=Duel.GetMatchingGroup(s.sendfilter,p,LOCATION_DECK,0,nil,tc)
			if #g>0 then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
				local sg=g:Select(p,1,1,nil)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			else
				--If opponent has no matching cards, verify Deck (Standard procedure) or do nothing
				--In automated sims, if count is 0, nothing happens naturally.
				local cg=Duel.GetFieldGroup(p,LOCATION_DECK,0)
				if #cg>0 and p~=tp then
				   Duel.ConfirmCards(1-p,cg)
				   Duel.ShuffleDeck(p)
				end
			end
		end
	end
end