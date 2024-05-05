--混沌魔装 0∞V4
local m=30005302
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(m,0))
	e51:SetCategory(CATEGORY_REMOVE)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_HAND)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCountLimit(1,m)
	e51:SetCost(cm.cost)
	e51:SetTarget(cm.tg)
	e51:SetOperation(cm.op)
	c:RegisterEffect(e51)   
	--Effect 2  
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TODECK+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m+m)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cm.dtg)
	e1:SetOperation(cm.dop)
	c:RegisterEffect(e1)
------buff------
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCondition(cm.bfcon)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
	--attack twice
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e4:SetValue(1)
	e4:SetCondition(cm.bfcon)
	c:RegisterEffect(e4)
	--pierce
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_PIERCE)
	e12:SetCondition(cm.bfcon)
	c:RegisterEffect(e12)
end
--Effect 1
function cm.ctf(c) 
	return c:IsType(TYPE_TRAP) and c:IsDiscardable()
end 
function cm.mf(c) 
	local b1=c:IsRace(RACE_FIEND)
	local b2=c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP)
	return c:IsFaceup() and (b1 or b2) and c:IsAbleToRemove()
end 
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b2=Duel.IsExistingMatchingCard(cm.ctf,tp,LOCATION_HAND,0,1,c)
	if chk==0 then return c:IsDiscardable() and b2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.ctf,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)		
	local g=Duel.GetMatchingGroup(cm.mf,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetHandler():GetFieldID()
	local g=Duel.GetMatchingGroup(cm.mf,tp,LOCATION_ONFIELD,0,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=g:Select(tp,1,1,nil):GetFirst()
	local ze=1 
	if rc:IsLocation(LOCATION_SZONE) then ze=2 end
	if rc==nil or not rc then return false end
	if Duel.Remove(rc,0,REASON_EFFECT+REASON_TEMPORARY)==0 or rc:GetLocation()~=LOCATION_REMOVED then return false end
	rc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	Duel.AdjustAll()
	local ph=Duel.GetCurrentPhase()
	local tup=Duel.GetTurnPlayer()
	local b1=not Duel.IsPlayerAffectedByEffect(tup,EFFECT_SKIP_BP) and not Duel.IsPlayerAffectedByEffect(tup,EFFECT_CANNOT_BP) and ph~=PHASE_BATTLE and ph~=PHASE_BATTLE_START and ph~=PHASE_BATTLE_STEP and ph~=PHASE_DAMAGE and ph~=PHASE_DAMAGE_CAL 
	local b2=not Duel.IsPlayerAffectedByEffect(tup,EFFECT_SKIP_M2) and Duel.GetTurnCount()~=1 and ph~=PHASE_MAIN2 
	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(m,0)},
			{b2,aux.Stringid(m,1)},
			{true,aux.Stringid(m,2)})
	if op==1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,0))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE)
		e1:SetLabelObject(rc)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.rrecon)
		if ze==1 then
			e1:SetOperation(cm.retop)
		else 
			e1:SetOperation(cm.aretop)
		end
		Duel.RegisterEffect(e1,tp)   
	elseif op==2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetLabelObject(rc)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.recon)
		if ze==1 then
			e1:SetOperation(cm.retop)
		else 
			e1:SetOperation(cm.aretop)
		end
		Duel.RegisterEffect(e1,tp)  
	else 
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,2))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetLabelObject(rc)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.rrecon)
		if ze==1 then
			e1:SetOperation(cm.retop)
		else 
			e1:SetOperation(cm.aretop)
		end
		Duel.RegisterEffect(e1,tp)  
	end
end
function cm.rrecon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffect(m)>0
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetCurrentPhase()==PHASE_MAIN2 and tc:GetFlagEffect(m)>0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	local tc=e:GetLabelObject()
	if tc:GetType()&TYPE_MONSTER~=0 then
		Duel.ReturnToField(tc)
	else
		Duel.SendtoGrave(tc,REASON_RULE+REASON_RETURN)
	end
end
function cm.aretop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	local tc=e:GetLabelObject()
	if tc:GetType()&TYPE_TRAP~=0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		else
			Duel.SendtoGrave(tc,REASON_RULE+REASON_RETURN)
		end
	else
		Duel.SendtoGrave(tc,REASON_RULE+REASON_RETURN)
	end
end
--Effect 2
function cm.df(c)
	local b1=c:IsRace(RACE_FIEND)
	local b2=c:IsType(TYPE_TRAP)
	return c:IsFaceupEx() and (b1 or b2) and c:IsAbleToDeck()
end
function cm.th(c)
	local b1=c:IsRace(RACE_FIEND)
	local b2=c:IsAttack(2700)
	local b3=c:IsDefense(1000)
	return b2 and b3 and c:IsAbleToHand()
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.df,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(cm.df,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,5,0,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.df,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,ec)
	if #g==0 then return end
	local tg
	if #g==5 then 
		tg=g
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		tg=g:Select(tp,5,7,nil)
	end
	if #tg==0 then return false end
	local dt=Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if dt==0 or Duel.Recover(tp,dt*500,REASON_EFFECT)==0 then return false end
	Duel.AdjustAll()
	local thk=Duel.IsExistingMatchingCard(cm.th,tp,LOCATION_DECK,0,1,nil)
	if thk and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.BreakEffect()
		cm.thop(e,tp)
	end
end
function cm.thop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.th,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 then return false end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end 
------buff------
function cm.af(c)
	return c:IsFaceupEx() and c:IsType(TYPE_TRAP)
end
function cm.aff(c)
	local b1=c:IsRace(RACE_FIEND)
	local b2=c:IsType(TYPE_TRAP)
	return c:IsFaceupEx() and (b1 or b2)
end
function cm.bfcon(e)	 
	local loc=LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED 
	local g=Duel.GetMatchingGroup(cm.af,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)
	return #g>0 
end  
function cm.atkval(e,c)
	local loc=LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED 
	local g=Duel.GetMatchingGroup(cm.aff,e:GetHandlerPlayer(),loc,loc,nil)
	return #g*200
end 