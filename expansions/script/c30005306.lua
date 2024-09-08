--魔蚀反
local m=30005306
local cm=_G["c"..m]
function cm.initial_effect(c)
	--act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(cm.actcon)
	c:RegisterEffect(e0)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_RELEASE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--Effect 2  
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(m,0))
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_GRAVE)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCountLimit(1,m)
	e51:SetCondition(cm.scon)
	e51:SetCost(aux.bfgcost)
	e51:SetTarget(cm.stg)
	e51:SetOperation(cm.sop)
	c:RegisterEffect(e51)   
	--all
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
--all
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local race,lv=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE,CHAININFO_TRIGGERING_LEVEL)
	if re:IsActiveType(TYPE_TRAP) or (race&RACE_FIEND>0 and lv&6>0) then
		Duel.RegisterFlagEffect(0,m+100,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1,m+100,RESET_PHASE+PHASE_END,0,1)
	end
end
--act in set turn
function cm.pf(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP)
end
function cm.actcon(e)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil)
	local tg=Duel.GetMatchingGroup(cm.pf,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)
	return (#g+#tg)>=2
end
--Effect 1
function cm.rsf(c,tp)
	if not c:IsType(TYPE_TRAP) and not c:IsRace(RACE_FIEND) then return false end
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	local tge=nil
	if re then
		val=re:GetValue()
		tge=re:GetTarget()
	end
	if c:IsLocation(LOCATION_HAND) then
		return val==nil and (tae==nil or tae(re,c))
	else
		return c:IsReleasableByEffect()
	end
end
function cm.sumf(c) 
	local b1=c:IsLevel(6)
	local b2=c:IsRace(RACE_FIEND)
	local b3=c:IsSummonable(true,nil)
	return c:IsFaceupEx() and b1 and b2 and b3 and c:IsAbleToHand()
end   
function cm.tof(c) 
	local a=c:IsType(TYPE_CONTINUOUS)
	local b=c:IsType(TYPE_TRAP)
	return c:IsFaceupEx() and a and b and  c:IsAbleToHand()   
end   
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) or rp~=1-tp then return false end
	local te,p,lv,race=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LEVEL,CHAININFO_TRIGGERING_RACE)
	if not te or p~=tp then return false end
	local tc=te:GetHandler()
	local b1=te:IsActiveType(TYPE_MONSTER) and lv&6>0 and race&RACE_FIEND>0
	local b2=te:IsActiveType(TYPE_TRAP)
	return b1 or b2
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.rsf,tp,LOCATION_ONFIELD+LOCATION_HAND,0,e:GetHandler(),tp)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rsf,tp,LOCATION_ONFIELD+LOCATION_HAND,0,e:GetHandler(),tp)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:Select(tp,1,1,nil)
	if #rg==0 or Duel.SendtoGrave(rg,REASON_EFFECT+REASON_RELEASE)==0 then return false end
	if not Duel.NegateEffect(ev) then return false end
	local loc=LOCATION_GRAVE+LOCATION_REMOVED 
	local kg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.sumf),tp,loc,0,nil)
	local dg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.tof),tp,loc,0,nil)
	local op=aux.SelectFromOptions(tp,{#kg>0,aux.Stringid(m,0)},{#dg>0,aux.Stringid(m,1)},{true,aux.Stringid(m,2)})
	if op==1 then 
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		g=kg:Select(tp,1,1,nil)
		if #g==0 then return false end
		local tc=g:GetFirst()
		if Duel.SendtoHand(g,nil,REASON_EFFECT)==0 or tc:GetLocation()~=LOCATION_HAND then return false end
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if cm.suf(tc,e:GetHandler()) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(30005304,3))
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SUMMON_PROC)
			e1:SetCondition(cm.ntcon)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_SUMMON_NEGATED)
			e2:SetOperation(cm.rstop)
			e2:SetLabelObject(e1)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			Duel.Summon(tp,tc,true,nil)
		else
			Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	else 
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		g=dg:Select(tp,1,1,nil) 
		if #g==0 then return false end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	if e1 then e1:Reset() end
	e:Reset()
end
function cm.suf(c,ec)
	if not c:IsRace(RACE_FIEND) or not c:IsLevel(6) then return false end
	local e1=Effect.CreateEffect(ec)
	e1:SetDescription(aux.Stringid(30005304,3))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.ntcon)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local res=c:IsSummonable(true,nil)
	e1:Reset()
	return res 
end
--Effect 2
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m+100)>0
end   
function cm.set(c)
	return c:IsCode(30005305) and c:IsSSetable()
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
		return ct>0 and Duel.IsExistingMatchingCard(cm.set,tp,LOCATION_DECK,0,1,nil)
	end
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.set,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end