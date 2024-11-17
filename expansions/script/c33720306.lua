--[[敢死叉日→绝体绝命810！
Crossday, Daredevil of BranD-810!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[(Quick Effect): You can discard this card; each player can take 1 card that was sent to their GY this turn, and shuffle it into their Deck,
	and if a player shuffled a card this way, they draw 1 additional card for their normal draw during their next Draw Phase.]]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK|CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:HOPT()
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(aux.DiscardSelfCost)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
	--[[If this card is sent to the GY: Reveal 3 "BranD-810!" cards from your Deck, including a Field Spell, your opponent randomly chooses any number
	of them to banish face down, and if they do, you add those cards to your hand during the Xth Standby Phase after this effect resolves.
	(X is the number of cards banished this way). Also, shuffle the rest back into the Deck.]]
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_REMOVE|CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:HOPT()
	e2:SetTarget(s.applytg)
	e2:SetOperation(s.applyop)
	c:RegisterEffect(e2)
end

--E1
function s.tdsfilter(c,tid)
	return c:IsAbleToDeck() and c:GetTurnID()==tid
end
function s.tdofilter(c,p,tid)
	return not c:IsHasEffect(EFFECT_CANNOT_TO_DECK) and Duel.IsPlayerCanSendtoDeck(p,c) and c:GetTurnID()==tid
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local tid=Duel.GetTurnCount()
		return Duel.IsExists(false,s.tdsfilter,tp,LOCATION_GRAVE,0,1,nil,tid) or Duel.IsExists(false,s.tdofilter,tp,0,LOCATION_GRAVE,1,nil,1-tp,tid)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,2,PLAYER_ALL,LOCATION_GRAVE)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tid=Duel.GetTurnCount()
	for p in aux.TurnPlayers() do
		local g=p==tp and Duel.Group(s.tdsfilter,tp,LOCATION_GRAVE,0,nil,tid) or Duel.Group(s.tdofilter,tp,0,LOCATION_GRAVE,nil,1-tp,tid)
		if #g>0 and Duel.SelectYesNo(p,aux.Stringid(id,1)) then
			Duel.HintMessage(p,HINTMSG_TODECK)
			local tg=g:Select(p,1,1,nil)
			local tc=tg:GetFirst()
			Duel.HintSelection(tg)
			if Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT,p)>0 and tc:IsLocation(LOCATION_DECK|LOCATION_EXTRA) and aux.BecauseOfThisEffect(e)(tc) then
				local e1=Effect.CreateEffect(c)
				e1:SetCustomCategory(CATEGORY_ADDITIONAL_DRAW_COUNT)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_DRAW_COUNT)
				e1:SetTargetRange(1,0)
				e1:SetReset(RESET_PHASE|PHASE_DRAW|RESET_SELF_TURN)
				e1:SetCondition(s.drawcon)
				e1:SetValue(s.drawval)
				e1:SetOwnerPlayer(p)
				Duel.RegisterEffect(e1,p)
			end
		end
	end
end
function s.drawcon()
	return not s.PreventLoop
end
function s.drawval(e,readonly)
	if readonly then return 1 end
	local tp=e:GetOwnerPlayer()
	s.PreventLoop=true
	local count=Duel.GetDrawCount(tp)
	s.PreventLoop=false
	local add=0
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DRAW_COUNT)}
	for _,ce in ipairs(eset) do
		if ce:IsHasCustomCategory(CATEGORY_ADDITIONAL_DRAW_COUNT) then
			local ct=ce:Evaluate(true)
			add=add+ct
		else
			local val=ce:Evaluate()
			if val>count then
				count=val
			end
		end
	end
	return count+add
end

--E2
function s.applytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function s.applyop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(s.rvfilter,tp,LOCATION_DECK,0,nil,1-tp)
	if #g<3 or not g:IsExists(Card.IsSpell,1,nil,TYPE_FIELD) then return end
	local rg=aux.SelectUnselectGroup(g,e,tp,3,3,s.rgcheck,1,tp,HINTMSG_CONFIRM)
	if #rg==3 then
		Duel.ConfirmCards(1-tp,rg)
		local ct=Duel.AnnounceNumberMinMax(1-tp,1,3)
		local bg=rg:RandomSelect(rg,ct)
		if Duel.Remove(bg,POS_FACEDOWN,REASON_EFFECT,1-tp)>0 then
			local tg=Duel.GetGroupOperatedByThisEffect(e):Filter(Card.IsLocation,nil,LOCATION_REMOVED):Filter(Card.IsFacedown,nil)
			local x=#tg
			if x>0 then
				tg:KeepAlive()
				local fid=e:GetFieldID()
				for tc in aux.Next(tg) do
					tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_STANDBY,EFFECT_FLAG_CLIENT_HINT,x,fid,aux.Stringid(id,3))
				end
				local spchk=Duel.GetCurrentPhase()>PHASE_STANDBY and 0 or -1
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(id,4))
				e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
				e1:OPT()
				e1:SetLabel(Duel.GetTurnCount()+x+spchk,fid)
				e1:SetLabelObject(tg)
				e1:SetCondition(s.thcon)
				e1:SetOperation(s.thop)
				e1:SetReset(RESET_PHASE|PHASE_STANDBY,x)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function s.rvfilter(c,p)
	return c:IsSetCard(ARCHE_BRAND_810) and c:IsAbleToRemove(p,POS_FACEDOWN,REASON_EFFECT)
end
function s.rgcheck(g,e,tp,mg,c)
	if #g==1 and c then
		local res=c:IsSpell(TYPE_FIELD)
		return res, not res
	end
	return true
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tct,fid=e:GetLabel()
	local g=e:GetLabelObject()
	if not g or not g:IsExists(Card.HasFlagEffectLabel,1,nil,id,fid) then
		if g then
			g:DeleteGroup()
		end
		e:Reset()
		return false
	end
	local turn=Duel.GetTurnCount()
	if turn~=tct then
		e:GetHandler():SetTurnCounter(math.abs(tct-turn))
		return false
	end
	return true
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local _,fid=e:GetLabel()
	local g=e:GetLabelObject()
	if not g then return end
	local tg=g:Filter(Card.HasFlagEffectLabel,nil,id,fid)
	if #tg>0 then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
	g:DeleteGroup()
end