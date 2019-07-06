--Spirit Spirit Fairy Fairy
--AlphaKretin
--For Nemoma
local s = c33700427
local id = 33700427
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c, nil, 2)
	c:EnableReviveLimit()
	--change control
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.ctcon)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	local e2 = e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--atk in def
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
	e3:SetTarget(s.atktg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
	e4:SetTarget(s.noatktg)
	c:RegisterEffect(e4)
	--reverse stat change
	local e5 = Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_REVERSE_UPDATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
	e5:SetTarget(s.atktg)
	c:RegisterEffect(e5)
end

function s.ctfilter(c, ec, tp)
	if c:IsLocation(LOCATION_MZONE) then
		return ec:GetLinkedGroup():IsContains(c)
	else
		return (ec:GetLinkedZone(c:GetPreviousControler()) & (1 << c:GetPreviousSequence())) ~= 0
	end
end

function s.ctcon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(s.ctfilter, 1, nil, e:GetHandler(), tp)
end

function s.cttg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return true
	end
	local g = eg:Filter(s.ctfilter, nil, e:GetHandler(), tp)
	local ct = g and #g or 0
	Duel.SetOperationInfo(0, CATEGORY_CONTROL, g, ct, 0, 0)
end

function s.ctop(e, tp, eg, ep, ev, re, r, rp)
	local g = eg:Filter(s.ctfilter, nil, e:GetHandler(), tp)
	if #g < 1 then
		return
	end
	local p = tp
	local g1 = g:Filter(Card.IsControler, nil, tp)
	local g2 = g:Filter(Card.IsControler, nil, 1 - tp)
	if #g2 > #g1 then
		p = 1 - tp
		g1, g2 = g2, g1
	end
	local diff = #g1 - #g2
	if diff > 0 then
		local ct = math.min(diff, Duel.GetLocationCount(1 - p, LOCATION_MZONE))
		local tg
		if ct > #g1 then
			tg = g1
		else
			tg = g1:Select(p, ct, ct, nil)
		end
		Duel.GetControl(tg, 1 - p)
		g1:Sub(tg)
	end
	if #g2 > 0 then
		local tg2
		if #g2 == #g1 then
			tg2 = g1
		else
			tg2 = g1:Select(p, #g2, #g2, nil)
		end
		Duel.SwapControl(tg2, g2)
		g1:Sub(tg2)
	end
	if #g1 > 0 then
		Duel.SendtoGrave(g1, REASON_RULE)
	end
end

function s.atktg(e, c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end

function s.noatktg(e, c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsPosition(POS_FACEUP_ATTACK)
end
