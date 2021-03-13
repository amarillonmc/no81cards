--鸢一折纸 毁灭的魔王
local m=33400417
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,cm.xyzfilter,6,2)
	c:EnableReviveLimit()
--sp
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetCondition(cm.con)
	c:RegisterEffect(e1)
 --change damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
 --negate activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
function cm.xyzfilter(c)
	return c:IsSetCard(0x341) 
end

function cm.ckfilter(c)
	return c:IsSetCard(0x5343) and c:IsFaceup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil)
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(cm.efilter)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e4:SetOwnerPlayer(tp)
	e:GetHandler():RegisterEffect(e4)
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return  ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) end   
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ss
	local fs=0
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil)
	and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
	 ss=Duel.SendtoGrave(g,REASON_EFFECT) 
	 fs=1   
	else
	 ss=Duel.Destroy(g,REASON_EFFECT)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(ss*1000)
	c:RegisterEffect(e2)
	if fs==1 then 
	local e1_3=Effect.CreateEffect(c)
	e1_3:SetType(EFFECT_TYPE_FIELD)
	e1_3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1_3:SetTargetRange(0,1)
	e1_3:SetValue(cm.actlimit)
	e1_3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_3,tp)
	end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_ATTACK)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(cm.ftarget)
	e0:SetLabel(c:GetFieldID())
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
end
function cm.actlimit(e,re,tp)
	return  not re:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function cm.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end