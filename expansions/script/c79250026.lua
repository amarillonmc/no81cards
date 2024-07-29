--异想体 被遗忘的杀人魔
local s,id,o=GetID()
s.setcard="Abnormality"
function s.initial_effect(c)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.discon)
	e2:SetValue(c:GetBaseAttack()*2)
	c:RegisterEffect(e2)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetActivityCount(e:GetHandlerPlayer(),ACTIVITY_SPSUMMON)==0
end
function s.distg(e,c)
	return e:GetHandler():GetColumnGroup():IsContains(c)
end