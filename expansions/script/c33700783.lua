--歌唱！妖精的时之诗！
local m=33700783
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(cm.econ)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1) 
	--cannot set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,1)
	e2:SetTarget(aux.TRUE)
	e2:SetCondition(aux.AND(cm.m1con,cm.effcon))
	e2:SetLabel(5)
	c:RegisterEffect(e2)
	--cannot set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_MSET)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,1)
	e4:SetTarget(aux.TRUE)
	e4:SetCondition(aux.AND(cm.m2con,cm.effcon))
	e4:SetLabel(3)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetTarget(cm.sumlimit)
	c:RegisterEffect(e7)   
	--activate cost
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_ACTIVATE_COST)
	e8:SetRange(LOCATION_SZONE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetTargetRange(0,1)
	e8:SetCondition(aux.AND(cm.m1con,cm.effcon))
	e8:SetCost(cm.costchk)
	e8:SetLabel(7)
	e8:SetOperation(cm.costop)
	c:RegisterEffect(e8)
	--accumulate
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(0x10000000+m)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCondition(aux.AND(cm.m1con,cm.effcon))
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetTargetRange(0,1)
	e9:SetLabel(7)
	c:RegisterEffect(e9)
	--skip turn
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(m,0))
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_SZONE)
	e10:SetCondition(cm.effcon)
	e10:SetLabel(10)
	e10:SetCost(cm.skipcost)
	e10:SetTarget(cm.skiptg)
	e10:SetOperation(cm.skipop)
	c:RegisterEffect(e10)
end
cm.card_code_list={33700760}
function cm.skipcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.skiptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN) end
end
function cm.skipop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function cm.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,23851033)
	return Duel.CheckLPCost(tp,ct*800)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,800)
end
function cm.m1con(e)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 
end
function cm.m2con(e)
	return Duel.GetCurrentPhase()==PHASE_MAIN2 
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end
function cm.effcon(e)
	return Duel.IsExistingMatchingCard(cm.effilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,e:GetLabel(),nil)
end
function cm.effilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x344a) or c:IsSetCard(0x644a))
end
function cm.econ(e)
	return Duel.IsExistingMatchingCard(cm.ecfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function cm.ecfilter(c)
	return c:IsFaceup() and c:IsCode(33700773)
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end