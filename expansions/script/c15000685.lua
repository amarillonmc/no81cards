local m=15000685
local cm=_G["c"..m]
cm.name="宇之终始星之诞灭·银河"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,15000685)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_REMOVE_COUNTER+0x1f35)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1)
	--Equip==0
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetCondition(cm.tecon)
	e2:SetOperation(cm.teop)
	c:RegisterEffect(e2)
	--Equip>=1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,1)
	e3:SetValue(1)
	e3:SetCondition(cm.actcon)
	c:RegisterEffect(e3)
	--Equip>=2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e4:SetCondition(cm.econ)
	e4:SetTarget(cm.efilter)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_INACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(cm.effectfilter)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_DISEFFECT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(cm.effectfilter)
	c:RegisterEffect(e6)
	--Equip>=3
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetCondition(cm.immcon)
	e7:SetValue(cm.immfilter)
	c:RegisterEffect(e7)
	--Equip>=4
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetCode(EFFECT_CANNOT_ACTIVATE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(1,1)
	e8:SetValue(cm.ac2limit)
	e8:SetCondition(cm.act2con)
	c:RegisterEffect(e8)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	Duel.Damage(1-tp,300*ev,REASON_EFFECT)
end
function cm.eqfilter(c,sc)
	return sc:GetEquipGroup():IsContains(c)
end
function cm.tecon(e)
	local c=e:GetHandler()
	return Duel.GetMatchingGroupCount(cm.eqfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil,c)==0 and c:IsAbleToExtra()
end
function cm.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if not c:IsAbleToExtra() then return end
	Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
end
function cm.actcon(e)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()) and Duel.GetMatchingGroupCount(cm.eqfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil,c)>=1
end
function cm.econ(e)
	local c=e:GetHandler()
	return Duel.GetMatchingGroupCount(cm.eqfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil,c)>=2
end
function cm.efilter(e,c)
	return e:GetHandler():GetEquipGroup():IsContains(c)
end
function cm.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return e:GetHandler():GetEquipGroup():IsContains(te:GetHandler())
end
function cm.immcon(e)
	local c=e:GetHandler()
	return Duel.GetMatchingGroupCount(cm.eqfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil,c)>=3
end
function cm.immfilter(e,te)
	if te:GetHandler()==e:GetHandler() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end
function cm.act2con(e)
	local c=e:GetHandler()
	return Duel.GetMatchingGroupCount(cm.eqfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil,c)>=4
end
function cm.ac2limit(e,re,tp)
	return re:GetHandler():IsType(TYPE_MONSTER) and (re:GetHandler():IsLocation(LOCATION_ONFIELD) or re:GetHandler():IsLocation(LOCATION_GRAVE)) and not (re:IsHasType(EFFECT_TYPE_SINGLE) 
		and ((bit.band(re:GetCode(),EVENT_SUMMON_SUCCESS)~=0) or (bit.band(re:GetCode(),EVENT_SPSUMMON_SUCCESS)~=0) or (bit.band(re:GetCode(),EVENT_FLIP)~=0))
		and (re:IsHasType(EFFECT_TYPE_TRIGGER_F) or re:IsHasType(EFFECT_TYPE_TRIGGER_O) or re:IsHasType(EFFECT_TYPE_QUICK_F) or re:IsHasType(EFFECT_TYPE_QUICK_O)))
end