--三角攻阵-白翼驰星
local cm, m = GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
--e2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler()
end
function cm.e2f1(c, e, tp)
	return c:IsSetCard(0xc754) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local lab = Duel.GetFlagEffectLabel(tp, m) or 0
	local b1, b2 = lab & 21 == 0, lab & 42 == 0
	local g = Duel.GetFieldGroup(tp, LOCATION_DECK, 0)
	b1 = b1 and g:Filter(Card.IsSetCard, nil, 0x3755):IsExists(Card.IsAbleToHand, 1, nil)
	b2 = b2 and g:IsExists(cm.e2f1, 1, nil, e, tp) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
	if chk==0 then return b1 or b2 end
	local op = b1 and 1 or 2
	if b1 and b2 then
		op = Duel.SelectOption(tp, 1190, 1152) + 1
	else
		Duel.Hint(HINT_SELECTMSG, 1 - tp, 1152 + op * 38)
	end
	if lab > 0 then
		Duel.SetFlagEffectLabel(tp, m, lab & 48 | op << 2 | lab & 3)
	else
		Duel.RegisterFlagEffect(tp, m, RESET_PHASE + PHASE_END, 0, 1, op)
	end
	if op == 0 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op == 1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function cm.op21(e, tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g = Duel.GetFieldGroup(tp, LOCATION_DECK, 0)
	g = g:Filter(Card.IsSetCard, nil, 0x3755):FilterSelect(tp, Card.IsAbleToHand, 1, 1, nil)
	if #g == 0 then return end
	Duel.SendtoHand(g, nil, REASON_EFFECT)
	Duel.ConfirmCards(1 - tp, g)
end
function cm.op22(e, tp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) == 0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, cm.e2f1, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
	if #g == 0 then return end
	Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local lab = Duel.GetFlagEffectLabel(tp, m)
	local lab1, lab2 = lab & 12, lab & 3
	if lab1 > 0 then
		cm["op2" .. (lab1 >> 2)](e, tp)
		Duel.SetFlagEffectLabel(tp, m, lab & 48 | lab1 << 2 | lab2)
	elseif lab2 > 0 then
		cm["op2" .. lab2](e, tp)
		Duel.SetFlagEffectLabel(tp, m, lab & 48 | lab1 << 4)
	end
end
--e3
function cm.e3f1(c, e)
	if Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE, PLAYER_NONE, 0) == 0 then return false end
	return c:IsLocation(LOCATION_MZONE) and c:IsCanBeEffectTarget(e)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = eg:Filter(cm.e3f1, nil, e)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g > 0 end
	if #g > 1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		g:Select(tp, 1, 1, nil)
	end
	Duel.SetTargetCard(g)
end
function cm.op3val1(e,re,tp)
	return re:GetHandler():IsCode(m)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.op3val1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local c = Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
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
end