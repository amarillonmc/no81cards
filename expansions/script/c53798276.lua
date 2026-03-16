local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,9,2)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.negcon)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
	--Change effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.chcon)
	e2:SetCost(s.chcost)
	e2:SetTarget(s.chtg)
	e2:SetOperation(s.chop)
	c:RegisterEffect(e2)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and rp==1-tp and Duel.IsChainDisablable(ev) and not Duel.IsChainDisabled(ev)
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
		and Duel.GetFlagEffect(tp,id)==0
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,id)==0 and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		if Duel.NegateEffect(ev) then
			Duel.BreakEffect()
			c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
			local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
			g1:Merge(g2)
			if #g1>0 then
				Duel.ConfirmCards(tp,g1)
				if g1:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
					Duel.ShuffleHand(1-tp)
				end
			end
		end
	end
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	local ty=re:GetActiveType()
	return Duel.GetTurnPlayer()~=tp and rp==1-tp and (re:IsActiveType(TYPE_MONSTER)
		or (ty==TYPE_SPELL or ty==TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
		and Duel.GetFlagEffect(tp,id)==0
end
function s.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g1=Duel.GetFieldGroup(rp,LOCATION_HAND,0)
		local g2=Duel.GetMatchingGroup(Card.IsFacedown,rp,LOCATION_ONFIELD,0,nil)
		return #g1>0 or #g2>0
	end
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,0,nil)
	g1:Merge(g2)
	if #g1>0 then
		Duel.ConfirmCards(1-tp,g1)
		if g1:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
			Duel.ShuffleHand(tp)
		end
	end
end