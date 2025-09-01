--拜月教邪术 闪电祭礼
local cm, m = GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c, 33300900, 33300912)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1, m + 100)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
--e1
function cm.e1f1(c, e)
	return c:IsCode(33300900) and c:IsFaceup() and c:IsCanTurnSet() and c:IsCanBeEffectTarget(e)
end
function cm.e1f2(c, e, tp)
	return c:IsCode(33300912) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEUP)
		and Duel.GetLocationCountFromEx(tp, tp, nil, c) > 1
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = Duel.GetMatchingGroup(cm.e1f1, tp, LOCATION_MZONE, 0, nil, e)
	if chkc then return g:IsContains(chkc) end
	if chk == 0 then return #g > 0 and not Duel.IsPlayerAffectedByEffect(tp, 59822133) and
		Duel.IsExistingMatchingCard(cm.e1f2, tp, LOCATION_EXTRA, 0, 2, nil, e, tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp, cm.e1f1, tp, LOCATION_MZONE, 0, 1, 1, nil, e)
	Duel.SetOperationInfo(0, CATEGORY_POSITION, g, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 2, tp, LOCATION_EXTRA)
end
function cm.e1f3(c, g, e, tp)
	return aux.IsCodeListed(c, 33300900) and not g:IsExists(Card.IsCode, 1, nil, c:GetCode())
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false, POS_FACEUP)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp, 59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, cm.e1f2, tp, LOCATION_EXTRA, 0, 2, 2, nil, e, tp)
	if #g ~= 2 then return end
	Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
	local c = Duel.GetFirstTarget()
	if not (c:IsFaceup() and c:IsCanTurnSet() and c:IsRelateToEffect(e))then return end
	if c:IsImmuneToEffect(e) then return end
	g:AddCard(c)
	Duel.ChangePosition(g, POS_FACEDOWN)
	c:ClearEffectRelation()
	Duel.ShuffleSetCard(g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg = g:Select(1 - tp, 1, 1, nil)
	Duel.ConfirmCards(1 - tp, cg)
	c = cg:GetFirst()
	if c:IsOriginalCodeRule(33300900) then Duel.Recover(1 - tp, 1000, REASON_EFFECT) end
	local ct1 = Duel.IsPlayerAffectedByEffect(tp, 29724053) and (c29724053 or {})[tp]
	local ct2 = Duel.IsPlayerAffectedByEffect(tp, 92345028) and (aux.ExtraDeckSummonCountLimit or {})[tp]
	local sg = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, 0, nil)
	sg = Duel.GetMatchingGroup(cm.e1f3, tp, LOCATION_EXTRA, 0, nil, sg, e, tp)
	if c:IsOriginalCodeRule(33300912) and Duel.GetLocationCountFromEx(tp) > 0 and
		Duel.IsPlayerCanSpecialSummonCount(tp, 2) and (not ct1 or ct1 > 1) and (not ct2 or ct2 > 1) and
		#sg > 0 and Duel.SelectYesNo(tp, 1152) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg = sg:Select(tp, 1, 1, nil)
		Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
	end
	Duel.BreakEffect()
	Duel.ChangePosition(g, POS_FACEUP_ATTACK)
	g = g:Filter(Card.IsFaceup, nil):Filter(Card.IsCode, nil, 33300912)
	Duel.SendtoDeck(g, nil, 0, REASON_EFFECT)
end
--e2
function cm.e2f1(c)
	return c:GetType() & 0x81 == 0x81 and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand() and
		(c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.e2f1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetFieldGroup(tp, LOCATION_GRAVE+LOCATION_REMOVED, 0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	g = g:FilterSelect(tp, aux.NecroValleyFilter(cm.e2f1), 1, 1, nil)
	if #g == 0 then return end
	Duel.SendtoHand(g, nil, REASON_EFFECT)
	Duel.ConfirmCards(1 - tp, g)
end