--天界柱 星云
local cm, m = GetID()
cm.CelestialPillars = true
function cm.initial_effect(c)
	aux.AddCodeList(c, m)
	c:EnableCounterPermit(0x56a,LOCATION_PZONE)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c, false)
	aux.AddFusionProcFunRep(c, cm.ff, 2, false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
function cm.ff(c)
	return c:IsFusionAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_ROCK)
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	c:AddCounter(0x56a, 1)
	if c:GetCounter(0x56a) < 3 then return end
	Duel.BreakEffect()
	Duel.Destroy(c, REASON_EFFECT)
end
--e2
function cm.val2(e,te)
	return te:GetOwner() ~= e:GetOwner()
end
--e3
function cm.e3f1(c, e)
	return c:IsAbleToHand() and c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCanBeEffectTarget(e)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = Duel.GetMatchingGroup(cm.e3f1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g > 0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	g = Duel.SelectTarget(tp,cm.e3f1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end