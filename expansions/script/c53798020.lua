local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro Summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	
	--Effect 1: Draw Trigger
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DRAW)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.drcost)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)

	--Effect 2: Anti-Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.tdcon)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)

	aux.RegisterMergedDelayedEvent(c,id,EVENT_TO_HAND)
end

-- Helpers for Effect 1
function s.cfilter(c,tp)
	local tpe=bit.band(c:GetType(),0x7) -- Get Monster/Spell/Trap type
	-- Must be able to check 2 cards of same type in Deck
	return c:IsControler(tp) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,2,nil,tpe)
end

function s.thfilter(c,tpe)
	return c:IsType(tpe) and (c:IsAbleToHand() or c:IsAbleToGrave())
end

function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.cfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=eg:FilterSelect(tp,s.cfilter,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabel(bit.band(g:GetFirst():GetType(),0x7)) -- Store the type
	e:SetLabelObject(g:GetFirst()) -- Store the card reference
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end -- Logic handled in cost/operation mostly
	local rc=e:GetLabelObject()
	Duel.SetTargetCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,rc,1,0,0)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local rc=Duel.GetFirstTarget()
	if not rc or not rc:IsRelateToEffect(e) then return end
	
	-- Return revealed card to Deck
	if Duel.SendtoDeck(rc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 or not rc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then return end
	
	-- Reveal 2 cards of same type
	local tpe=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil,tpe)
	if g:GetCount()<2 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:Select(tp,2,2,nil)
	Duel.ConfirmCards(1-tp,sg)
	
	-- Opponent selects 1
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SELECT)
	local tg=sg:Select(1-tp,1,1,nil):GetFirst()
	
	-- Opponent chooses: Add to their hand OR Send to their GY
	local b1=tg:IsAbleToHand(1-tp)
	local b2=tg:IsAbleToGrave()
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(1-tp,1190,1191) -- 2:Add to Hand, 3:Send to Grave (Need add strings to database)
	elseif b1 then
		op=Duel.SelectOption(1-tp,1190)
	elseif b2 then
		op=Duel.SelectOption(1-tp,1191)+1
	else
		op=-1
	end
	
	if op==0 then
		Duel.SendtoHand(tg,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,tg)
	elseif op==1 then
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
	
	-- You add the remaining card
	sg:RemoveCard(tg)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

-- Helpers for Effect 2
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.tdfilter,1,nil)
end

function s.tdfilter(c)
	return not c:IsReason(REASON_DRAW)
end

function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,PLAYER_ALL,2)
end

function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	-- Check which player(s) added cards
	local p1=eg:IsExists(Card.IsControler,1,nil,tp)
	local p2=eg:IsExists(Card.IsControler,1,nil,1-tp)
	
	-- Process TP
	if p1 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local ct=math.min(2,g:GetCount())
			local sg=g:Select(tp,ct,ct,nil)
			aux.PlaceCardsOnDeckBottom(tp,sg)
		end
	end
	
	-- Process 1-TP
	if p2 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,1-tp,LOCATION_HAND,0,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
			local ct=math.min(2,g:GetCount())
			local sg=g:Select(1-tp,ct,ct,nil)
			aux.PlaceCardsOnDeckBottom(1-tp,sg)
		end
	end
end