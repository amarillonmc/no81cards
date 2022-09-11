local m=15004139
local cm=_G["c"..m]
cm.name="世界墟==0"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--use 0 for damage calc
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetCondition(cm.atkcon)
	e5:SetOperation(cm.atkop)
	c:RegisterEffect(e5)
end
function cm.sprfilter(c,tp,sc)
	return c:IsFaceup() and c:IsAttack(0) and c:IsAbleToGraveAsCost() and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_LINK)
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_MZONE,0,nil,tp,c)
	return g:GetCount()~=0
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_MZONE,0,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(g1,REASON_COST)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac,bc=Duel.GetBattleMonster(tp)
	return bc and ac
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsRelateToBattle() and d and d:IsRelateToBattle() then
		local ea=Effect.CreateEffect(c)
		ea:SetType(EFFECT_TYPE_SINGLE)
		ea:SetCode(EFFECT_SET_BATTLE_ATTACK)
		ea:SetReset(RESET_PHASE+PHASE_DAMAGE)
		ea:SetValue(0)
		a:RegisterEffect(ea,true)
		local ed=Effect.CreateEffect(c)
		ed:SetType(EFFECT_TYPE_SINGLE)
		ed:SetCode(EFFECT_SET_BATTLE_ATTACK)
		ed:SetReset(RESET_PHASE+PHASE_DAMAGE)
		ed:SetValue(0)
		d:RegisterEffect(ed,true)
	end
end