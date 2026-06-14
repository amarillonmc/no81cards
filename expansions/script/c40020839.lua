--兵虫阳神 圣甲神隼Ω
local s, id = GetID()

s.named_with_WeaponInsect = 1
function s.WeaponInsect(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_WeaponInsect
end

function s.Grandwalker(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end

s.RAHERAKHTY_CODE = 40020713

function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,9,2)
			aux.AddCodeList(c,40020713)
if not s.global_check then
	s.global_check = true
	local ge1 = Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_LEAVE_FIELD_P)
	ge1:SetOperation(s.global_ovop)
	Duel.RegisterEffect(ge1, 0)
end
	
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 1))
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.rapencon)
	e1:SetTarget(s.rapentg)
	e1:SetOperation(s.rapenop)
	c:RegisterEffect(e1)
	
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 2))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id + 1)
	e2:SetCondition(s.discon)
	e2:SetCost(s.discost)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end

function s.omega_filter(c, e, tp)
	return c:IsCode(id) and Duel.GetLocationCountFromEx(tp, tp, nil, c) > 0 
		and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_XYZ, tp, false, false)
end

function s.global_ovop(e, tp, eg, ep, ev, re, r, rp)
	for p = 0, 1 do
		if Duel.GetFlagEffect(p, id + 100) == 0 then
			local tg = eg:Filter(function(c) 
				return c:IsControler(p) and c:IsLocation(LOCATION_PZONE) and s.Grandwalker(c)
			end, nil)
			
			if #tg > 0 then
				local omega_g = Duel.GetMatchingGroup(function(c) return c:IsCode(id) end, p, LOCATION_EXTRA, 0, nil)
				if #omega_g > 0 then
					local sc = omega_g:GetFirst()
					if sc:IsCanBeSpecialSummoned(e, SUMMON_TYPE_XYZ, p, false, false) 
					   and Duel.GetLocationCountFromEx(p, p, nil, sc) > 0 then
						if Duel.SelectYesNo(p, aux.Stringid(id, 0)) then
							Duel.RegisterFlagEffect(p, id + 100, RESET_PHASE + PHASE_END, 0, 1)
							Duel.Hint(HINT_CARD, 0, id)
							local tc = tg:GetFirst()
							if #tg > 1 then
								Duel.Hint(HINT_SELECTMSG, p, HINTMSG_XMATERIAL)
								tc = tg:Select(p, 1, 1, nil):GetFirst()
							end
							local mg = tc:GetOverlayGroup()
							if #mg ~= 0 then Duel.Overlay(sc, mg) end
							sc:SetMaterial(Group.FromCards(tc))
							Duel.Overlay(sc, Group.FromCards(tc))
							tc:SetStatus(STATUS_LEAVE_CONFIRMED, true)
							tc:SetStatus(STATUS_BATTLE_DESTROYED, false)
							if Duel.SpecialSummon(sc, SUMMON_TYPE_XYZ, p, p, false, false, POS_FACEUP) ~= 0 then
								sc:CompleteProcedure()
							end
							local e1 = Effect.CreateEffect(e:GetHandler())
							e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
							e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
							e1:SetCode(EVENT_ADJUST)
							local recover_g = Group.FromCards(tc)
							recover_g:KeepAlive()
							e1:SetOperation(function()
								e1:Reset()
								if sc and sc:IsLocation(LOCATION_MZONE) and tc then
									if not sc:GetOverlayGroup():IsContains(tc) then
										Duel.Overlay(sc, recover_g)
									end
								end
								recover_g:DeleteGroup()
							end)
							Duel.RegisterEffect(e1, p)
						end
					end
				end
			end
		end
	end
end
function s.rapencon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function s.rafilter(c)
	return c:IsCode(s.RAHERAKHTY_CODE) and not c:IsForbidden()
end

function s.rapentg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then

		local b1 = Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)
		return b1 and Duel.IsExistingMatchingCard(s.rafilter, tp, LOCATION_HAND + LOCATION_DECK + LOCATION_EXTRA, 0, 1, nil)
	end
end

function s.rapenop(e, tp, eg, ep, ev, re, r, rp)
	if not (Duel.CheckLocation(tp, LOCATION_PZONE, 0) or Duel.CheckLocation(tp, LOCATION_PZONE, 1)) then return end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
	local g = Duel.SelectMatchingCard(tp, s.rafilter, tp, LOCATION_HAND + LOCATION_DECK + LOCATION_EXTRA, 0, 1, 1, nil)
	if #g > 0 then
		Duel.MoveToField(g:GetFirst(), tp, tp, LOCATION_PZONE, POS_FACEUP, true)
	end
end

function s.discon(e, tp, eg, ep, ev, re, r, rp)
	local b1 = Duel.IsExistingMatchingCard(function(c) return c:IsCode(s.RAHERAKHTY_CODE) end, tp, LOCATION_PZONE, 0, 1, nil)
	return b1 and ep == 1 - tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end

function s.discost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end

function s.distg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_DISABLE, eg, 1, 0, 0)
end

function s.disop(e, tp, eg, ep, ev, re, r, rp)
	Duel.NegateEffect(ev)
end
