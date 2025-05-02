--魔导探机 鹰眼MkII
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
local m=11451856
local cm=_G["c"..m]
function cm.initial_effect(c)
	if not PNFL_PROPHECY_FLIGHT_CHECK then
		pnfl_prophecy_flight_initial(c)
	end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.spcost2)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TOSS_COIN_NEGATE)
	e2:SetCondition(cm.coincon)
	e2:SetOperation(cm.coinop)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(cm.discost)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
end
cm.toss_coin=true
function cm.coincon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetCode()~=EVENT_TOSS_COIN_NEGATE
end
function cm.coinop(e,tp,eg,ep,ev,re,r,rp)
	local bool1=true
	local p=tp
	while bool1 do
		local res={Duel.GetCoinResult()}
		local s0,s1=0,0
		for _,r in ipairs(res) do if r==0 then s0=s0+1 end end
		for _,r in ipairs(res) do if r==1 then s1=s1+1 end end
		local b1=Duel.IsCanRemoveCounter(p,1,0,0x1971,1,REASON_EFFECT) and s0>0
		local b2=Duel.IsCanRemoveCounter(p,1,0,0x1970,1,REASON_EFFECT) and s1>0
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
		if b1 and b2 then
			ops[off]=aux.Stringid(11451856,5)
			opval[off]=2
			off=off+1
		end
		ops[off]=aux.Stringid(11451856,2)
		opval[off]=3
		if off==1 then
			bool1=false
		else
			local op=Duel.SelectOption(p,table.unpack(ops))+1
			local sel=opval[op]
			if sel==0 then
				Duel.Hint(HINT_CARD,0,m)
				Duel.RemoveCounter(p,1,0,0x1971,1,REASON_EFFECT)
				local rs={Duel.TossCoin(tp,s0)}
				local j=1
				for i,r in ipairs(res) do if r==0 then res[i]=rs[j] j=j+1 end end
				Duel.SetCoinResult(table.unpack(res))
			elseif sel==1 then
				Duel.Hint(HINT_CARD,0,m)
				Duel.RemoveCounter(p,1,0,0x1970,1,REASON_EFFECT)
				local rs={Duel.TossCoin(tp,s1)}
				local j=1
				for i,r in ipairs(res) do if r==1 then res[i]=rs[j] j=j+1 end end
				Duel.SetCoinResult(table.unpack(res))
			elseif sel==2 then
				Duel.Hint(HINT_CARD,0,m)
				Duel.RemoveCounter(p,1,0,0x1971,1,REASON_EFFECT)
				Duel.RemoveCounter(p,1,0,0x1970,1,REASON_EFFECT)
				local rs={Duel.TossCoin(tp,#res)}
				Duel.SetCoinResult(table.unpack(rs))
			else
				bool1=false
			end
		end
	end
end
function cm.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSSet(1-tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	local tg=Duel.SelectMatchingCard(1-tp,Card.IsSSetable,tp,0,LOCATION_HAND,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
	if #tg>0 then Duel.SSet(1-tp,tg,1-tp,false) end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0x6e,0x21,0,0,1,RACE_MACHINE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0x6e,0x21,0,0,1,RACE_MACHINE,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
	end
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tab=pnflpf.coinsequence
	if chk==0 then
		local res=#tab>0 and ((tab[#tab]==0 and c:IsCanAddCounter(0x1971,1)) or (tab[#tab]==1 and c:IsCanAddCounter(0x1970,1)))
		return res
	end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_UNCOPYABLE)
	if tab[#tab]==0 then c:AddCounter(0x1971,1) end
	if tab[#tab]==1 then c:AddCounter(0x1970,1) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetLabel(tab[#tab])
	tab[#tab]=2
end
function cm.posfilter(c,pos)
	local seq=c:GetSequence()
	local p=c:GetControler()
	local loc=c:GetLocation()
	if c:IsLocation(LOCATION_FZONE) or c:IsLocation(LOCATION_PZONE) or not c:IsPosition(pos) then return false end
	if not c:IsOnField() then return Duel.IsExistingMatchingCard(nil,c:GetControler(),c:GetLocation(),0,1,c) end
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(p,loc,seq-1)) or (seq<4 and Duel.CheckLocation(p,loc,seq+1))
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.posfilter(chkc) end
	if chk==0 then
		local tab=pnflpf.coinsequence
		local pos=POS_FACEUP
		if tab[#tab]==0 then pos=POS_FACEDOWN end
		return e:IsCostChecked() and Duel.IsExistingTarget(cm.posfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,nil,pos)
	end
	local pos=POS_FACEUP
	if e:GetLabel()==0 then pos=POS_FACEDOWN end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.posfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,pos)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		if not tc:IsOnField() then
			--if 1==1 then return tc:IsImmuneToEffect(e) end
			local seq=tc:GetSequence()
			local tg=Duel.GetMatchingGroup(nil,tc:GetControler(),tc:GetLocation(),0,nil)
			local b1=seq~=0
			local b2=seq~=#tg-1
			local op=0
			if b1 and b2 then
				op=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))
			elseif b1 then
				op=Duel.SelectOption(tp,aux.Stringid(m,4))+1
			elseif b2 then
				op=Duel.SelectOption(tp,aux.Stringid(m,3))
			else
				return
			end
			if op==0 then
				local sg=tg:Filter(function(c) return c:GetSequence()>seq+1 end,nil)
				Duel.MoveSequence(tc,0)
				e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
				while #sg>0 do
					local sc=sg:GetMinGroup(Card.GetSequence):GetFirst()
					Duel.MoveSequence(sc,0)
					sg:RemoveCard(sc)
				end
			end
			if op==1 then
				local sg=tg:Filter(function(c) return c:GetSequence()>seq-2 end,tc)
				e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
				while #sg>0 do
					local sc=sg:GetMinGroup(Card.GetSequence):GetFirst()
					Duel.MoveSequence(sc,0)
					sg:RemoveCard(sc)
				end
			end
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		else
			local seq=tc:GetSequence()
			local p=tc:GetControler()
			local b1=0
			if p~=tp then b1=1 end
			local loc=tc:GetLocation()
			local b2=0
			if loc==LOCATION_SZONE then b2=1 end
			if seq>4 then return end
			local flag=0
			if seq>0 and Duel.CheckLocation(p,loc,seq-1) then flag=flag|(1<<(seq-1+16*b1+8*b2)) end
			if seq<4 and Duel.CheckLocation(p,loc,seq+1) then flag=flag|(1<<(seq+1+16*b1+8*b2)) end
			if flag==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,~flag)
			local nseq=math.log(s,2)-16*b1-8*b2
			Duel.MoveSequence(tc,nseq)
		end
	end
end