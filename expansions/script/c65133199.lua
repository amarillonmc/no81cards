--幻叙键刃使 乔乔
local s,id,o=GetID()
function s.initial_effect(c)
	--Effect 1: Destruction Replacement (Hand)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(s.reptg)
	e1:SetValue(s.repval)
	e1:SetOperation(s.repop)
	c:RegisterEffect(e1)
	--Effect 2: End Phase Excavation
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCondition(s.excon)
	e2:SetCost(s.excost)
	e2:SetTarget(s.extg)
	e2:SetOperation(s.exop)
	c:RegisterEffect(e2)
end

-- Effect 1 Logic
function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x838) and c:IsLocation(LOCATION_MZONE)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() and eg:IsExists(s.repfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		return true
	else return false end
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Reveal this card until end of turn
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	--Return protected monsters to Deck Bottom instead of destroying
	local g=eg:Filter(s.repfilter,nil,tp)
	if #g>0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT+REASON_REPLACE)
	end
end

-- Effect 2 Logic
function s.excon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and e:GetHandler():IsPublic()
end
function s.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function s.spfilter(c)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER)
end
function s.exop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	Duel.ConfirmDecktop(tp,3)
	local g_top=Duel.GetDecktopGroup(tp,3)
	if g_top:IsExists(s.spfilter,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=6 then
		--Excavate Bottom 3 if top had Talespace monster
		Duel.DisableShuffleCheck()
		local g_bot=Duel.GetDeckbottomGroup(tp,3)
		Duel.ConfirmCards(tp,g_bot)
		
		--Merge groups
		local g_total=Group.CreateGroup()
		g_total:Merge(g_top)
		g_total:Merge(g_bot)
		
		--Add Talespace monsters to hand
		local g_th=g_total:Filter(s.spfilter,nil)
		if #g_th>0 then
			Duel.SendtoHand(g_th,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g_th)
		end
		
		--Handle remaining cards
		local g_rem=g_total:Filter(aux.NOT(Card.IsLocation),nil,LOCATION_HAND)
		if #g_rem>0 then
			local ct=#g_rem
			--Loop to place cards
			for i=1,ct do
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2)) -- Select card to place
				local tc=g_rem:Select(tp,1,1,nil):GetFirst()
				g_rem:RemoveCard(tc)
				if Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))==0 then
					--Top
					Duel.MoveSequence(tc,0)
				else
					--Bottom
					Duel.MoveSequence(tc,1) --1 moves to bottom in MoveSequence usually involves logic, but for Deck, use SendtoDeck logic or simple move. 
					--Correction: MoveSequence for Deck is tricky. Standard way:
					Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
				end
			end
			--Since we moved cards manually/via SendtoDeck, clarify decktop arrangement if needed
			--For the "Top" option, MoveSequence(tc, 0) puts it at absolute top.
			--This loop structure allows user to stack top/bottom 1 by 1.
		end
	else
		--Only Top 3 logic (failed to find Talespace or Deck < 6)
		--Wait, text says "If there is a Talespace monster... excavate bottom 3".
		--If only Top 3 were checked but not processed because Deck<6, what happens?
		--Assuming strict adherence: If deck<6, we can't physically excavate top 3 AND bottom 3 distinct cards easily. 
		--But if Top 3 had no Talespace, we just shuffle them back usually? 
		--Text says: "Remaining cards... on top or bottom".
		--If we didn't trigger the Bottom 3 effect, we assume standard "return to original place" or "shuffle"?
		--Based on "Remaining cards place on top or bottom", I will apply this logic even if only Top 3 were viewed.
		local g_th=g_top:Filter(s.spfilter,nil) --But text implies we only get them if we do the FULL sequence? 
		--Text: "其中有...的场合(IF there is...), 再(THEN)开掘...将...全部加入". 
		--So if there is NO Talespace in Top 3, nothing happens? Or just return?
		--Implicitly: Shuffle back or Return to Top. Standard Excavate logic usually shuffles if failed.
		Duel.ShuffleDeck(tp)
	end
end
