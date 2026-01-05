--瞬耀-Ξ高达
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


	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	local e2 = e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)


	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 1))
	e3:SetCategory(CATEGORY_COUNTER + CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0, TIMING_BATTLE_START + TIMING_BATTLE_END)
	e3:SetCondition(s.xyzcon)
	e3:SetTarget(s.xyztg)
	e3:SetOperation(s.xyzop)
	c:RegisterEffect(e3)

	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id, 2))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(s.damcon)
	e4:SetTarget(s.damtg)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)

	local e5 = Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e5:SetCondition(s.matcon)
	e5:SetOperation(s.matop)
	c:RegisterEffect(e5)
end

function s.cttg(e, tp, eg, ep, ev, re, r, rp, chk)
	local val = Duel.GetFlagEffect(tp, 40020396)
	if chk == 0 then return val > 0 and e:GetHandler():IsCanAddCounter(0x1f1e, val) end
	Duel.SetOperationInfo(0, CATEGORY_COUNTER, nil, val, 0, 0)
end

function s.ctop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local val = Duel.GetFlagEffect(tp, 40020396)
	
	if c:IsRelateToEffect(e) and val > 0 then
		if c:AddCounter(0x1f1e, val) then
			for i = 1, val do
				Duel.RegisterFlagEffect(tp, 40020396, 0, 0, 1)
			end
		end
	end
end

function s.xyzcon(e, tp, eg, ep, ev, re, r, rp)
	local ph = Duel.GetCurrentPhase()
	return ph == PHASE_MAIN1 or ph == PHASE_MAIN2 or (ph >= PHASE_BATTLE_START and ph <= PHASE_BATTLE_END)
end

function s.xyztg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsCanAddCounter(0x1f1e, 2) end
	Duel.SetOperationInfo(0, CATEGORY_COUNTER, nil, 2, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 0, tp, LOCATION_EXTRA)
end

function s.xyzop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local val = 2 

	if c:IsRelateToEffect(e) and c:AddCounter(0x1f1e, val) then

		for i = 1, val do
			Duel.RegisterFlagEffect(tp, 40020396, 0, 0, 1)
		end

		local g = Duel.GetMatchingGroup(Card.IsXyzSummonable, tp, LOCATION_EXTRA, 0, nil, nil)
		local xg = g:Filter(s.XiGundam, nil)
		
		if xg:GetCount() > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
			local sc = xg:Select(tp, 1, 1, nil):GetFirst()
			
			local ct = c:GetCounter(0x1f1e)
			
			Duel.XyzSummon(tp, sc, nil)
			
			if sc:IsLocation(LOCATION_MZONE) and sc:IsFaceup() and ct > 0 then
				sc:AddCounter(0x1f1e, ct)
			end
		end
	end
end

function s.damcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local eqg = c:GetEquipGroup()
	return eqg and eqg:IsExists(Card.IsType, 1, nil, TYPE_UNION)
end

function s.damtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, 1-tp, 2000)
end

function s.damop(e, tp, eg, ep, ev, re, r, rp)
	local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
	Duel.Damage(p, d, REASON_EFFECT)
end

function s.matcon(e, tp, eg, ep, ev, re, r, rp)
	return r == REASON_XYZ
end

function s.matop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local rc = c:GetReasonCard()
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetDescription(aux.Stringid(id, 2))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetCondition(s.damcon_xyz)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.damop)
	e1:SetReset(RESET_EVENT + RESETS_STANDARD)
	rc:RegisterEffect(e1, true)
	
	if not rc:IsType(TYPE_EFFECT) then
		local e2 = Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT + RESETS_STANDARD)
		rc:RegisterEffect(e2, true)
	end
end

function s.damcon_xyz(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler() 
	local mat = e:GetOwner()
	
	local og = c:GetOverlayGroup()
	if not og or not og:IsContains(mat) then return false end

	if not s.XiGundam(c) then return false end
	
	local eqg = c:GetEquipGroup()
	return eqg and eqg:IsExists(Card.IsType, 1, nil, TYPE_UNION)
end
