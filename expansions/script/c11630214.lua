--死型镜·魂光刻印镜
local m=11630214
local cm=_G["c"..m] 
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)   
end
cm.SetCard_xxj_Mirror=true
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	--e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetLabel(Duel.GetTurnCount())
	e2:SetCondition(cm.thcon)
	e2:SetOperation(cm.thop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
	  e2:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
	  e2:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e2,tp)
end
function cm.thfilter(c)
	return c:GetFlagEffect(m)>0 and c:IsAbleToHand()
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=1
	local num=Duel.GetFlagEffect(tp,m)
	if num>=3 then
		ct=math.floor(num/3)
	end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,ct,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
end
--
function cm.cfilter(c,tp)
	return  c:IsControler(tp) -- and not c:IsReason(REASON_MATERIAL)  c:IsReason(REASON_EFFECT)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(cm.cfilter,1,nil,1-tp)
end 
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.cfilter,nil,1-tp)   
	Duel.Hint(HINT_CARD,0,m) 
	cm.cp(g,tp)
	--local ct=g:GetCount()
	--Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_STANDBY,0,1)
end
function cm.cp(g,tp)
	local tc=g:GetFirst()
	local ph=1
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		ph=2
	else
		ph=1
	end
	while tc do
		local code=tc:GetOriginalCode()
		local rc=Duel.CreateToken(tp,code)
		Duel.SendtoGrave(rc,REASON_RULE)
		rc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,ph)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_STANDBY,0,ph)
		tc=g:GetNext()
	end
end

function cm.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end