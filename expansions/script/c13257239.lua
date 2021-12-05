--宇宙战争兵器 护罩-坚固装甲
local m=13257239
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(tama.cosmicBattleship_equipLimit_shield)
	c:RegisterEffect(e11)
	--immune
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_IMMUNE_EFFECT)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCondition(cm.econ)
	e12:SetValue(cm.efilter)
	c:RegisterEffect(e12)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e2:SetTarget(cm.actfilter)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--no damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetCode(EVENT_BATTLED)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(cm.descon)
	e5:SetTarget(cm.destg)
	e5:SetOperation(cm.desop)
	c:RegisterEffect(e5)
	eflist={{"equipment_rank",1}}
	cm[c]=eflist
	
end
function cm.econ(e)
	return e:GetHandler():GetEquipTarget()
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	return c and c:GetBattleTarget()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetEquipTarget():GetBattleTarget()
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and bc:IsRelateToEffect(e) then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
function cm.actfilter(e,c)
	local ec=e:GetHandler():GetEquipTarget()
	if not ec then return false end
	local ecg=ec:GetEquipGroup()
	return c~=e:GetHandler() and ecg:IsContains(c)
end
