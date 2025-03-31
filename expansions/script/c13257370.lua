--超时空武装 主武-主炮
local m=13257370
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
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.eqcon)
	e1:SetTarget(cm.eqtg)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetCondition(cm.con)
	e3:SetValue(0x351)
	c:RegisterEffect(e3)
	--selfdes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(cm.descon)
	c:RegisterEffect(e4)
	
end
function cm.eqlimit(e,c)
	return not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x3352)
end
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()~=1 then return false end
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() and not tc:IsSetCard(0x351)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if chk==0 then return c:CheckEquipTarget(tc) end
	tc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and not ec:IsOriginalSetCard(0x351)
end
function cm.descon(e)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsOriginalSetCard(0x351)
end
