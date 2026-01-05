--瞬耀-梅萨F型裸装［指挥官机］
local s,id=GetID()
s.named_with_FlashRadiance=1
function s.FlashRadiance(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_FlashRadiance
end
function s.XiGundam(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_XiGundam
end
function s.initial_effect(c)
	aux.AddCodeList(c,40020396)
	
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_DECKDES + CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id)
	e2:SetCost(s.e2cost)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
end

function s.spcon(e, c)
	if c == nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(), LOCATION_MZONE, 0) == 0
		and Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE) > 0
end

function s.e2cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(), REASON_COST)
end

function s.spfilter1(c, e, tp)
	return s.FlashRadiance(c) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.e2tg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.GetMZoneCount(tp, e:GetHandler()) > 0
		and Duel.IsExistingMatchingCard(s.spfilter1, tp, LOCATION_HAND + LOCATION_GRAVE, 0, 1, nil, e, tp) end
	
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND + LOCATION_GRAVE)
end

function s.spfilter2(c, e, tp)
	return c:IsCode(40020396) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.e2op(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, s.spfilter1, tp, LOCATION_HAND + LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
	
	if g:GetCount() > 0 and Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP) > 0 then
		local check_func = function(c) return c:IsFaceup() and c:IsCode(40020396) end
		local b_cond1 = not Duel.IsExistingMatchingCard(check_func, tp, LOCATION_MZONE, 0, 1, nil)
		local b_cond2 = Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		local b_cond3 = Duel.IsExistingMatchingCard(s.spfilter2, tp, LOCATION_DECK, 0, 1, nil, e, tp)
		
		if b_cond1 and b_cond2 and b_cond3 and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
			local sg = Duel.SelectMatchingCard(tp, s.spfilter2, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
			local tc = sg:GetFirst()
			if tc then
				if Duel.SpecialSummonStep(tc, 0, tp, tp, false, false, POS_FACEUP) then
					tc:AddCounter(0x1f1e, 1)
					Duel.RegisterFlagEffect(tp, 40020396, 0, 0, 1)
				end
				Duel.SpecialSummonComplete()
			end
		end
	end
end
