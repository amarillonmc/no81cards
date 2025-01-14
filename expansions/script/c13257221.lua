--宇宙战争兵器 主炮 电浆炮
local m=13257221
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
	e1:SetValue(700)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.damcon)
	e3:SetOperation(cm.damop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(cm.damcon1)
	e4:SetOperation(cm.damop1)
	c:RegisterEffect(e4)
	--Mk-4 Laser
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,0))
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(cm.descon)
	e8:SetTarget(cm.destg)
	e8:SetOperation(cm.desop)
	c:RegisterEffect(e8)
	eflist={{"equipment_rank",4}}
	cm[c]=eflist
	
end
function cm.econ(e)
	return e:GetHandler():GetEquipTarget()
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetEquipTarget() and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
	if ec then
		local ct1=tama.cosmicBattleship_getCoreLevel(ec)*150
		if ct>0 and ct1>0 then
			Duel.Hint(HINT_CARD,1,m)
			Duel.Damage(1-tp,ct*ct1,REASON_EFFECT)
		end
	end
end
function cm.damfilter(c,tp)
	return c:GetPreviousControler()==tp
end
function cm.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetEquipTarget() and eg:IsExists(cm.damfilter,1,nil,1-tp)
end
function cm.damop1(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local ct=eg:FilterCount(cm.damfilter,nil,1-tp)
	if ec then
		local ct1=tama.cosmicBattleship_getCoreLevel(ec)*150
		if ct>0 and ct1>0 then
			Duel.Hint(HINT_CARD,1,m)
			Duel.Damage(1-tp,ct*ct1,REASON_EFFECT)
		end
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget() and Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.desfilter(c)
	return c:GetSequence()==0 or c:GetSequence()==4
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
