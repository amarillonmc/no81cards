--整合运动·狂暴宿主士兵
function c79020031.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2,nil,nil,99)
	c:EnableReviveLimit()  
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c79020031.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)  
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,79020031)
	e3:SetTarget(c79020031.contg)
	e3:SetOperation(c79020031.conop)
	c:RegisterEffect(e3)	 
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,790200319999999)
	e4:SetCost(c79020031.gscost)
	e4:SetOperation(c79020031.gsop)
	c:RegisterEffect(e4)
	--detch Overlay
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(79020031,1))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetOperation(c79020031.mtop)
	c:RegisterEffect(e6)
end
function c79020031.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3900) and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE+LOCATION_EXTRA,0,1,nil,79020034)
end
function c79020031.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c79020031.contg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end
	local c=e:GetHandler()
	local x=c:GetOverlayCount()
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,x,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),tp,0)
end
function c79020031.conop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Destroy(tc,REASON_EFFECT)
end
function c79020031.gscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79020031.gsop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(c:GetAttack()*2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetCondition(c79020031.damcon)
	e2:SetOperation(c79020031.damop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e3:SetOperation(c79020031.xxop)
	c:RegisterEffect(e3)
end
function c79020031.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsDefensePos()
end
function c79020031.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c79020031.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetBattleTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetValue(0x3904)
	tc:RegisterEffect(e1)
	tc:RegisterFlagEffect(79020033,0,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(79020033,4))
end
function c79020031.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(2000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	else
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
end










