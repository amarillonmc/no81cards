--魔侵染
local m=30005305
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCondition(cm.con)
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
		local ge11=Effect.CreateEffect(c)
		ge11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge11:SetCode(EVENT_LEAVE_FIELD)
		ge11:SetCondition(cm.lecon)
		ge11:SetOperation(cm.leop)
		Duel.RegisterEffect(ge11,0)
	end
end
--all
function cm.zpf(c,tp)
	local b1=c:IsPreviousControler(tp) 
	local b2=bit.band(c:GetPreviousTypeOnField(),TYPE_TRAP)~=0
	local b3=c:GetReasonPlayer()==1-tp
	return b1 and b2 and b3 
end
function cm.lecon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.zpf,1,nil,0) or eg:IsExists(cm.zpf,1,nil,1)
end 
function cm.leop(e,tp,eg,ep,ev,re,r,rp)
	local ag=eg:Filter(cm.zpf,nil,0)
	local bg=eg:Filter(cm.zpf,nil,1)
	if #ag>0 then Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1) end
	if #bg>0 then Duel.RegisterFlagEffect(1,m,RESET_PHASE+PHASE_END,0,1) end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local race,lv=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE,CHAININFO_TRIGGERING_LEVEL)
	if re:IsActiveType(TYPE_TRAP) or (race&RACE_FIEND>0 and lv&6>0) then
		Duel.RegisterFlagEffect(0,m+100,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1,m+100,RESET_PHASE+PHASE_END,0,1)
	end
end
--Effect 1
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>0
end 
function cm.th(c)
	local b1=c:IsAttack(2700)
	local b2=c:IsDefense(1000)
	local b3=c:IsRace(RACE_FIEND)
	return b1 and b2 and b3 and c:IsAbleToHand()
end
function cm.thf(c)
	local b1=c:IsLevel(6)
	local b2=c:IsRace(RACE_FIEND)
	return b1 and b2 and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	local kg=Duel.GetMatchingGroup(cm.th,tp,LOCATION_DECK,0,nil)
	local dg=Duel.GetMatchingGroup(cm.thf,tp,LOCATION_GRAVE,0,nil) 
	if chk==0 then return #kg>0 or #dg>0 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	local kg=Duel.GetMatchingGroup(cm.th,tp,LOCATION_DECK,0,nil)
	local dg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thf),tp,LOCATION_GRAVE,0,nil)
	if #kg==0 and #dg==0 then return false end
	local op=aux.SelectFromOptions(tp,{#kg>0,aux.Stringid(m,0)},{#dg>0,aux.Stringid(m,1)})
	if op==1 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		g=kg:Select(tp,1,1,nil)
		if #g==0 then return false end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		g=dg:Select(tp,1,1,nil) 
		if #g==0 then return false end
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end  
--Effect 2
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m+100)>0
end   
function cm.set(c)
	return c:IsCode(30005306) and c:IsSSetable()
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