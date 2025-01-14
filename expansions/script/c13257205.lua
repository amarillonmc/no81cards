--宇宙战争兵器 外壳 波纹镭射
local m=13257205
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(tama.cosmicBattleship_equipLimit_primaryWeapon)
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
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(600)
	c:RegisterEffect(e1)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(200)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.cacon)
	e3:SetTarget(cm.catg)
	e3:SetOperation(cm.caop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(cm.descon)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	eflist={{"equipment_rank",2}}
	cm[c]=eflist
	
end
function cm.econ(e)
	return e:GetHandler():GetEquipTarget()
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function cm.cacon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if ec and ec:IsRelateToBattle() and ec:IsStatus(STATUS_OPPO_BATTLE) then
		local bc=ec:GetBattleTarget()
		return bc and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
	else return false end
end
function cm.catg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if chk==0 then return ec:IsChainAttackable() end
end
function cm.caop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not ec:IsRelateToBattle() or not c:IsRelateToEffect(e) then return end
	Duel.ChainAttack()
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
