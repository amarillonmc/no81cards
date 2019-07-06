--Slightly Tilted
--AlphaKretin
--For Nemoma
local s = c33700421
local id = 33700421
function s.initial_effect(c)
	--Activate
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Grant effect
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	local e3 = e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.cfilter(c, tp)
	return c:GetSummonPlayer() == tp
end
function s.regcon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(s.cfilter, 1, nil, 1 - tp)
end
function s.regop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	for tc in aux.Next(eg:Filter(s.cfilter, nil, 1 - tp)) do
		s.registerEffects(tc, c)
	end
end
function s.registerEffects(c, rc)
	local e1 = Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-500)
	e1:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TOFIELD)
	c:RegisterEffect(e1)
	local e2 = Effect.CreateEffect(rc)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(s.inhcon1)
	e2:SetOperation(s.inhop)
	e2:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_LEAVE - RESET_TOGRAVE - RESET_TOFIELD) --take out some resets to allow recursion
	c:RegisterEffect(e2)
	local e3 = e2:Clone()
	e3:SetCode(EVENT_RELEASE)
	e3:SetCondition(s.inhcon2)
	c:RegisterEffect(e3)
	c:RegisterFlagEffect(
		0,
		RESET_EVENT + RESETS_STANDARD - RESET_TOFIELD,
		EFFECT_FLAG_CLIENT_HINT,
		1,
		0,
		aux.Stringid(id, 0)
	)
end
function s.inhcon1(e, tp, eg, ep, ev, re, r, rp)
	local rc = e:GetHandler():GetReasonCard()
	return rc and rc:GetSummonLocation() == LOCATION_EXTRA
end
function s.inhcon2(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsReason(REASON_SUMMON)
end
function s.inhop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local rc = c:GetReasonCard()
	s.registerEffects(rc, c)
	--magic hack so it does reset in grave after recursion
	local a, b = e:GetReset()
	if a ~= 0 or b ~= 0 then
		e:Reset()
	end
end
