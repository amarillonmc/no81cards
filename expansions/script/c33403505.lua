--森罗万象第十四乐章「因果转变」
local m=33403505
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
	XY.REZS(c)
   local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
 --act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(cm.handcon)
	c:RegisterEffect(e3)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
 return Duel.GetFlagEffect(tp,33413501)<(Duel.GetFlagEffect(tp,33403501)/2+1)and Duel.GetFlagEffect(tp,m+30000)==0 and Duel.GetFlagEffect(tp,33443500)==0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
 if chk==0 then return true end
   local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
e:SetLabel(1)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not se:GetHandler():IsSetCard(0x5349)and  not c:IsCode(33403500)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetLabel()==1 then 
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop2)
	e2:SetReset(RESET_EVENT+RESET_CHAIN+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,m+20000,RESET_PHASE+PHASE_END,0,1)   
	Duel.RegisterFlagEffect(tp,33413501,RESET_PHASE+PHASE_END,0,1) 
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)   
	e:SetLabel(2)
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0x5349) and rp==tp
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	local n1=Duel.GetFlagEffect(tp,33413501)
	local n2=Duel.GetFlagEffect(tp,33403501)
	local n3=Duel.GetFlagEffect(tp,m+20000)
	Duel.ResetFlagEffect(tp,33413501)
	Duel.ResetFlagEffect(tp,33403501)
	Duel.ResetFlagEffect(tp,m+20000)
	if n1>=2 then 
		for i=1,n1-1 do
		Duel.RegisterFlagEffect(tp,33413501,RESET_PHASE+PHASE_END,0,1)
		end 
	end
	if n2>=2 then
		for i=1,n2-1 do
		 Duel.RegisterFlagEffect(tp,33403501,0,0,0)
		end 
	end
	if n3>=2 then 
		for i=1,n3 do
		  Duel.RegisterFlagEffect(tp,m+20000,RESET_PHASE+PHASE_END,0,1)
		end 
	end 
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
 --reflect damage
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_REFLECT_DAMAGE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	e0:SetValue(cm.refcon)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	 Duel.RegisterEffect(e1,tp)
end
function cm.refcon(e,re,val,r,rp,rc)
	return bit.band(r,REASON_EFFECT)~=0
end

function cm.filter(c)
	return c:IsFaceup() and c:IsCode(33403500)
end
function cm.handcon(e)
	return Duel.IsExistingMatchingCard(cm.filter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end