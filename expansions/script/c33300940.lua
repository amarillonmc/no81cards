--天界柱 星旋
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
	e1:SetCode(EVENT_TO_HAND)
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
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
function cm.ff(c)
	return c:IsFusionAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_ROCK)
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsReason, 1, nil, REASON_EFFECT)
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
function cm.e3f1(c, chk)
	if not (c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c, m)) then return false end
	return c:IsAbleToHand() and not (chk and c:IsHasEffect(EFFECT_NECRO_VALLEY))
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.e3f1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp,cm.e3f1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,1)
	if #g == 0 then return end
	Duel.SendtoHand(g, nil, REASON_EFFECT)
	Duel.ConfirmCards(1 - tp, g)
end