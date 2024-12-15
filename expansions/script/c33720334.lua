--[[【背景音台】Subways of Your Mind
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id,o=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
Duel.LoadScript("glitchylib_soundstage.lua")
function s.initial_effect(c)
	aux.AddSoundStageProc(c,c:Activation(),id,4,4)
	local FZChk=aux.AddThisCardInFZoneAlreadyCheck(c)
	--[[If the turn player Summons a monster(s) during their Main Phase: End that Main Phase.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetLabelObject(FZChk)
	e1:SetFunctions(
		aux.AND(aux.MainPhaseCond(),aux.AlreadyInRangeEventCondition(s.cfilter)),
		nil,
		nil,
		s.mpskip
	)
	c:RegisterEffect(e1)
	e1:SpecialSummonEventClone(c)
	e1:FlipSummonEventClone(c)
	--[[If the turn player activates a card or effect during their Main Phases (Quick Effect): End that Main Phase immediately after that effect resolves.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetFunctions(
		s.chcon,
		nil,
		nil,
		s.regop
	)
	c:RegisterEffect(e2)
	--[[If the turn player's opponent took damage during the turn player's Battle Phase: End that Battle Phase immediately.]]
	local e3=e1:Clone()
	e3:Desc(2,id)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetCondition(s.bpskipcon)
	e3:SetOperation(s.bpskip)
	c:RegisterEffect(e3)
	--[[During the turn player's End Phase, if they have not added a card(s) from their Deck to their hand during this turn (without counting the ones they drew): They draw a number of cards equal to
	the number of Phases ended by this card's effect during this turn, and if they do, they must return the same number of cards from their hand and/or GY to the bottom of their Deck, in any order.]]
	local e4=Effect.CreateEffect(c)
	e4:Desc(3,id)
	e4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE|PHASE_END)
	e4:SetRange(LOCATION_FZONE)
	e4:OPT()
	e4:SetFunctions(
		s.thcon,
		nil,
		s.thtg,
		s.thop
	)
	c:RegisterEffect(e4)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkfilter(c,p)
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsPreviousControler(p) and c:IsControler(p) and not c:IsReason(REASON_DRAW)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if eg:IsExists(s.checkfilter,1,nil,p) then
			Duel.RegisterFlagEffect(p,id,RESET_PHASE|PHASE_END,0,1)
		end
	end
end

--E1
function s.cfilter(c)
	return c:IsSummonPlayer(Duel.GetTurnPlayer())
end
function s.mpskip(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	Duel.SkipPhase(Duel.GetTurnPlayer(),ph,RESET_PHASE|ph,1)
	Duel.RegisterFlagEffect(0,id+100,RESET_PHASE|PHASE_END,0,1)
end

--E2
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase() and rp==Duel.GetTurnPlayer() and re:GetHandler():GetOriginalCode()~=id
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetLabel(Duel.GetCurrentChain()-1)
	e3:SetCondition(s.mpskipcon)
	e3:SetOperation(s.mpskip)
	e3:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e3,tp)
end
function s.mpskipcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==Duel.GetTurnPlayer() and Duel.GetCurrentChain()==e:GetLabel() and re:GetHandler():GetOriginalCode()~=id
end

--E3
function s.bpskipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsBattlePhase() and ep==1-Duel.GetTurnPlayer()
end
function s.bpskip(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE|PHASE_BATTLE_STEP,1)
	Duel.RegisterFlagEffect(0,id+100,RESET_PHASE|PHASE_END,0,1)
end

--E4
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.PlayerHasFlagEffect(Duel.GetTurnPlayer(),id)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFlagEffect(0,id+100)
	if ct and ct>0 then
		e:SetCategory(CATEGORY_DRAW|CATEGORY_TODECK)
		local p=Duel.GetTurnPlayer()
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,p,ct)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,ct,p,LOCATION_HAND|LOCATION_GRAVE)
	else
		e:SetCategory(0)
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(0,id+100)
	if not ct or ct==0 then return end
	local p=Duel.GetTurnPlayer()
	local dc=Duel.Draw(p,ct,REASON_EFFECT)
	if dc>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local rg=Duel.Select(HINTMSG_TODECK,false,p,aux.Necro(Card.IsAbleToDeck),p,LOCATION_HAND|LOCATION_GRAVE,0,dc,dc,nil)
		if #rg>0 then
			Duel.ShuffleHand(p)
			Duel.HintSelection(rg:Filter(Card.IsLocation,nil,LOCATION_GRAVE))
			aux.PlaceCardsOnDeckBottom(p,rg)
		end
	end
end