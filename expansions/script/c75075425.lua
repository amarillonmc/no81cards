--白翼的牵绊
local cm, m = GetID()
function cm.initial_effect(c)
	aux.AddLinkProcedure(c, cm.linkf, 1, 1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISEFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.con1)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, m)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetRange(LOCATION_ONFIELD + LOCATION_GRAVE + LOCATION_REMOVED)
	e3:SetCondition(cm.con3)
	c:RegisterEffect(e3)
end
-- linkf
function cm.linkf(c)
	return c:IsLinkSetCard(0xc754) and not c:IsType(TYPE_LINK)
end
--e1
function cm.e1f(c, zone)
	return (1 << c:GetSequence()) & zone > 0
end
function cm.con1(e)
	local c = e:GetHandler()
	if #c:GetLinkedGroup() > 0 or c:GetSequence() < 5 then return false end
	local zone = c:GetLinkedZone()
	zone = (zone << 1 | zone >> 1) & 0x1F
	return Duel.IsExistingMatchingCard(cm.e1f, c:GetControler(), LOCATION_MZONE, 0, 1, c, zone)
end
function cm.val1(e, ev)
	return e:GetHandler():IsControler(Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_PLAYER))
end
--e2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_ONFIELD, 0, nil)
	if chk==0 then return #g > 0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_ONFIELD)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, Card.IsFaceup, tp, LOCATION_ONFIELD, 0, 1, 1, nil)
	if #g == 0 then return end
	Duel.HintSelection(g)
	Duel.SendtoHand(g, nil, REASON_EFFECT)
	g = Duel.GetMatchingGroup(Card.IsLinkSummonable, tp, LOCATION_EXTRA, 0, nil, nil)
	if #g == 0 or not Duel.SelectYesNo(tp, 1166) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g = g:Select(tp, 1, 1, nil):GetFirst()
	Duel.BreakEffect()
	Duel.LinkSummon(tp, g, nil)
end
--e3
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	return eg:IsContains(c) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end