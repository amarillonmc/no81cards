--魔导飞行队 艾娜姬·莉查
pnflpf=pnflpf or {}
function pnfl_prophecy_flight_initial(c)
	PNFL_PROPHECY_FLIGHT_CHECK=true
	PNFL_PROPHECY_FLIGHT_DEBUG=false
	PNFL_PROPHECY_FLIGHT_OPERATION_PERMIT=true
	PNFL_PROPHECY_FLIGHT_TACTIC_VIEW=false
	pnflpf[0]=0
	pnflpf[1]=0
	pnflpf.coinsequence={}
	local _TossCoin=Duel.TossCoin
	local _SetCoinResult=Duel.SetCoinResult
	function Duel.SetCoinResult(...)
		local ct0=#pnflpf.coinsequence
		local res0={Duel.GetCoinResult()}
		if pnflpf.res and #res0>0 then
			for i=1,#res0 do pnflpf.coinsequence[ct0+i]=res0[i] end
		end
		pnflpf.res=nil
		_SetCoinResult(...)
	end
	function Duel.TossCoin(p,ct)
		local ct0=#pnflpf.coinsequence
		local res0={Duel.GetCoinResult()}
		--before replaced by this coin, register last coin.
		if pnflpf.res and #res0>0 then
			for i=1,ct do pnflpf.coinsequence[ct0+i]=res0[i] end
		end
		pnflpf.res=res0
		ct0=#pnflpf.coinsequence
		local res={_TossCoin(p,ct)}
		local ct1=#pnflpf.coinsequence
		--if this coin isn't replaced, register it.
		if pnflpf.res and ct0==ct1 then
			for i=1,ct do pnflpf.coinsequence[ct1+i]=res[i] end
		end
		local str="实际投掷结果："
		for i=1,#res do
			if res[i]==1 then str=str.."[表]" else str=str.."[里]" end
		end
		--Debug.Message(str)
		pnflpf.res=nil
		return table.unpack(res)
	end
	--[[function Duel.TossCoin(p,ct)
		local dic={}
		local ct0=#pnflpf.coinsequence
		for i=1,ct do table.insert(pnflpf.coinsequence,2) end
		local res={_TossCoin(p,ct)}
		local bool1,bool2=true,true
		while bool1 or bool2 do
			local s0,s1=false,false
			for _,r in ipairs(res) do if r==0 then s0=true end end
			for _,r in ipairs(res) do if r==1 then s1=true end end
			local b1=Duel.IsCanRemoveCounter(p,1,0,0x1972,1,REASON_EFFECT) and s0
			local b2=Duel.IsCanRemoveCounter(p,1,0,0x1971,1,REASON_EFFECT) and s1
			local off=1
			local ops,opval={},{}
			if b1 then
				ops[off]=aux.Stringid(11451856,0)
				opval[off]=0
				off=off+1
			end
			if b2 then
				ops[off]=aux.Stringid(11451856,1)
				opval[off]=1
				off=off+1
			end
			ops[off]=aux.Stringid(11451856,2)
			opval[off]=2
			if off==1 then
				bool1=false
			else
				local op=Duel.SelectOption(p,table.unpack(ops))+1
				local sel=opval[op]
				if sel==0 then
					Duel.RemoveCounter(p,1,0,0x1972,1,REASON_EFFECT)
					for i,r in ipairs(res) do res[i]=1 end
				elseif sel==1 then
					Duel.RemoveCounter(p,1,0,0x1971,1,REASON_EFFECT)
					for i,r in ipairs(res) do res[i]=0 end
				else
					bool1=false
				end
			end
			local s0,s1=false,false
			for _,r in ipairs(res) do if r==0 then s0=true end end
			for _,r in ipairs(res) do if r==1 then s1=true end end
			local b1=Duel.IsCanRemoveCounter(1-p,1,0,0x1972,1,REASON_EFFECT) and s0
			local b2=Duel.IsCanRemoveCounter(1-p,1,0,0x1971,1,REASON_EFFECT) and s1
			local off=1
			local ops,opval={},{}
			if b1 then
				ops[off]=aux.Stringid(11451856,0)
				opval[off]=0
				off=off+1
			end
			if b2 then
				ops[off]=aux.Stringid(11451856,1)
				opval[off]=1
				off=off+1
			end
			ops[off]=aux.Stringid(11451856,2)
			opval[off]=2
			if off==1 then
				bool2=false
			else
				local op=Duel.SelectOption(1-p,table.unpack(ops))+1
				local sel=opval[op]
				if sel==0 then
					Duel.RemoveCounter(1-p,1,0,0x1972,1,REASON_EFFECT)
					for i,r in ipairs(res) do res[i]=1 end
				elseif sel==1 then
					Duel.RemoveCounter(1-p,1,0,0x1971,1,REASON_EFFECT)
					for i,r in ipairs(res) do res[i]=0 end
				else
					bool2=false
				end
			end
		end
		for i=1,ct do pnflpf.coinsequence[ct0+i]=res[i] end
		return table.unpack(res)
	end--]]
	--increase by Card.ReverseInDeck
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	ge0:SetCode(EVENT_ADJUST)
	ge0:SetCondition(function() return not pnfl_adjusting end)
	ge0:SetOperation(pnflpf.resetop)
	Duel.RegisterEffect(ge0,0)
	--decrease by leaving from deck
	local ge1=ge0:Clone()
	ge1:SetCode(EVENT_MOVE)
	Duel.RegisterEffect(ge1,0)
	--tactic view
	local ge4=Effect.CreateEffect(c)
	ge4:SetDescription(aux.Stringid(11451851,4))
	ge4:SetType(EFFECT_TYPE_FIELD)
	ge4:SetCode(EFFECT_SPSUMMON_PROC_G)
	ge4:SetRange(0xff)
	ge4:SetOperation(pnflpf.debug)
	c:RegisterEffect(ge4)
end
function pnflpf.resetop(e,tp,eg,ep,ev,re,r,rp)
	local g0=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_DECK,0,nil,11451851)
	local g1=Duel.GetMatchingGroup(Card.IsHasEffect,1,LOCATION_DECK,0,nil,11451851)
	local res0=pnflpf[0]~=#g0 and pnflpf[0]>0 and #g0>0
	local res1=pnflpf[1]~=#g1 and pnflpf[1]>0 and #g1>0
	pnflpf[0]=#g0
	pnflpf[1]=#g1
	if res0 or res1 then
		if PNFL_PROPHECY_FLIGHT_DEBUG then Debug.Message("reset") end
		if res0 then for tc in aux.Next(g0) do tc:ResetFlagEffect(11451851) end end
		if res1 then for tc in aux.Next(g1) do tc:ResetFlagEffect(11451851) end end
		Duel.Readjust()
	end
end
function pnflpf.tdfilter(c)
	return c:GetTurnID()==Duel.GetTurnCount()
end
function pnflpf.debug(e,tp,eg,ep,ev,re,r,rp)
	if not PNFL_PROPHECY_FLIGHT_TACTIC_VIEW then
		PNFL_PROPHECY_FLIGHT_TACTIC_VIEW=Duel.SelectYesNo(tp,aux.Stringid(11451851,3))
	elseif PNFL_PROPHECY_FLIGHT_TACTIC_VIEW then
		local opt=Duel.SelectOption(tp,aux.Stringid(11451851,4),aux.Stringid(11451851,5))
		if opt==0 then
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_DECK,0,nil,11451851)
			local g1=g:Filter(pnflpf.tdfilter,nil)
			local g2=g-g1
			local tpg=Group.CreateGroup()
			if #g1>0 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451851,6))
				Duel.DisableShuffleCheck()
				Group.SelectUnselect(g1,tpg,tp,true,true,#g1,#g1)
			end
			if #g2>0 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451851,7))
				Duel.DisableShuffleCheck()
				Group.SelectUnselect(g2,tpg,tp,true,true,#g2,#g2)
			end
			tpg:DeleteGroup()
		else
			PNFL_PROPHECY_FLIGHT_TACTIC_VIEW=false
		end
	end
	if PNFL_PROPHECY_FLIGHT_OPERATION_PERMIT then
		PNFL_PROPHECY_FLIGHT_OPERATION_PERMIT=not Duel.SelectYesNo(tp,aux.Stringid(11451851,8))
	else
		PNFL_PROPHECY_FLIGHT_OPERATION_PERMIT=Duel.SelectYesNo(tp,aux.Stringid(11451851,9))
	end
end
--
local cm,m=GetID()
function cm.initial_effect(c)
	if not PNFL_PROPHECY_FLIGHT_CHECK then
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
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_TODECK) --+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DELAY)
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
	if not cm.global_check then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		--e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_TOSS_COIN)
		e1:SetOperation(cm.effop)
		Duel.RegisterEffect(e1,0)
	end
end
cm.toss_coin=true
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	local res={Duel.GetCoinResult()}
	for i=1,ev do
		if res[i]==0 then
			ct=ct+1
		end
	end
	if ct>0 and re and re:GetHandler() then
		cm[re:GetHandler():GetCode()]=true
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) or e:GetHandler():IsLocation(LOCATION_HAND)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end --and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	--Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.fdfilter(c)
	return cm[c:GetCode()] and c:IsFacedown()
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--[[local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(cm.drop)
	Duel.RegisterEffect(e1,tp)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SKIP_DP)
		e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==tp then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(function(e) return Duel.GetTurnCount()~=e:GetLabel() end)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end--]]
	local tg=Duel.GetMatchingGroup(cm.fdfilter,tp,LOCATION_DECK,0,nil)
	if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		local g1=tg
		local fg
		local ph=Duel.GetCurrentPhase()
		if ph==PHASE_END or ph==PHASE_BATTLE_START then g1=tg-tg:Filter(function(c) return c[c] and c[c]==Duel.GetCurrentPhase() end,nil) end
		if #g1>0 and #g1<#tg then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
			fg=g1:CancelableSelect(tp,1,1,nil)
			if not fg then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
				fg=tg:Select(tp,1,1,nil)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
			fg=tg:Select(tp,1,1,nil)
		end
		fc=fg:GetFirst()
		Duel.ShuffleDeck(tp)
		fc:ReverseInDeck()
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
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Draw(tp,1,REASON_EFFECT)
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
	local c=e:GetHandler()
	if PNFL_PROPHECY_FLIGHT_DEBUG then Debug.Message("adjust"..c:GetCode()) end
	c:ReverseInDeck()
	pnflpf.resetop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_DECK,0,nil,11451851)
	local sg=tg:Filter(cm.topfilter,nil)
	--Debug.Message(#tg..#sg)
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
			local g1=tg
			local fg
			local ph=Duel.GetCurrentPhase()
			if ph==PHASE_END or ph==PHASE_BATTLE_START then g1=tg-tg:Filter(function(c) return c[c] and c[c]==Duel.GetCurrentPhase() end,nil) end
			if #g1>0 and #g1<#tg then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451851,1))
				fg=g1:CancelableSelect(tp,1,1,nil)
				if not fg then
					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451851,11))
					fg=tg:Select(tp,1,1,nil)
				end
			else
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451851,11))
				fg=tg:Select(tp,1,1,nil)
			end
			fc=fg:GetFirst()
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
function cm.tgfilter(c,e)
	return c:IsRelateToEffect(e) --and c:IsOnField()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if tp~=rp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(cm.tgfilter,nil,re)
	if #g>0 and Duel.SelectEffectYesNo(tp,re:GetHandler(),aux.Stringid(11451858,8)) then
		local tc=g:GetFirst()
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			tc=g:Select(tp,1,1,nil):GetFirst()
		end
		Duel.Hint(HINT_CARD,0,m)
		local rg=Group.FromCards(tc)
		if tc:IsOnField() then rg:Merge(tc:GetColumnGroup()) end
		for tc in aux.Next(rg) do
			if not tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
				e1:SetValue(LOCATION_DECKSHF)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(m,5))
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e2:SetCode(EFFECT_TO_HAND_REDIRECT)
			e2:SetValue(LOCATION_DECKSHF)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e10=Effect.CreateEffect(c)
			e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e10:SetCode(EVENT_TO_DECK)
			--e10:SetRange(LOCATION_DECK)
			e10:SetOperation(cm.sortop)
			e10:SetReset(RESET_EVENT+RESETS_REDIRECT-RESET_TODECK)
			tc:RegisterEffect(e10)
		end
	end
end
function cm.sortop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:Reset()
	if c:IsReason(REASON_REDIRECT) and c:IsLocation(LOCATION_DECK) then
		c:ReverseInDeck()
		--Duel.Readjust()
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(11451851,2)) then
		Duel.DisableShuffleCheck()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end