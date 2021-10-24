--夕阳之剑的追想
local m=86510002
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_WIND),3,5)
	c:EnableReviveLimit()
----add counter----
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	--spell/trap activation add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.acop)
	c:RegisterEffect(e1)
	--summon/special summon activation add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.ctop2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--attack declaration activation add counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetCondition(cm.countercon)
	e4:SetTarget(cm.countertg)
	e4:SetOperation(cm.counterop)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(cm.desreptg)
	e5:SetValue(cm.repval)
	e5:SetOperation(cm.desrepop)
	c:RegisterEffect(e5)
	--cannot target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.indcon)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--negate
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,0))
	e7:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_CHAINING)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,m)
	e7:SetCondition(cm.discon)
	e7:SetCost(cm.dscost)
	e7:SetTarget(cm.distg)
	e7:SetOperation(cm.disop)
	c:RegisterEffect(e7)
	--all removed
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,1))
	e8:SetCategory(CATEGORY_REMOVE)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,m+1)
	e8:SetCost(cm.tdcost)
	e8:SetTarget(cm.tdtg)
	e8:SetOperation(cm.tdop)
	c:RegisterEffect(e8)
end
----add counter----
--spell/trap activation add counter
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x5652,1)
	end
end
--summon/special summon  activation add counter
function cm.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function cm.ctop2(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.cfilter,1,nil,1-tp) then
		e:GetHandler():AddCounter(0x5652,1)
	end
end
--attack declaration activation add counter
function cm.countercon(e)
	return Duel.GetAttacker():IsFaceup() 
end
function cm.countertg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return Duel.GetAttacker():IsFaceup()  end
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x5652,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
end
function cm.counterop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x5652,1)
end
--destroy replace
function cm.thfilter(c,mc)
	return mc:GetLinkedGroup():IsContains(c) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE) and c:IsCode(86510002) 
end
function cm.repval(e,c)
	return cm.thfilter(c,e:GetHandler()) or c==e:GetHandler()
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (eg:IsExists(cm.thfilter,1,nil,c) or eg:IsContains(c)) and Duel.IsCanRemoveCounter(tp,1,0,0x5652,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RemoveCounter(tp,1,0,0x5652,1,REASON_EFFECT+REASON_REPLACE)
end
--cannot target
function cm.indcon(e)
	return e:GetHandler():GetCounter(0x5652)>=4
end
--negate
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.dscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x5652,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x5652,2,REASON_COST)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
--all removed
function cm.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x5652,8,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x5652,8,REASON_COST)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if aux.NecroValleyNegateCheck(g) then return end
	Duel.Remove(g,POS_FACEUP,2,REASON_EFFECT)
end