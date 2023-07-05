--炼击帝-死河
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local s,id = Scl.SetID(130006037, "LordOfChain")
function s.initial_effect(c)
	local e1 = Scl.CreateSingleBuffEffect(c, "Reveal", 1, "Hand")
	local e2 = Scl.CreateQuickMandatoryEffect(c, "ActivateEffect", nil, nil, nil, nil, "Hand,MonsterZone", nil, nil, s.mixtg,s.mixop)
	if not s.chain_id_scl then
		s.chain_id_scl = {}
	end
end
function s.get_count(zone)
	local ct = Duel.GetFieldGroupCount(0, zone, 0) - Duel.GetFieldGroupCount(0, 0, zone)
	return math.abs(ct)
end
function s.mixtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	local cct = Duel.GetCurrentChain()
	local b1 = (c:IsOnField() or c:IsPublic()) and c:GetFlagEffect(id) < s.get_count(LOCATION_GRAVE)
	local b2 = c:IsLocation(LOCATION_HAND) and c:GetFlagEffect(id + 100) == 0 and cct > 1
	if chk == 0 then return b1 or b2 end
	--local op = b1 and 1 or 2
	--if b1 and b2 then 
		--op = Scl.SelectOption(tp, true, "Damage", true, {id, 0})
	--end
	local op = b2 and 2 or 1
	if op == 1 then
		e:SetProperty(0)
		e:SetCategory(CATEGORY_ATKCHANGE)
		c:RegisterFlagEffect(id, RESET_CHAIN, 0, 1)
	else
		c:RegisterFlagEffect(id + 100, RESET_CHAIN, 0, 1)
		local ctgy = 0
		if cct >= 3 then
			ctgy = ctgy + CATEGORY_SPECIAL_SUMMON + CATEGORY_REMOVE + CATEGORY_GRAVE_ACTION 
		end
		if cct >= 5 then

		end
		if cct >= 13 then
			ctgy = ctgy + CATEGORY_DISABLE 
		end
		e:SetCategory(ctgy)
	end
	s.chain_id_scl[cct] = op
end
function s.mixop(e,tp,eg,ep,ev,re,r,rp)
	local cct = Duel.GetCurrentChain()
	local op = s.chain_id_scl[cct]
	if op == 1 then
		local g = Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		for tc in aux.Next(g) do
			Scl.AddSingleBuff({e:GetHandler(),tc},"+ATK", 400)
		end
	else
		local c = e:GetHandler()
		if cct >= 3 then 
			if c:IsRelateToChain(0) and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) > 0 then
				Scl.SelectAndOperateCards("Banish", tp, Card.IsAbleToRemove, tp, "GY", "GY", 1, 1, nil)()
			end
		end
		if cct >= 5 then
			Scl.SelectAndOperateCards("SpecialSummon", tp, aux.NecroValleyFilter(Scl.IsCanBeSpecialSummonedNormaly2), tp, "GY", "GY", 1, 1, nil, e, tp)()
		end
		if cct >= 13 then
			local f = function(te,tc)
				return not Scl.IsSeries(tc, "LordOfChain")
			end
			local e1 = Scl.CreateFieldBuffEffect({c, tp}, "NegateEffect", 1, f, {"OnField", "OnField"}, nil, nil, RESET_EP_SCL)
			local e2 = Scl.CreateFieldBuffEffect({c, tp}, "=Name", 32274490, f, {"OnField", "OnField"}, nil, nil, RESET_EP_SCL)
		end
	end
end