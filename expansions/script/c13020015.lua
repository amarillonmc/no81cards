--在水一方
local cm, m, ofs = GetID()
local yr = 13020010
xpcall(function() dofile("expansions/script/c16670000.lua") end, function() dofile("script/c16670000.lua") end) --引用库
function cm.initial_effect(c)
	aux.AddCodeList(c, yr)
	aux.AddEquipSpellEffect(c, true, true, nil, nil)
	local e1 = xg.epp2(c, m, 4, EVENT_EQUIP, EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY, QY_mx, nil, nil, cm.target,
		cm.operation, true)
	e1:SetCountLimit(1, m)
	local e3 = Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1, m + 1)
	e3:SetCondition(cm.descon)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
end

function aux.AddEquipSpellEffect(c, is_self, is_opponent, filter, eqlimit, pause, skip_target)
	local value = (type(eqlimit) == "function") and eqlimit or 1
	if pause == nil then pause = false end
	if skip_target == nil then skip_target = false end
	--Activate
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET + EFFECT_FLAG_CONTINUOUS_TARGET)
	if not skip_target then
		e1:SetTarget(cm.EquipSpellTarget(is_self, is_opponent, filter, eqlimit))
	end
	e1:SetOperation(cm.EquipSpellOperation(eqlimit))
	if not pause then
		c:RegisterEffect(e1)
	end
	--Equip limit
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(value)
	c:RegisterEffect(e2)
	return e1
end

function cm.EquipSpellTarget(is_self, is_opponent, filter, eqlimit)
	local loc1 = is_self and LOCATION_MZONE or 0
	local loc2 = is_opponent and LOCATION_MZONE or 0
	return function(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
		if chkc then return chkc:IsLocation(LOCATION_MZONE) and (not eqlimit or eqlimit(e, chkc)) end
		if chk == 0 then return Duel.IsExistingTarget(filter, tp, loc1, loc2, 1, nil) end
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
		Duel.SelectTarget(tp, filter, tp, loc1, loc2, 1, 1, nil)
		Duel.SetOperationInfo(0, CATEGORY_EQUIP, e:GetHandler(), 1, 0, 0)
	end
end

function cm.EquipSpellOperation(eqlimit)
	return function(e, tp, eg, ep, ev, re, r, rp)
		local c = e:GetHandler()
		local tc = Duel.GetFirstTarget()
		if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and (not eqlimit or eqlimit(e, tc)) then
			Duel.Equip(tp, c, tc)
		end
	end
end

function cm.filter(c)
	return c:IsCode(yr) and c:IsAbleToHand()
end

function cm.filter1(c, ec, c2)
	return c:GetEquipTarget() == ec and c == c2
end

function cm.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	local c = e:GetHandler()
	local tc = e:GetHandler():GetEquipTarget()
	local dg = eg:Filter(cm.filter1, nil, tc, c)
	local g = Duel.GetMatchingGroup(cm.filter, tp, LOCATION_DECK + QY_md, 0, nil)
	if chk == 0 then return #dg > 0 and tc and tc:IsCanChangePosition() and #g > 0 end
	Duel.SetOperationInfo(0, CATEGORY_POSITION, tc, 1, 0, 0)
end

function cm.operation(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = c:GetEquipTarget()
	if not c:IsRelateToEffect(e) then return end
	if tc and Duel.ChangePosition(tc, POS_FACEUP_DEFENSE, POS_FACEUP_DEFENSE, POS_FACEUP_ATTACK, POS_FACEUP_ATTACK) ~= 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local g = Duel.SelectMatchingCard(tp, cm.filter, tp, LOCATION_DECK + QY_md, 0, 1, 1, nil)
		if g:GetCount() > 0 then
			if Duel.SendtoHand(g, nil, REASON_EFFECT) ~= 0 then
				Duel.ConfirmCards(1 - tp, g)
				if xg.ky(tp, m, 1) then
					Duel.ChangePosition(tc, POS_FACEUP_DEFENSE, POS_FACEUP_DEFENSE, POS_FACEUP_ATTACK, POS_FACEUP_ATTACK)
				end
			end
		end
	end
end

function cm.cfilter(c, tp, rp)
	return c:IsPreviousControler(tp)
		and rp == 1 - tp and c:IsPreviousLocation(LOCATION_MZONE)
end

function cm.descon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(cm.cfilter, 1, nil, tp, rp) and not eg:IsContains(e:GetHandler())
end

function cm.filter6(c, e, tp, id, g)
	return c:IsCanBeSpecialSummoned(e, 0, tp, true, false) and #g:Filter(cm.filter4, nil, c) ~= 0
end

function cm.filter5(c, e, tp)
	return c:IsType(TYPE_EQUIP)
end

function cm.filter4(c, c2)
	return c2:CheckEquipTarget(c) and not c:IsCode(m)
end

function cm.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then return c:IsLocation(QY_cw) end
	Duel.SendtoGrave(c, REASON_EFFECT + REASON_RETURN)
end

function cm.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	local g2 = Duel.GetMatchingGroup(cm.filter5, tp, LOCATION_GRAVE + QY_cw, 0, nil, e, tp)
	local g1 = Duel.GetMatchingGroup(cm.filter6, tp, LOCATION_GRAVE + QY_cw, 0, nil, e, tp, m, g2)
	-- local g3 = g2:Filter(aux.TRUE, nil)
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and #g1 > 0 end
	local c = e:GetHandler()
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, 0, 0)
end

function cm.desop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local g2 = Duel.GetMatchingGroup(cm.filter5, tp, LOCATION_GRAVE + QY_cw, 0, nil, e, tp)
	local g1 = Duel.SelectMatchingCard(tp, cm.filter6, tp, LOCATION_GRAVE + QY_cw, 0, 1, 1, nil, e, tp, m, g2):GetFirst()
	Duel.SpecialSummon(g1, 0, tp, tp, false, false, POS_FACEUP)
	g2 = g2:Filter(cm.filter4, nil, g1)
	Duel.Equip(tp, g2, g1, true)
end
