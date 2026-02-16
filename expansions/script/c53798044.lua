local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro Summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	--Effect 1: Topdeck manipulation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.toptg)
	e1:SetOperation(s.topop)
	c:RegisterEffect(e1)
	--Effect 2: Gamble Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.negcon)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
end

function s.toptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_SPELL+TYPE_TRAP) end
end

function s.topop(e,tp,eg,ep,ev,re,r,rp)
	--Player part: Search to top [Cite: 2]
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
	end
	--Opponent part: Hand to top (Optional) [Cite: 5, 6]
	local og=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if #og>0 and Duel.SelectYesNo(1-tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
		local sg=og:Select(1-tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Trigger on other card effects & Check if disablable [Cite: 8]
	return re:GetHandler()~=c and Duel.IsChainDisablable(ev)
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--Must ensure opponent can draw to activate [Cite: 14]
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	--Opponent declares [Cite: 10, 11]
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(1-tp)
	--Opponent draws
	if Duel.Draw(1-tp,1,REASON_EFFECT)~=0 then
		local dc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(tp,dc) -- Confirm to both [Cite: 15]
		
		--Check match
		if dc:IsCode(ac) then
			--Match: Negate & Destroy [Cite: 7]
			if Duel.NegateEffect(0) and e:GetHandler():IsRelateToEffect(e) then
				Duel.Destroy(e:GetHandler(),REASON_EFFECT)
			end
			Duel.ShuffleHand(1-tp)
		else
			--Not match: Self declares
			Duel.ShuffleHand(1-tp)
			if Duel.IsPlayerCanDraw(tp,1) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
				local ac2=Duel.AnnounceCard(tp)
				--Self draws
				if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
					local dc2=Duel.GetOperatedGroup():GetFirst()
					Duel.ConfirmCards(1-tp,dc2)
					
					--Check match
					if dc2:IsCode(ac2) then
						if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
							Duel.Destroy(eg,REASON_EFFECT)
						end
					end
					Duel.ShuffleHand(tp)
				end
			end
		end
	end
end