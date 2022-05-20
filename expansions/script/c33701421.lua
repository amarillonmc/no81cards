--新晦空城
local m=33701421
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE_START+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.condition)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(cm.reptg)
	e3:SetOperation(cm.repop)
	c:RegisterEffect(e3)
	--tian shen dang
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(cm.descon)
	e4:SetCost(cm.descost)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0x144e))
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)<=0 then
		c:AddCounter(0x144e,5)
	end
	if Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)<=0 then
		c:AddCounter(0x144e,10)
	end
	if Duel.GetActivityCount(tp,ACTIVITY_ATTACK)<=0 then
		c:AddCounter(0x144e,8)
	end
	if Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)<=0 then
		c:AddCounter(0x144e,20)
	end
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=math.ceil(c:GetCounter(0x144e)/2)
	if chk==0 then return not c:IsReason(REASON_REPLACE)
		and c:IsCanRemoveCounter(tp,0x144e,ct,REASON_EFFECT) end
	return true
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=math.ceil(e:GetHandler():GetCounter(0x144e)/2)
	e:GetHandler():RemoveCounter(tp,0x144e,ct,REASON_EFFECT)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x144e)>=64
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_DECK+LOCATION_EXTRA,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,sg:GetCount()*100)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil)
	local ct=Duel.Destroy(sg,REASON_EFFECT)
	if ct>0 then
		Duel.Damage(1-tp,ct*100,REASON_EFFECT)
	end
end
