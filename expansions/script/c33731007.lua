--[[
奥数磨人
AsSault of Mind's Range
AsSalto del Dominio della Mente
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[During the End Phase: Add a number of cards from the top of your Deck to your opponent's hand, equal to the number of cards your opponent added to their hand this turn, and if you do, they must apply 1 of the effects.
	● They send the same number of cards from their hand to the GY.
	● They place the same number of cards from their hand on the bottom of their Deck.
	If more than 7 cards have been added to their hand with this effect, they must apply both effects in sequence, instead.]]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORIES_SEARCH|CATEGORY_TOGRAVE|CATEGORY_HANDES|CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER|TIMING_END_PHASE)
	e1:SetCondition(aux.EndPhaseCond())
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	for p=0,1 do
		if not Duel.PlayerHasFlagEffect(p,id) then
			Duel.RegisterFlagEffect(p,id,RESET_PHASE|PHASE_END,0,1,0)
		end
		Duel.UpdateFlagEffectLabel(p,id,g:FilterCount(Card.IsControler,nil,p))
	end
end

--E1
function s.filter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c:HasLevel()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFlagEffectLabel(1-tp,id)
	if chk==0 then
		if not ct or ct<=0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return false end
		local g=Duel.GetDecktopGroup(tp,ct)
		return not g:IsExists(aux.NOT(Card.IsAbleToHand),1,nil,1-tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_DECK)
end
function s.tgfilter(c,p)
	if c:IsHasEffect(EFFECT_CANNOT_TO_GRAVE) then return false end
	local eset={Duel.IsPlayerAffectedByEffect(p,EFFECT_CANNOT_TO_GRAVE)}
	for _,e in ipairs(eset) do
		local tg=e:GetTarget()
		if type(tg)~="function" or tg(e,c,p) then
			return false
		end
	end
	return true
end
function s.tdfilter(c,p)
	if c:IsStatus(STATUS_LEAVE_CONFIRMED) or c:IsHasEffect(EFFECT_CANNOT_TO_DECK) then return false end
	local eset={Duel.IsPlayerAffectedByEffect(p,EFFECT_CANNOT_TO_DECK)}
	for _,e in ipairs(eset) do
		local tg=e:GetTarget()
		if type(tg)~="function" or tg(e,c,p) then
			return false
		end
	end
	return true
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffectLabel(1-tp,id)
	if not ct or ct<=0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return false end
	local g=Duel.GetDecktopGroup(tp,ct)
	local tg=g:Filter(Card.IsAbleToHand,nil,1-tp)
	if Duel.SendtoHand(tg,1-tp,REASON_EFFECT)==#g then
		local n=Duel.GetOperatedGroup():FilterCount(aux.PLChk,nil,1-tp,LOCATION_HAND)
		if n==#g then
			Duel.ShuffleHand(1-tp)
			local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			Debug.Message(n)
			local opt=(n>7) and 3 or 0
			if opt==0 then
				local b1=hg:IsExists(s.tgfilter,n,nil,1-tp)
				local b2=hg:IsExists(s.tdfilter,n,nil,1-tp)
				opt=aux.Option(1-tp,id,1,b1,b2)+1
			end
			
			local step=false
			if opt&1==1 then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
				local tg=hg:FilterSelect(1-tp,s.tgfilter,n,n,nil,1-tp)
				if #tg>0 and Duel.SendtoGrave(tg,REASON_EFFECT)>0 then
					step=true
				end
			end
			
			local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			if opt&2==2 then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
				local tg=hg:FilterSelect(1-tp,s.tdfilter,n,n,nil,1-tp)
				if #tg>0 then
					if step then
						Duel.BreakEffect()
					end
					Duel.SendtoDeck(tg,1-tp,SEQ_DECKTOP,REASON_EFFECT)
					local rg=Duel.GetOperatedGroup()
					local og=rg:Filter(Card.IsLocation,nil,LOCATION_DECK)
					local ct1=og:FilterCount(Card.IsControler,nil,tp)
					local ct2=og:FilterCount(Card.IsControler,nil,1-tp)
					if ct1>0 then
						if ct1>1 then
							Duel.SortDecktop(1-tp,tp,ct1)
						end
						for i=1,ct1 do
							local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
							Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
						end
					end
					if ct2>0 then
						if ct2>1 then
							Duel.SortDecktop(1-tp,1-tp,ct2)
						end
						for i=1,ct2 do
							local tc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
							Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
						end
					end
				end
			end
		end
	end
end