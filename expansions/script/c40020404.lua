--瞬耀-Ξ高达[浮游导弹]
local s,id=GetID()
s.named_with_FlashRadiance=1
function s.FlashRadiance(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_FlashRadiance
end
s.named_with_XiGundam=1
function s.XiGundam(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_XiGundam
end

function s.initial_effect(c)
	aux.AddCodeList(c,40020396)

	c:EnableCounterPermit(0x1f1e)
	
	aux.AddXyzProcedure(c, nil, 5, 2)
	c:EnableReviveLimit()

	local e0 = Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id, 0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1, id)
	e0:SetCondition(s.xyzcon_alt)
	e0:SetTarget(s.xyztg_alt)
	e0:SetOperation(s.xyzop_alt)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 1))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE)
	e1:SetCondition(s.e1con)
	e1:SetCost(s.e1cost)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 2))
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_REMOVE_COUNTER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.e2con)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)	
end
function s.ovfilter(c, tp, xyzc)
	return s.XiGundam(c) and c:IsFaceup() and c:GetCounter(0x1f1e) >= 3
		and c:IsCanBeXyzMaterial(xyzc)
end

function s.xyzcon_alt(e, c)
	if c==nil then return true end
	local tp = c:GetControler()
	return Duel.GetLocationCountFromEx(tp, tp, nil, c) > 0
		and Duel.IsExistingMatchingCard(s.ovfilter, tp, LOCATION_MZONE, 0, 1, nil, tp, c)
end

function s.xyztg_alt(e, tp, eg, ep, ev, re, r, rp, chk, c)
	if chk == 0 then return true end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
	local g = Duel.SelectMatchingCard(tp, s.ovfilter, tp, LOCATION_MZONE, 0, 1, 1, nil, tp, c)
	if g:GetCount() > 0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end

function s.xyzop_alt(e, tp, eg, ep, ev, re, r, rp, c)
	local g = e:GetLabelObject()
	if not g then return end
	local tc = g:GetFirst()
	if tc then
		local ct = tc:GetCounter(0x1f1e) 
		local mg = tc:GetOverlayGroup()
		if mg:GetCount() > 0 then
			Duel.Overlay(c, mg)
		end
		c:SetMaterial(g)
		Duel.Overlay(c, g)
		
		if ct > 0 then
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_SPSUMMON_SUCCESS)
			e1:SetOperation(function(e, tp, eg)
				if eg:IsContains(c) then
					c:AddCounter(0x1f1e, ct)
					e:Reset() 
				end
			end)
			e1:SetReset(RESET_PHASE + PHASE_END)
			Duel.RegisterEffect(e1, tp)
		end
	end
end
function s.e1con(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function s.e1cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsCanRemoveCounter(tp, 0x1f1e, 2, REASON_COST) end
	e:GetHandler():RemoveCounter(tp, 0x1f1e, 2, REASON_COST)
end

function s.e1tg(e, tp, eg, ep, ev, re, r, rp, chk)
	local f = function(c) return c:IsFaceup() and c:IsCanTurnSet() end
	if chk == 0 then return Duel.IsExistingMatchingCard(f, tp, 0, LOCATION_ONFIELD, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_POSITION, nil, 1, 0, 0)
end

function s.e1op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local f = function(c) return c:IsFaceup() and c:IsCanTurnSet() end
	local g = Duel.GetMatchingGroup(f, tp, 0, LOCATION_ONFIELD, nil)
	
	if g:GetCount() > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_POSCHANGE)
		local tc = g:Select(tp, 1, 1, nil):GetFirst()
		Duel.HintSelection(tc)

		local pos = POS_FACEDOWN
		if tc:IsType(TYPE_MONSTER) then
			pos = POS_FACEDOWN_DEFENSE
		end
		
		Duel.ChangePosition(tc, pos)
		
		local ph = Duel.GetCurrentPhase()
		if Duel.GetTurnPlayer() == tp and (ph >= PHASE_BATTLE_START and ph <= PHASE_BATTLE) then
			if c:IsRelateToEffect(e) and c:CheckRemoveOverlayCard(tp, 1, REASON_EFFECT) 
			   and Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then
			   
			   Duel.BreakEffect()
			   c:RemoveOverlayCard(tp, 1, 1, REASON_EFFECT)
			   Duel.ChainAttack()
			end
		end
	end
end

function s.e2con(e, tp, eg, ep, ev, re, r, rp)

	return e:GetHandler():GetCounter(0x1f1e) >= 8
end

function s.e2tg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end 
	Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, 1-tp, 1)
end

function s.e2op(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetFieldGroup(tp, 0, LOCATION_HAND)
	if g:GetCount() > 0 then
		local sg = g:RandomSelect(tp, 1)
		Duel.SendtoGrave(sg, REASON_EFFECT + REASON_DISCARD)
	end
end
