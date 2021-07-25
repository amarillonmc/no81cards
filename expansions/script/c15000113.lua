local m=15000113
local cm=_G["c"..m]
cm.name="笼影深渊·红神安提拉"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000113)
	aux.AddCodeList(c,15000114)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,true)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(cm.cttg)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,15000113)
	e2:SetCost(cm.stcost)
	e2:SetTarget(cm.sttg)
	e2:SetOperation(cm.stop)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetTarget(cm.disable)
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1,15010113)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.negcon)
	e4:SetCost(cm.negcost)
	e4:SetTarget(cm.negtg)
	e4:SetOperation(cm.negop)
	c:RegisterEffect(e4)
	--counter
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCountLimit(1,15020113)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.ct2con)
	e5:SetTarget(cm.ct2tg)
	e5:SetOperation(cm.ct2op)
	c:RegisterEffect(e5)
end
function cm.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT or c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:GetCounter(0x1f30)>=1 and c:GetOriginalCode()~=15000113
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,0x1f30,1) end
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,0x1f30,1)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1f30,1)
		tc=g:GetNext()
	end
end
function cm.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1f30,9,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1f30,9,REASON_COST)
end
function cm.stfilter(c)
	return c:IsCode(15000114) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function cm.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetCondition(cm.aclimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(15000113,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_SET_AVAILABLE,1)
	end
end
function cm.actfilter(c)
	return (c:IsSetCard(0xf37) or c:IsSetCard(0xf39) or c:IsSetCard(0xf3a)) and c:IsType(TYPE_MONSTER)
end
function cm.aclimit(e)
	return not Duel.IsExistingMatchingCard(cm.actfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev)
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,m,0x1f30,4,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1f30,4,REASON_COST)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsAbleToGrave() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
end
function cm.ct2con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return cm.actfilter(re:GetHandler()) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.ct2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,0,LOCATION_ONFIELD,1,nil,0x1f30,2) end
end
function cm.ct2op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,0,LOCATION_ONFIELD,nil,0x1f30,2)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1f30,2)
		tc=g:GetNext()
	end
end