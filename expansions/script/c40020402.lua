--瞬耀-Ξ高达[光束护罩]
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
	
	aux.AddXyzProcedure(c, nil, 5, 3)
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
	e1:SetCategory(CATEGORY_POSITION + CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0, 1) 
	e2:SetCondition(s.actcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)	
end
function s.ovfilter(c, tp, xyzc)
	return s.XiGundam(c) and c:IsFaceup() and c:GetCounter(0x1f1e) >= 2
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
function s.atkcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function s.atktg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(aux.TRUE, tp, 0, LOCATION_MZONE, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_POSITION, nil, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_TOGRAVE, nil, 1, 0, 0)
end

function s.atkop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local g = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_MZONE, nil)
	if g:GetCount() > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_OPPO)
		local tc = g:Select(tp, 1, 1, nil):GetFirst()
		Duel.HintSelection(tc)

		if tc:IsCanTurnSet() then
			Duel.ChangePosition(tc, POS_FACEDOWN_DEFENSE)
		else

			if c:CheckRemoveOverlayCard(tp, 1, REASON_EFFECT) 
				and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then 
				c:RemoveOverlayCard(tp, 1, 1, REASON_EFFECT)
				Duel.SendtoGrave(tc, REASON_EFFECT)
			end
		end
	end

	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChainAttack()
	end
end

function s.actcon(e)
	local c = e:GetHandler()
	local tp = c:GetControler()
	local ph = Duel.GetCurrentPhase()
	return c:GetCounter(0x1f1e) >= 3 
	   and Duel.GetTurnPlayer() == tp 
	   and (ph >= PHASE_BATTLE_START and ph <= PHASE_BATTLE)
end
