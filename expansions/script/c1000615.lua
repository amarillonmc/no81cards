--奇迹的少女  鹿目圆香
function c1000615.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xc204),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--damage
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(1000615,0))
	e7:SetCategory(CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_BATTLE_DESTROYING)
	e7:SetCondition(c1000615.con2)
	e7:SetTarget(c1000615.damtg)
	e7:SetOperation(c1000615.damop)
	c:RegisterEffect(e7)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c1000615.con)
	e3:SetValue(c1000615.atkup)
	c:RegisterEffect(e3)
	local e2=e3:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetCondition(c1000615.con3)
	c:RegisterEffect(e1)
end
function c1000615.filter9(c,e,tp)
	return c:IsSetCard(0xc204) and c:IsControler(tp)
end
function c1000615.con2(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c1000615.filter9,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
   return  ct>=6
end
function c1000615.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetHandler():GetBattleTarget()
	local atk=tc:GetBaseAttack()
	if atk<0 then atk=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c1000615.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c1000615.con(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c1000615.filter9,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
   return  ct>=3
end
function c1000615.atkup(e,c)
	return Duel.GetMatchingGroupCount(c1000615.filter9,LOCATION_GRAVE,0,nil,e,tp)*300
end
function c1000615.con3(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c1000615.filter9,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
   return  ct>=9
end