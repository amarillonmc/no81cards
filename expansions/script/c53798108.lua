--Card Effect: Tuner + 1+ non-Tuner monsters
--Effect 1: Negate monster effect (Cost: Return 1 hand to deck top). Then Turn Player returns 1 hand to deck bottom.
--Effect 2: Both players' Main Phase (Ignition-like via BOTH_SIDE): If hand <= 1, both draw 1, then Opponent returns 1 hand to deck bottom.

local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	Auxiliary.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.negcon)
	e1:SetCost(s.negcost)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
	
	--draw & deck bottom (Both players can activate)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	--Referencing c33550694 (Fusion Gate) for "Both players... can activate"
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE) 
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.drcon)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
end

--Effect 1 Functions
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	--Referencing c1712616 (Beetle Trooper) logic
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end

function s.negcostfilter(c,tp)
	--Referencing c30068120 (Edge Imp Sabres) for "AbleToDeckAsCost"
	if not c:IsAbleToDeckAsCost() then return false end
	--Requirement: Check if Turn Player has hand cards able to go to deck bottom
	local turnp=Duel.GetTurnPlayer()
	return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,turnp,LOCATION_HAND,0,1,c)
end

function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.negcostfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.negcostfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	--Referencing c30068120: Return to deck top
	Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_COST)
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,Duel.GetTurnPlayer(),LOCATION_HAND)
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	--Referencing c1712616: Negate and Destroy
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Destroy(eg,REASON_EFFECT)~=0 then
			--Then Turn Player returns 1 hand card to deck bottom
			local turnp=Duel.GetTurnPlayer()
			local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,turnp,LOCATION_HAND,0,nil)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,turnp,HINTMSG_TODECK)
				local sg=g:Select(turnp,1,1,nil)
				Duel.SendtoDeck(sg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
			end
		end
	end
end

--Effect 2 Functions
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	--Condition: Main Phase (Implied by Ignition) and Hand <= 1
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=1
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	--Both draw 1
	local d1=Duel.Draw(tp,1,REASON_EFFECT)
	local d2=Duel.Draw(1-tp,1,REASON_EFFECT)
	if d1>0 and d2>0 then
		--Then opponent (1-tp) returns 1 hand card to deck bottom
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,1-tp,LOCATION_HAND,0,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoDeck(sg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
	end
end