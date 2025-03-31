--超时空武装 主武-重力炮
local m=13257312
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
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.econ)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(cm.discon)
	e4:SetOperation(cm.disop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetTarget(cm.distg)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_POSITION)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(cm.econ)
	e7:SetTarget(cm.target)
	e7:SetOperation(cm.activate)
	c:RegisterEffect(e7)
	
end
function cm.eqlimit(e,c)
	return not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x3352)
end
function cm.econ(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if ec and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		ec:RegisterEffect(e1)
	end
end
function cm.disfilter(c)
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local f=tama.cosmicFighters_equipGetFormation(e:GetHandler())
	if not f then return false end
	local ec=f:Filter(cm.disfilter,nil):GetFirst()
	return ec and ec:GetBattleTarget()
end
function cm.distg(e,c)
	return c:GetFlagEffect(m)~=0
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local f=tama.cosmicFighters_equipGetFormation(e:GetHandler())
	local ec=f:Filter(cm.disfilter,nil):GetFirst()
	local tc=ec:GetBattleTarget()
	tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
	Duel.AdjustInstantly(e:GetHandler())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end
