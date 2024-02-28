--魔导飞行队 斯通·海尔
local cm,m=GetID()
function cm.initial_effect(c)
	if not PNFL_PROPHECY_FLIGHT_CHECK then
		dofile("expansions/script/c11451851.lua")
		pnfl_prophecy_flight_initial(c)
	end
	--check
	local e0=Effect.CreateEffect(c)
	e0:SetCode(EVENT_TO_DECK)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetOperation(function(e) cm[e:GetHandler()]=Duel.GetCurrentPhase() end)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COIN+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--road to the top
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_DECK)
	e2:SetCondition(function(e) return e:GetHandler():IsFaceup() and not pnfl_adjusting end)
	e2:SetOperation(cm.adjustop)
	c:RegisterEffect(e2)
	local e7=e2:Clone()
	e7:SetCode(EVENT_MOVE)
	--c:RegisterEffect(e7)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(11451851)
	--e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(function(e) return e:GetHandler():IsFaceup() end)
	c:RegisterEffect(e3)
	--I have the highground!
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_DECK)
	e4:SetCondition(function(e,tp) return e:GetHandler():IsFaceup() and Duel.GetDecktopGroup(tp,1):IsContains(e:GetHandler()) end)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e5:SetCountLimit(1)
	e5:SetCondition(function(e,tp) local c=e:GetHandler() return c:IsFaceup() and Duel.GetDecktopGroup(tp,1):IsContains(c) and not (cm[c] and cm[c]==Duel.GetCurrentPhase() and c:GetTurnID()==Duel.GetTurnCount()) end)
	e5:SetOperation(cm.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_PHASE+PHASE_END)
	c:RegisterEffect(e6)
	if not PNFL_INFLUENCED_CHECK then
		PNFL_INFLUENCED_CHECK=true
		PNFL_INFLUENCED_HINT=true
		--card influenced by effect
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_SINGLE)
		ge2:SetCode(EFFECT_IMMUNE_EFFECT)
		ge2:SetRange(LOCATION_ONFIELD)
		ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
		ge2:SetValue(cm.chkval0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		ge3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		ge3:SetLabelObject(ge2)
		Duel.RegisterEffect(ge3,0)
	end
end
cm.toss_coin=true
function cm.chkval0(e,te)
	if te and te:GetHandler() and not te:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) and (te:GetCode()<0x10000 or te:IsHasType(EFFECT_TYPE_ACTIONS)) then
		if e:GetHandler():GetFlagEffect(11451854)==0 then
			local prop=EFFECT_FLAG_SET_AVAILABLE
			if PNFL_INFLUENCED_HINT or PNFL_DEBUG then prop=prop|EFFECT_FLAG_CLIENT_HINT end
			e:GetHandler():RegisterFlagEffect(11451854,RESET_EVENT+0x1fc0000,prop,1,0,aux.Stringid(11451854,2))
		end
	end
	return false
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x6e) and c:IsLevel(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.rfilter(c)
	return Duel.GetTurnCount()~=c:GetTurnID() and not c:IsReason(REASON_RETURN) and c:IsAbleToHand()
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.rfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if #rg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.rfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if c:IsRelateToEffect(e) then
		local res=Duel.TossCoin(tp,1)
		--if PNFL_PROPHECY_FLIGHT_DEBUG then res=1 end
		if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT) and c:IsLocation(LOCATION_DECK) then
			Duel.ShuffleDeck(c:GetControler())
			if res==1 then c:ReverseInDeck() end
		end
	end
end
function cm.topfilter(c)
	return c:GetFlagEffect(11451851)>0
end
function cm.seqfilter(c,seq)
	return c:GetSequence()==seq
end
function cm.labfilter(c,seq)
	return c:GetFlagEffectLabel(11451851)==seq
end
function cm.labseqfilter(c,ct)
	return c:GetFlagEffectLabel(11451851)+c:GetSequence()~=ct
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if pnfl_adjusting then return end
	pnfl_adjusting=true
	if not PNFL_INFLUENCED_HINT then
		PNFL_INFLUENCED_HINT=true
		local shg=Duel.GetMatchingGroup(cm.shfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		for tc in aux.Next(shg) do
			tc:RegisterFlagEffect(11451854,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451854,2))
		end
	end
	local c=e:GetHandler()
	if PNFL_PROPHECY_FLIGHT_DEBUG then Debug.Message("adjust"..c:GetCode()) end
	c:ReverseInDeck()
	pnflpf.resetop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_DECK,0,nil,11451851)
	local sg=tg:Filter(cm.topfilter,nil)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if #sg~=#tg then
		if PNFL_PROPHECY_FLIGHT_DEBUG then Debug.Message("selecttop"..c:GetCode()) end
		local fc
		if #tg>1 and PNFL_PROPHECY_FLIGHT_OPERATION_PERMIT then
			if PNFL_PROPHECY_FLIGHT_TACTIC_VIEW then
				local g1=tg:Filter(pnflpf.tdfilter,nil)
				local tpg=Group.CreateGroup()
				if #g1>0 then
					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451851,6))
					Duel.DisableShuffleCheck()
					Group.SelectUnselect(g1,tpg,tp,true,true,#g1,#g1)
				end
				tpg:DeleteGroup()
			end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451851,1))
			fc=tg:Select(tp,1,1,nil):GetFirst()
		end
		if #Group.__band(Duel.GetDecktopGroup(tp,#tg),tg)~=#tg then
			if fc then tg:RemoveCard(fc) end
			for tc in aux.Next(tg) do
				Duel.MoveSequence(tc,0)
				tc:ReverseInDeck()
			end
		end
		if fc then tg:AddCard(fc) Duel.MoveSequence(fc,0) end
		if #tg>1 and not PNFL_PROPHECY_FLIGHT_OPERATION_PERMIT then
			if PNFL_PROPHECY_FLIGHT_TACTIC_VIEW then
				local g1=tg:Filter(pnflpf.tdfilter,nil)
				local tpg=Group.CreateGroup()
				if #g1>0 then
					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451851,6))
					Duel.DisableShuffleCheck()
					Group.SelectUnselect(g1,tpg,tp,true,true,#g1,#g1)
				end
				tpg:DeleteGroup()
			end
			Duel.SortDecktop(tp,tp,#tg)
		end
		for i=1,#tg do
			local tc=tg:Filter(cm.seqfilter,nil,ct-i):GetFirst()
			tc:RegisterFlagEffect(11451851,RESET_EVENT+RESETS_STANDARD,0,1,i)
			tc:ReverseInDeck()
		end
	elseif tg:IsExists(cm.labseqfilter,1,nil,ct) then
		if PNFL_PROPHECY_FLIGHT_DEBUG then Debug.Message("move"..c:GetCode()) end
		for i=#tg,1,-1 do
			local tc=tg:Filter(cm.labfilter,nil,i):GetFirst()
			Duel.MoveSequence(tc,0)
			tc:ReverseInDeck()
		end
	end
	pnfl_adjusting=false
end
function cm.shfilter(c)
	return c:GetFlagEffect(11451854)>0
end
function cm.tgfilter(c,e)
	return c:IsRelateToEffect(e) and (c:IsLocation(LOCATION_GRAVE) or c:GetFlagEffect(11451854)>0) and c:IsAbleToRemove()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(cm.tgfilter,nil,re)
	if #g>0 and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		local tg=g
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			tg=g:Select(tp,1,3,nil)
		end
		Duel.Hint(HINT_CARD,0,m)
		Duel.HintSelection(tg)
		if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)>0 then
			local rg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			rg:KeepAlive()
			for tc in aux.Next(rg) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(0,1)
				e1:SetValue(cm.aclimit)
				e1:SetLabelObject(tc)
				Duel.RegisterEffect(e1,tp)
				tc:CreateEffectRelation(e1)
			end
		end
	end
end
function cm.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode()) and tc:IsRelateToEffect(e)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetTurnID()~=Duel.GetTurnCount() or Duel.SelectYesNo(tp,aux.Stringid(11451851,2)) then
		Duel.DisableShuffleCheck()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end