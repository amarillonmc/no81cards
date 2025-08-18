--白翼驰星 卡秋娅
local cm, m = GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard, 0x3755))
	e3:SetTargetRange(LOCATION_HAND, 0)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.con4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end
-- e1
function cm.e1f1()
	local g = Group.CreateGroup()
	for p = 0, 1 do
		if Duel.GetLocationCount(p, LOCATION_MZONE, PLAYER_NONE, 0) > 0 then
			g = g + Duel.GetFieldGroup(p, LOCATION_MZONE, 0)
		end
	end
	return g
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #cm.e1f1() > 0 end
end
function cm.e1f2(c)
	return c:IsSummonable(true,nil) and c:IsRace(RACE_WINDBEAST)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_OPERATECARD)
	local g = cm.e1f1():Select(tp, 1, 1, nil)
	Duel.HintSelection(g)
	local c = g:GetFirst()
	if c:IsImmuneToEffect(e) then return end
	local p = c:GetControler()
	local _, zone = Duel.GetLocationCount(p, LOCATION_MZONE, PLAYER_NONE, 0)
	local self_loc, oppo_loc = LOCATION_MZONE, 0
	if p ~= tp then
		self_loc, oppo_loc = 0, LOCATION_MZONE
		zone = (zone << 16) + 0x7F
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOZONE)
	zone = Duel.SelectField(tp, 1, self_loc, oppo_loc, zone)
	if p ~= tp then zone = zone >> 16 end
	Duel.MoveSequence(c, math.log(zone, 2))
	g = Duel.GetMatchingGroup(cm.e1f2, tp, LOCATION_HAND + LOCATION_MZONE, 0, nil)
	if Duel.GetChainInfo(0, CHAININFO_TRIGGERING_LOCATION) ~= LOCATION_HAND
		or #g == 0 or not Duel.SelectYesNo(tp, 91) then return end
	Duel.BreakEffect()
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	g = g:Select(tp, 1, 1, nil):GetFirst()
	Duel.Summon(tp, g, true, nil)
end
-- e4
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN)
end
function cm.e4f1(c)
	return c:GetSequence() > 4
end
function cm.e4f2(c, seq, p)
	return c:IsControler(p) and math.abs(c:GetSequence() - seq) == 1
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = Duel.GetMatchingGroup(cm.e4f1, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
	local fg = Duel.GetFieldGroup(tp, LOCATION_MZONE, LOCATION_MZONE) - g
	for c in aux.Next(fg) do
		local seq = c:GetSequence()
		if not fg:IsExists(cm.e4f2, 1, c, seq, c:GetControler()) then
			g = g + c
		end
	end
	g = g:Filter(Card.IsCanBeEffectTarget, nil, e)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g > 0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g = g:Select(tp, 1, 1, nil):GetFirst()
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	local c = e:GetHandler()
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Destroy(tc,REASON_EFFECT)
end