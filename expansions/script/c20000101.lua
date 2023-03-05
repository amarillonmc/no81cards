--不灭的煌印
local cm,m,o=GetID()
fu_judg=fu_judg or {}
function fu_judg.A(c)
	aux.AddCodeList(c,20000100)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	return e0
end
function fu_judg.E(c,atk,def)
	if not atk then atk=700 end
	local e0=fu_judg.A(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,20000100))
	e1:SetValue(atk)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	if def then e2:SetValue(def) end
	c:RegisterEffect(e2)
	return e0,e1,e2
end
function fu_judg.F(c,cod)
	local e0=fu_judg.A(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(fu_judg.Fcon1(cod))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(cod,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCost(fu_judg.Fcos2)
	e2:SetTarget(fu_judg.Ftg2)
	e2:SetOperation(fu_judg.Fop2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SUMMON,fu_judg.glof)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,fu_judg.glof)
	return e0,e1,e2
end
---------------------------------------------------------------
function fu_judg.Fcon1(cod)
	return function(e,re,tp)
		return Duel.GetCustomActivityCount(cod,tp,ACTIVITY_SUMMON)+Duel.GetCustomActivityCount(cod,tp,ACTIVITY_SPSUMMON)>0
	end
end
function fu_judg.Fcos2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(fu_judg.Fcosf2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function fu_judg.Fcosf2(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_EFFECT)
end
function fu_judg.Ftg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,20000100,0x3fd1,TYPES_TOKEN_MONSTER,0,0,7,RACE_DRAGON,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function fu_judg.Fop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,20000100,0x3fd1,TYPES_TOKEN_MONSTER,0,0,7,RACE_DRAGON,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,20000100)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function fu_judg.glof(c)
	return not c:IsType(TYPE_EFFECT)
end
if not cm then return end
---------------------------------------------------------------
function cm.initial_effect(c)
	local e1={fu_judg.E(c,0,1800)}
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,20000100))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.tg2)
	e3:SetValue(cm.val2)
	e3:SetOperation(cm.op2)
	c:RegisterEffect(e3)
end
--e3
function cm.tgf2(c,tp)
	return c:IsFaceup() and c:IsCode(20000100) and c:IsOnField() and c:IsControler(tp) 
		and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.tgf2,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.val2(e,c)
	return cm.tgf2(c,e:GetHandlerPlayer())
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end