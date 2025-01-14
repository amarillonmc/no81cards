--超时空武装 主武-环形镭射
local m=13257310
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(cm.eqlimit)
	c:RegisterEffect(e11)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.tg)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.tg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(cm.cost)
	e3:SetCondition(cm.econ)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	
end
function cm.eqlimit(e,c)
	return not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x3352)
end
function cm.filter(c,def)
	return c:IsFaceup() and c:IsAttackBelow(def)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local f=tama.cosmicFighters_equipGetFormation(c)
	if chk==0 then return f and f:GetCount()>c:GetFlagEffect(m) end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.econ(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetEquipTarget()
	if chk==0 then return tc and Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,tc,tc:GetDefense()) end
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,tc,tc:GetDefense())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	if tc and tc:IsFaceup() and e:GetHandler():IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,tc,tc:GetDefense())
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function cm.tg(e,c)
	local tc=e:GetHandler():GetEquipTarget()
	if not tc then return false end
	return c:IsSetCard(0x351) or tc==c
end
