--魔导飞行队急袭指令
local cm,m=GetID()
function cm.initial_effect(c)
	if not PNFL_PROPHECY_FLIGHT_CHECK then
		dofile("expansions/script/c11451851.lua")
		pnfl_prophecy_flight_initial(c)
	end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE+TIMING_STANDBY_PHASE)
	e1:SetCondition(function(e,tp) return (Duel.GetCurrentPhase()~=PHASE_MAIN1 and Duel.GetCurrentPhase()~=PHASE_MAIN2) or Duel.GetTurnPlayer()==1-tp end)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_TOSS_COIN_NEGATE)
	e2:SetCondition(cm.coincon)
	e2:SetOperation(cm.coinop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_HAND)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	--e3:SetCondition(function(e,tp,eg) return eg:IsContains(e:GetHandler()) end)
	e3:SetCost(cm.pzcost)
	e3:SetOperation(cm.pzop)
	c:RegisterEffect(e3)
	if not PNFL_ETARGET_CHECK then
		PNFL_ETARGET_CHECK=true
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_BECOME_TARGET)
		ge3:SetOperation(cm.checkop3)
		Duel.RegisterEffect(ge3,0)
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge6:SetCode(EVENT_ADJUST)
		ge6:SetOperation(cm.checkop6)
		Duel.RegisterEffect(ge6,0)
	end
end
function cm.checkop3(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg
	if #tg>0 then
		for tc in aux.Next(eg) do
			local prop=EFFECT_FLAG_SET_AVAILABLE
			if PNFL_ETARGET_HINT or PNFL_DEBUG then prop=prop|EFFECT_FLAG_CLIENT_HINT end
			tc:RegisterFlagEffect(11451541,RESET_EVENT+0x1fc0000,prop,1,0,aux.Stringid(11451541,5))
		end
	end
end
function cm.checkop6(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(cm.ctgfilter,0,0x3c,0x3c,nil)
	if #tg>0 then
		for tc in aux.Next(tg) do
			local prop=EFFECT_FLAG_SET_AVAILABLE
			if PNFL_ETARGET_HINT or PNFL_DEBUG then prop=prop|EFFECT_FLAG_CLIENT_HINT end
			tc:RegisterFlagEffect(11451541,RESET_EVENT+0x1fc0000,prop,1,0,aux.Stringid(11451541,5))
		end
	end
end
function cm.ctgfilter(c)
	return c:GetOwnerTargetCount()>0 and c:GetFlagEffect(11451541)==0
end
function cm.shfilter(c)
	return c:GetFlagEffect(11451541)>0
end
function cm.tgfilter(c,e)
	return c:IsCanBeEffectTarget(e) and c:GetFlagEffect(11451541)==0
end
function cm.seqfilter(c)
	return c:GetSequence()<=2
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0):Filter(cm.seqfilter,nil)
	if chkc then return chkc:IsLocation(0x3c) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,0x3c,0x3c,1,c,e) and #g==3 and g:FilterCount(Card.IsFacedown,nil)>0 end
	if not PNFL_ETARGET_HINT then
		PNFL_ETARGET_HINT=true
		local shg=Duel.GetMatchingGroup(cm.shfilter,tp,0x3c,0x3c,nil)
		for tc in aux.Next(shg) do
			tc:RegisterFlagEffect(11451541,RESET_EVENT+0x1fc0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451541,5))
		end
	end
	Duel.SelectTarget(tp,cm.tgfilter,tp,0x3c,0x3c,1,1,c,e)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0):Filter(cm.seqfilter,nil)
	if #g<3 or g:FilterCount(Card.IsFacedown,nil)==0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local dg=g:Filter(Card.IsFacedown,nil)
	for sc in aux.Next(dg) do
		Duel.DisableShuffleCheck()
		sc:ReverseInDeck()
	end
	Duel.AdjustAll()
	dg:KeepAlive()
	dg:ForEach(Card.RegisterFlagEffect,m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	local ge2=Effect.CreateEffect(c)
	ge2:SetDescription(aux.Stringid(m,10))
	ge2:SetType(EFFECT_TYPE_SINGLE)
	ge2:SetCode(EFFECT_IMMUNE_EFFECT)
	ge2:SetRange(0x3c)
	ge2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SET_AVAILABLE)
	ge2:SetLabelObject(dg)
	ge2:SetValue(cm.chkval)
	ge2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN)
	tc:RegisterEffect(ge2,true)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetCondition(function() return Duel.GetCurrentChain()==1 end)
	e6:SetLabelObject(dg)
	e6:SetOperation(cm.tdop)
	e6:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e6,tp)
	local e7=e6:Clone()
	e7:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e7,tp)
end
function cm.chkval(e,te)
	if te and te:GetHandler() and not te:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) then
		local dg=e:GetLabelObject()
		if dg:IsContains(te:GetHandler()) and te:GetHandler():IsLocation(LOCATION_DECK) then
			te:GetHandler():ResetFlagEffect(m)
		end
	end
	return false
end
function cm.filter1(c)
	return c:GetFlagEffect(m)>0
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(e:GetLabelObject():Filter(cm.filter1,nil),REASON_EFFECT)
end
function cm.coincon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetCode()~=EVENT_TOSS_COIN_NEGATE
end
function cm.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)==0 and Duel.SelectEffectYesNo(tp,c) then
		Duel.ConfirmCards(1-tp,c)
		Duel.Hint(HINT_CARD,0,m)	
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		local res={Duel.GetCoinResult()}
		local ac=1
		local ct=ev
		if ct>1 then
			--choose the index of results
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
			local val,idx=Duel.AnnounceNumber(tp,table.unpack(aux.idx_table,1,ct))
			ac=idx+1
		end
		res[ac]=1
		Duel.SetCoinResult(table.unpack(res))
		--[[local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		cm[c]=e1--]]
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+m,e,0,0,0,0)
	end
end
function cm.pzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) and c:IsLocation(LOCATION_HAND) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,c)
	c:ResetFlagEffect(m)
	--cm[c]:Reset()
	--cm[c]=nil
end
function cm.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e2)
end