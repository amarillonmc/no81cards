--魔导飞行队 费尔珀·艾瑞儿
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
	e1:SetCategory(CATEGORY_COIN+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCost(cm.thcost)
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
	cm.highground=e4
	local e5=e4:Clone()
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e5:SetCountLimit(1)
	e5:SetCondition(function(e,tp) local c=e:GetHandler() return c:IsFaceup() and Duel.GetDecktopGroup(tp,1):IsContains(c) and not (cm[c] and cm[c]==Duel.GetCurrentPhase() and c:GetTurnID()==Duel.GetTurnCount()) end)
	e5:SetOperation(cm.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_PHASE+PHASE_END)
	c:RegisterEffect(e6)
end
cm.toss_coin=true
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,c)
end
function cm.setfilter(c)
	return c:IsSetCard(0x6e) and c:IsSSetable()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then Duel.SSet(tp,g) end
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
	--[[if tc~=c and sg:IsContains(c) then
		if PNFL_PROPHECY_FLIGHT_DEBUG then Debug.Message("move"..c:GetCode()) end
		Duel.MoveSequence(c,0)
		c:ReverseInDeck()
	end
	if tc:GetFlagEffect(11451851)==0 and #tg>0 and #sg==0 then
		if PNFL_PROPHECY_FLIGHT_DEBUG then Debug.Message("selecttop"..c:GetCode()) end
		local fc=tg:GetFirst()
		if #tg>1 then
			Duel.Hint(HINT_SELECTMSG,0,aux.Stringid(11451851,1))
			fc=tg:Select(tp,1,1,nil):GetFirst()
		end
		fc:RegisterFlagEffect(11451851,RESET_EVENT+RESETS_STANDARD,0,1)
		fc:ReverseInDeck()
		Duel.Readjust()
	end--]]
end
function cm.tgfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsOnField()
end
function cm.getzone(c,tp)
	local p=c:GetControler()
	local loc=c:GetLocation()
	local seq=c:GetSequence()
	local zone=1<<seq
	if loc&LOCATION_SZONE~=0 then zone=zone<<8 end
	if p~=tp then zone=zone<<16 end
	if zone==0x20 or zone==0x400000 then zone=0x400020 end
	if zone==0x40 or zone==0x200000 then zone=0x200040 end
	return zone
end
function cm.GetCardsInZone(tp,fd)
	if fd==0x400020 then return Duel.GetFieldCard(tp,LOCATION_MZONE,5) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,6) end
	if fd==0x200040 then return Duel.GetFieldCard(tp,LOCATION_MZONE,6) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,5) end
	local seq=math.log(fd,2)
	local p=tp
	if seq>=16 then
		p=1-tp
		seq=seq-16
	end
	local loc=LOCATION_MZONE
	if seq>=8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	return Duel.GetFieldCard(p,loc,math.floor(seq+0.5))
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(cm.tgfilter,nil,re)
	if #g>0 and Duel.SelectEffectYesNo(tp,re:GetHandler(),aux.Stringid(11451858,4)) then
		local fd=0
		for tc in aux.Next(g) do
			fd=fd|cm.getzone(tc,tp)
		end
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			fd=Duel.SelectField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,~fd)
		end
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_ZONE,tp,fd)
		local fd2=fd
		if fd>=1<<16 then fd2=fd>>16 else fd2=fd<<16 end
		Duel.Hint(HINT_ZONE,1-tp,fd2)
		local ct=0
		local op=function(e,tp)
					if ct>=3 then e:Reset() return end
					ct=ct+1
					--Duel.Hint(HINT_CARD,0,m)
					local tc=cm.GetCardsInZone(tp,fd)
					if tc then
						Duel.Destroy(tc,REASON_EFFECT)
						e:GetHandler():SetTurnCounter(ct)
					else
						Duel.Hint(HINT_ZONE,tp,fd)
						e:GetHandler():SetTurnCounter(ct)
					end
				end
		if Duel.GetCurrentChain()==1 then
			op(e,tp)
		elseif e:GetHandler():GetFlagEffect(11451862)>0 then
			e:GetHandler():ResetFlagEffect(11451862)
			if SetCardData then
				Duel.Hint(24,0,aux.Stringid(11451862,2))
			else
				Debug.Message("「急袭」任务完成！")
			end
		end
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_CHAIN_SOLVED)
		e6:SetCondition(function() return Duel.GetCurrentChain()==1 end)
		e6:SetOperation(op)
		Duel.RegisterEffect(e6,tp)
		local e7=e6:Clone()
		e7:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(e7,tp)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local tc=cm.GetCardsInZone(tp,fd)
	if tc then Duel.Destroy(tc,REASON_EFFECT) end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--if c:GetTurnID()~=Duel.GetTurnCount() or Duel.SelectYesNo(tp,aux.Stringid(11451851,2)) then
	if Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(11451851,2)) then
		Duel.DisableShuffleCheck()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end