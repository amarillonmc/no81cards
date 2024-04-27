--炼击帝-大洋神女
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			pcall(require_list[str])
			return require_list[str]
		end
		return require_list[str]
	end
end
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local s,id = Scl.SetID(130006036, "LordOfChain")
function s.initial_effect(c)
	local e1 = Scl.CreateSingleBuffEffect(c, "Reveal", 1, "Hand")
	local e2 = Scl.CreateQuickMandatoryEffect(c, "ActivateEffect", nil, nil, nil, nil, "Hand,MonsterZone", nil, nil, s.mixtg, s.mixop)
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
	local b1 = (c:IsOnField() or c:IsPublic()) and c:GetFlagEffect(id) < s.get_count(LOCATION_DECK)
	local b2 = c:IsLocation(LOCATION_HAND) and c:GetFlagEffect(id + 100) == 0  and ev > 1
	if chk == 0 then
		local res=(b1 or b2) and c:GetFlagEffect(id + 200)==0
		if res then c:RegisterFlagEffect(id + 200, RESET_CHAIN, 0, 1) end
		return res
	end
	c:ResetFlagEffect(id + 200)
	b2 =  c:IsLocation(LOCATION_HAND) and c:GetFlagEffect(id + 100) == 0  and cct > 2
	--local op = b1 and 1 or 2
	--if b1 and b2 then 
		--op = Scl.SelectOption(tp, true, "Damage", true, {id, 0})
	--end
	local op = b2 and 2 or 1
	if op == 1 then
		e:SetProperty(0)
		e:SetCategory(CATEGORY_DEFCHANGE)
		c:RegisterFlagEffect(id, RESET_CHAIN, 0, 1)
	else
		e:SetProperty(0)
		c:RegisterFlagEffect(id + 100, RESET_CHAIN, 0, 1)
		local ctgy = 0
		if cct >= 3 then
			ctgy = ctgy + CATEGORY_SPECIAL_SUMMON + CATEGORY_REMOVE 
		end
		if cct >= 5 then
			ctgy = ctgy + CATEGORY_TOHAND 
		end
		if cct >= 11 then
			ctgy = ctgy + CATEGORY_DISABLE 
		end
		e:SetCategory(ctgy)
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(id,1))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
		c:RegisterFlagEffect(0, RESET_CHAIN, EFFECT_FLAG_CLIENT_HINT, 1,0,aux.Stringid(id,1))
	end
	s.chain_id_scl[cct] = op
end
function s.mixop(e,tp,eg,ep,ev,re,r,rp)
	local cct = Duel.GetCurrentChain()
	local op = s.chain_id_scl[cct]
	if op == 1 then
		local g = Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		for tc in aux.Next(g) do
			Scl.AddSingleBuff({e:GetHandler(),tc},"+DEF", -300)
		end
	else
		local c = e:GetHandler()
		if cct >= 3 then 
			if c:IsRelateToChain(0) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) > 0 then
				local dg = Duel.GetDecktopGroup(1-tp, 3)
				if #dg > 0 then
					Duel.Remove(dg,POS_FACEDOWN,REASON_EFFECT)
				end
			end
		end
		if cct >= 5 then
			local f = function(tc)
				return tc:IsFaceup() and tc:IsDefense(0)
			end
			local g = Duel.GetMatchingGroup(f,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
			if #g > 0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
			end
		end
		if cct >= 11 then
			local e1 = Scl.CreateFieldTriggerContinousEffect({c, tp}, "BeforeEffectResolving", nil, nil, nil, nil, s.discon, s.disop, RESET_EP_SCL)
		end
	end
end
function s.discon(e,tp,eg,ep,ev,re)
	return ev >= 2 and ep ~= tp
end
function s.disop(e,tp,eg,ep,ev,re)
	Scl.HintCard(id)
	Duel.NegateEffect(ev)
end