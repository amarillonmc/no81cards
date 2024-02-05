--魔导探机 鹰眼MkII
local cm,m=GetID()
function cm.initial_effect(c)
	if not PNFL_PROPHECY_FLIGHT_CHECK then
		dofile("expansions/script/c11451851.lua")
		pnfl_prophecy_flight_initial(c)
	end
	c:EnableCounterPermit(0x972,LOCATION_MZONE)
	c:EnableCounterPermit(0x973,LOCATION_MZONE)
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
		local b1=Duel.IsCanRemoveCounter(p,1,0,0x973,1,REASON_EFFECT) and s0>0
		local b2=Duel.IsCanRemoveCounter(p,1,0,0x972,1,REASON_EFFECT) and s1>0
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
				Duel.RemoveCounter(p,1,0,0x973,1,REASON_EFFECT)
				local rs={Duel.TossCoin(tp,s0)}
				local j=1
				for i,r in ipairs(res) do if r==0 then res[i]=rs[j] j=j+1 end end
				Duel.SetCoinResult(table.unpack(res))
			elseif sel==1 then
				Duel.Hint(HINT_CARD,0,m)
				Duel.RemoveCounter(p,1,0,0x972,1,REASON_EFFECT)
				local rs={Duel.TossCoin(tp,s1)}
				local j=1
				for i,r in ipairs(res) do if r==1 then res[i]=rs[j] j=j+1 end end
				Duel.SetCoinResult(table.unpack(res))
			elseif sel==2 then
				Duel.Hint(HINT_CARD,0,m)
				Duel.RemoveCounter(p,1,0,0x973,1,REASON_EFFECT)
				Duel.RemoveCounter(p,1,0,0x972,1,REASON_EFFECT)
				local rs={Duel.TossCoin(tp,#res)}
				Duel.SetCoinResult(table.unpack(rs))
			else
				bool1=false
			end
		end
	end
end
function cm.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSSet(1-tp) end
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
	if chk==0 then return #tab>0 and ((tab[#tab]==0 and c:IsCanAddCounter(0x973,1)) or (tab[#tab]==1 and c:IsCanAddCounter(0x972,1))) end
	if tab[#tab]==0 then c:AddCounter(0x973,1) end
	if tab[#tab]==1 then c:AddCounter(0x972,1) end
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
	if tc:IsRelateToEffect(e) then
		if not tc:IsOnField() then
			if 1==1 then return tc:IsImmuneToEffect(e) end
			local tg=Duel.GetMatchingGroup(nil,tc:GetControler(),tc:GetLocation(),0,nil)
			local b1=tc:GetSequence()~=0
			local b2=tc:GetSequence()~=#tg-1
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
			if op==0 then Duel.MoveSequence(tc,tc:GetSequence()+1) end
			if op==1 then Duel.MoveSequence(tc,tc:GetSequence()-1) end
		end
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