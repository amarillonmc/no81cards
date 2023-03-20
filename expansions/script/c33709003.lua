--INDETERMINATE UNIVERSE
local m=33709003
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1441)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetCountLimit(2)
	e2:SetCondition(cm.condition)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e2_1=e2:Clone()
	e2_1:SetCode(m)
	e2_1:SetCondition(cm.condition2)
	c:RegisterEffect(e2_1)
	--Destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(cm.desreptg)
	e3:SetOperation(cm.desrepop)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(cm.drcon)
	e4:SetCost(cm.drcost)
	e4:SetTarget(cm.drtg)
	e4:SetOperation(cm.drop)
	c:RegisterEffect(e4)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local code=re:GetHandler():GetOriginalCode()
	return code>=m and code<=33709016
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1441,1)
end
function cm.repfilter(c,re)
	local code=re:GetHandler():GetOriginalCode()
	return (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD)) and code>=m and code<=33709016
		and c:IsAbleToRemove() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.repfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,c,e) and c:IsCanRemoveCounter(0x1441,2,REASON_EFFECT+REASON_REPLACE) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,cm.repfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,c,e)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
	Duel.RaiseEvent(e:GetHandler(),m,re,r,rp,ep,ev)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x1441)>=7
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Win(p,0x144f)
	Duel.RaiseEvent(e:GetHandler(),m,re,r,rp,ep,ev)
end