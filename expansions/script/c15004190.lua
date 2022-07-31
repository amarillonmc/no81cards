local m=15004190
local cm=_G["c"..m]
cm.name="虚实写笔-鹰"
function cm.initial_effect(c)
	--Dual
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_SUMMONABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.VNormalCondition)
	e2:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_REMOVE_TYPE)
	e3:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e3)
	--change base attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.VNormalCondition)
	e4:SetCode(EFFECT_SET_BASE_ATTACK)
	e4:SetValue(1900)
	c:RegisterEffect(e4)
	--Summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCountLimit(1,15004190)
	e5:SetCondition(cm.scon)
	e5:SetTarget(cm.stg)
	e5:SetOperation(cm.sop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCountLimit(1,15004191)
	c:RegisterEffect(e6)
	--DualState
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.dacon)
	e3:SetOperation(cm.daop)
	c:RegisterEffect(e3)
end
function cm.VNormalCondition(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsDualState()
end
function cm.filter(c)
	return c:IsSummonable(true,nil)
end
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_EFFECT)
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function cm.dacon(e,tp,eg,ep,ev,re,r,rp)
	return ((not e:GetHandler():IsDualState()) and (not re:GetHandler():IsCode(15004190)))
end
function cm.daop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,15004190)
	e:GetHandler():EnableDualState()
end