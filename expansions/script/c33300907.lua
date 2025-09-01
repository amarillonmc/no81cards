--拜月邪徒仪式
local cm, m = GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,33300900)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
--e1
function cm.e1f1(c, e, tp)
	return c:GetType() & 0x81 == 0x81 and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_RITUAL, tp, false, true)
		and (c:IsLocation(LOCATION_DECK) and c:IsCode(33300900) or c:IsRace(RACE_SPELLCASTER))
end
function cm.e1f2(c, tp, mg)
	local g = mg:Filter(Card.IsCanBeRitualMaterial, c, c):Filter((c.mat_filter or aux.TRUE), nil, tp)
	if c:IsLocation(LOCATION_DECK) then g = g:Filter(Card.IsSetCard, nil, 0x569) end
	local lv = c:GetLevel()
	Auxiliary.GCheckAdditional = Auxiliary.RitualCheckAdditional(c, lv, "Greater")
	local res = g:CheckSubGroup(Auxiliary.RitualCheck, 1, lv, tp, c, lv, "Greater")
	Auxiliary.GCheckAdditional = nil
	return res
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg = Duel.GetRitualMaterial(tp)
	local rg = Duel.GetMatchingGroup(cm.e1f1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return rg:IsExists(cm.e1f2, 1, nil, tp, mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local mg = Duel.GetRitualMaterial(tp)
	local rg = Duel.GetMatchingGroup(cm.e1f1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp)
	::LunaticSelect::
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local c = rg:FilterSelect(tp,Auxiliary.NecroValleyFilter(cm.e1f2),1,1,nil,tp,mg):GetFirst()
	if not c then return end
	local g = mg:Filter(Card.IsCanBeRitualMaterial, c, c):Filter((c.mat_filter or aux.TRUE), nil, tp)
	if c:IsLocation(LOCATION_DECK) then g = g:Filter(Card.IsSetCard, nil, 0x569) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local lv = c:GetLevel()
	Auxiliary.GCheckAdditional = Auxiliary.RitualCheckAdditional(c, lv, "Greater")
	g = g:SelectSubGroup(tp, Auxiliary.RitualCheck, true, 1, lv, tp, c, lv, "Greater")
	Auxiliary.GCheckAdditional = nil
	if not g then goto LunaticSelect end
	c:SetMaterial(g)
	Duel.ReleaseRitualMaterial(g)
	Duel.BreakEffect()
	Duel.SpecialSummon(c, SUMMON_TYPE_RITUAL, tp, tp, false, true, POS_FACEUP)
	c:CompleteProcedure()
end
--e2
function cm.e2f1(c, p)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsCode(33300900) and c:GetReasonPlayer() == p
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(cm.e2f1, 1, nil, 1 - tp)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function cm.e2f2(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c.CelestialPillars
end
function cm.e2f3(c, ps)
	local seq = c:GetSequence() - ps
	return (seq - 6) * (seq - 3 * ps) == 0
end
function cm.e2f4()
	for p = 0, 1 do
		for z = 0, 1 do
			if not (Duel.CheckLocation(p, LOCATION_PZONE, z) or
				Duel.IsExistingMatchingCard(cm.e2f3, p, LOCATION_SZONE, 0, 1, nil, z)) then
				return false
			end
		end
	end
	return true
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoDeck(c,nil,2,REASON_EFFECT)==0 or
		not c:IsLocation(LOCATION_DECK) then return end
	Duel.Hint(HINT_OPSELECTED, tp, 16 * m)
	Duel.Hint(HINT_OPSELECTED, 1 - tp, 16 * m)
	local g = Duel.GetMatchingGroup(cm.e2f2,tp,LOCATION_EXTRA,0,nil)
	if not (cm.e2f4() and g:GetClassCount(Card.GetCode) > 3
		and Duel.SelectYesNo(tp, 16 * m + 1)) then return end
	Duel.BreakEffect()
	local dg = Duel.GetFieldGroup(tp, LOCATION_PZONE, LOCATION_PZONE)
	if #dg > 0 then Duel.Destroy(dg, REASON_RULE) end
	Duel.Hint(HINT_SELECTMSG,tp,16 * m + 2)
	dg = g:SelectSubGroup(tp, aux.dncheck, false, 2, 2)
	for c in aux.Next(dg) do
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
	Duel.Hint(HINT_SELECTMSG,tp,16 * m + 3)
	local f = function(g, sg) return aux.dncheck(g + sg) end
	g = (g - dg):SelectSubGroup(tp, f, false, 2, 2, dg)
	for c in aux.Next(g) do
		Duel.MoveToField(c,tp,1 - tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end