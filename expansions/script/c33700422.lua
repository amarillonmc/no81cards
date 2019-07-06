--Succession of Illusion and Dreams
--AlphaKretin
--For Nemoma
local s = c33700422
local id = 33700422
function s.initial_effect(c)
	--Activate
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.accon)
	e1:SetOperation(s.acop)
	c:RegisterEffect(e1)
	--Link Spell
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
	e2:SetValue(LINK_MARKER_TOP)
	c:RegisterEffect(e2)
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
	--Gemini status
	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE, 0)
	e4:SetTarget(s.gemtg)
	e4:SetCode(EFFECT_DUAL_STATUS)
	c:RegisterEffect(e4)
end
function s.cfilter(c, oc, tp)
	if not (c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:GetDefense() > c:GetAttack()) then
		return false
	end
	local g = c:GetColumnGroup()
	return g:FilterCount(
		function(c, tp)
			return c:IsControler(tp) and c:IsLocation(LOCATION_SZONE)
		end,
		nil,
		tp
	) == 0 or g:IsContains(oc)
end
function s.accon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.IsExistingMatchingCard(s.cfilter, tp, LOCATION_MZONE, 0, 1, nil, e:GetHandler(), tp)
end
function s.effilter(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_EFFECT) and c:GetDefense() > c:GetAttack()
end
function s.acop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.SelectMatchingCard(tp, s.cfilter, tp, LOCATION_MZONE, 0, 1, 1, nil, e:GetHandler(), tp):GetFirst()
	Duel.MoveSequence(e:GetHandler(), tc:GetSequence())
	if
		Duel.IsExistingMatchingCard(s.effilter, tp, LOCATION_DECK, 0, 1, nil) and
			Duel.SelectYesNo(tp, aux.Stringid(0, id))
	 then
		local g = Duel.SelectMatchingCard(tp, s.effilter, tp, LOCATION_DECK, 0, 1, 1, nil)
		if Duel.SendtoGrave(g, REASON_EFFECT) > 0 then
			local cid = tc:CopyEffect(g:GetFirst():GetOriginalCodeRule(), RESET_EVENT + RESETS_STANDARD, 1)
		end
	end
end
function s.gemtg(e, c)
	return c:IsCode(33700423) and e:GetLinkedGroup():IsContains(c)
end
