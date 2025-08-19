--21点
local cm, m = GetID()
local MULTI, ORDER, PL, MODE, DECK, PRESTAY
local NORMAL	= 16 * m + 0
local SKILL  = 16 * m + 1
local NIGHTMARE = 16 * m + 2
local HIT	  = 16 * m + 3
local STAY	= 16 * m + 4
local USESKILL  = 16 * m + 5
local WIN	  = 16 * m + 6
local DRAW	= 16 * m + 7
local LOSE	= 16 * m + 8
local SKILLS = { "Up", "Two", "Three", "Four", "Five", "Six", "Seven", "Remove", "Return", "Exchange",
	"Trump", "Shield", "Destroy", "Perfect", "Go_17", "Go_24", "Go_27", "Love", "Assault", "Happiness",
	"Desire", "Mind", "Conjure", "Curse", "Black", "Twenty", "Oblivion", "Dead", "Desperation" }

------------------------------------------------------------ get
function cm.GetNumber(c)
	if c:IsCode(m) then return 0 end
	return c:GetCode() - m
end

function cm.GetSum(p, nohide)
	local g = Duel.GetFieldGroup(p, LOCATION_MZONE, 0)
	if nohide then g = g:Filter(Card.IsFaceup, nil) end
	return g:GetSum(cm.GetNumber)
end

function cm.GetNextZone(zone)
	zone = 0x1F ~ zone
	local nzone = 1
	while zone > nzone do
		if (zone & nzone) > 0 then
			break
		end
		nzone = nzone << 1
	end
	return nzone
end

function cm.GetGuessDeck(p)
	local guess = { cm.GetNumber(cm.GetFaceDown(p, 0, LOCATION_MZONE):GetFirst()) }
	for _, n in ipairs(DECK) do
		table.insert(guess, n)
	end
	return guess
end

function cm.GetGuessMax(p)
	local deck = cm.GetGuessDeck(p)
	local max = deck[1]
	for _, v in ipairs(deck) do
		if v > max then
			max = v
		end
	end
	return max
end

function cm.GetGuessBest(p, nohide)
	local deck = cm.GetGuessDeck(p)
	local hope = cm.GetGoal() - cm.GetSum(p, nohide)
	local above, ai = 12, 0
	local below, bi = 0, 0

	for i, v in ipairs(deck) do
		if hope == v then
			return v, i
		elseif (hope > v and v > below) then
			below, bi = v, i
		elseif (hope < v and v < above) then
			above, ai = v, i
		end
	end

	if bi > 0 then return below, bi end
	return above, ai
end

function cm.GetBest(p)
	local hope = cm.GetGoal() - cm.GetSum(p, false)
	local above, ai = 12, 0
	local below, bi = 0, 0

	for i, v in ipairs(DECK) do
		if hope == v then
			return v, i
		elseif (hope > v and v > below) then
			below, bi = v, i
		elseif (hope < v and v < above) then
			above, ai = v, i
		end
	end

	if bi > 0 then return below, bi end
	return above, ai
end

function cm.GetFaceUp(p, loc1, loc2)
	local g = Duel.GetMatchingGroup(Card.IsFaceup, p, loc1, loc2, nil)
	return g:Filter(aux.NOT(Card.IsCode), nil, m)
end

function cm.GetFaceDown(p, loc1, loc2)
	local g = Duel.GetMatchingGroup(Card.IsFacedown, p, loc1, loc2, nil)
	return g:Filter(aux.NOT(Card.IsCode), nil, m)
end

function cm.GetGoal()
	local g = cm.GetFaceUp(0, LOCATION_SZONE, LOCATION_SZONE)
	local c = g:Filter(Card.IsCode, nil, m + 26, m + 27, m + 28):GetFirst()
	return c and tonumber(SKILLS[cm.GetNumber(c) - 11]:sub(4)) or 21
end

function cm.GetLast(p)
	local seq, c = -1
	for gc in aux.Next(cm.GetFaceUp(p, LOCATION_MZONE, 0)) do
		local gseq = gc:GetSequence()
		if gseq > seq then
			seq, c = gseq, gc
		end
	end
	return c
end

function cm.GetWiner(sum0, sum1, goal)
	if sum0 == sum1 then return "Draw", 0 end

	local player = {}
	player[sum0] = 0
	player[sum1] = 1

	goal = goal or cm.GetGoal()
	local bust0 = sum0 > goal
	local bust1 = sum1 > goal

	if bust0 and bust1 then
		local min = math.min(sum0, sum1)
		return player[min], min
	elseif bust0 then
		return 1, sum1
	elseif bust1 then
		return 0, sum0
	end
	local max = math.max(sum0, sum1)
	return player[max], max
end

function cm.GetPay(p, win_point)
	local pay = 1000
	for c in aux.Next(cm.GetFaceUp(p, LOCATION_SZONE, 0)) do
		local name = SKILLS[cm.GetNumber(c) - 11]
		if name == "Shield" then
			pay = pay - (MODE == NIGHTMARE and 2000 or 1000)
		elseif name == "Conjure" then
			pay = pay + 1000
		elseif name == "Desperation" then
			pay = pay + 100000
		end
	end
	for c in aux.Next(cm.GetFaceUp(p, 0, LOCATION_SZONE)) do
		local name = SKILLS[cm.GetNumber(c) - 11]
		if name == "Up" then
			pay = pay + (MODE == NIGHTMARE and 2000 or 1000)
		elseif name == "Assault" then
			pay = pay + 3000
		elseif name == "Desire" then
			pay = pay + (#Duel.GetFieldGroup(p, LOCATION_SZONE, 0) * 1000)
		elseif name == "Black" then
			pay = pay + 10000
		elseif name == "Twenty" then
			pay = pay + (win_point == 21 and 21000 or 0)
		elseif name == "Desperation" then
			pay = pay + 100000
		end
	end

	return pay
end

------------------------------------------------------------ check
function cm.HasN(n)
	for i, v in ipairs(DECK) do
		if v == n then
			return i
		end
	end
	return false
end

function cm.CanDraw(p)
	local g = cm.GetFaceUp(p, 0, LOCATION_SZONE)
	return not g:IsExists(Card.IsCode, 1, nil, m + 39, m + 40)
end

function cm.CanUse(c)
	local name = SKILLS[cm.GetNumber(c) - 11]
	if ({ Two = 2, Three = 3, Four = 4, Five = 5, Six = 6, Seven = 7, Perfect = 9 })[name] then
		return Duel.GetLocationCount(PL, LOCATION_MZONE, PLAYER_NONE, 0) > 0
	elseif name == "Remove" then
		return #cm.GetFaceUp(PL, 0, LOCATION_MZONE) > 0
	elseif name == "Return" then
		return #cm.GetFaceUp(PL, LOCATION_MZONE, 0) > 0
	elseif name == "Exchange" then
		return #cm.GetFaceUp(PL, LOCATION_MZONE, 0) > 0 and #cm.GetFaceUp(PL, 0, LOCATION_MZONE) > 0
	elseif name == "Destroy" then
		return #cm.GetFaceUp(PL, 0, LOCATION_SZONE) > 0
	elseif name == "Love" then
		return Duel.GetLocationCount(1 - PL, LOCATION_MZONE, PLAYER_NONE, 0) > 0
	elseif name == "Assault" then
		return cm.GetFaceUp(PL, LOCATION_SZONE, 0):IsExists(Card.IsCode, 1, nil, m + 23)
	elseif name == "Curse" or name == "Black" then
		return #cm.GetFaceDown(PL, LOCATION_SZONE, 0) > 1
	end
	return true
end

------------------------------------------------------------ do
function cm.SetCard(p, code, loc, pos)
	local ct, zone = Duel.GetLocationCount(p, loc, PLAYER_NONE, 0)
	if ct == 0 then return end
	local nzone = cm.GetNextZone(zone)
	local c = Duel.CreateToken(p, code)
	Duel.MoveToField(c, ORDER, p, loc, pos, true, nzone)
end

function cm.DrawTrump(p, ct)
	if not cm.CanDraw(p) then return end
	if MODE == NIGHTMARE and p ~= ORDER and math.random(1, 4 - cm.RiskLevel(p)) == 1 then
		ct = ct - cm.DrawNightmareTrump(p, ct)
	end
	for i = 1, ct do
		local code = m + 11 + math.random(1, 18)
		cm.SetCard(p, code, LOCATION_SZONE, POS_FACEDOWN_ATTACK)
	end
end

function cm.DrawMax(p)
	if not cm.CanDraw(p) then return end
	local ind, max = 0, 0
	for i, v in ipairs(DECK) do
		if v > max then
			ind, max = i, v
		end
	end
	table.remove(DECK, ind)
	cm.SetCard(p, m + max, LOCATION_MZONE, POS_FACEUP_ATTACK)
end

function cm.DrawHope(p)
	if not cm.CanDraw(p) then return end
	local best, ind = cm.GetBest(p)
	table.remove(DECK, ind)
	cm.SetCard(p, m + best, LOCATION_MZONE, POS_FACEUP_ATTACK)
end

function cm.Draw()
	if not cm.CanDraw(p) then return end
	if MODE ~= NORMAL and math.random(1, 4) == 1 then
		cm.DrawTrump(PL, 1)
	end
	local code = m + table.remove(DECK)
	cm.SetCard(PL, code, LOCATION_MZONE, POS_FACEUP_ATTACK)
end

function cm.Oblivion(p)
	local g = Duel.GetFieldGroup(0, LOCATION_MZONE, LOCATION_MZONE)
	Duel.SendtoHand(g, nil, REASON_RULE)

	g = cm.GetFaceUp(0, LOCATION_SZONE, LOCATION_SZONE)
	Duel.SendtoHand(g, nil, REASON_RULE)

	cm.NewRound()
end

function cm.Use(c)
	Duel.ChangePosition(c, POS_FACEUP_ATTACK)
	Duel.Hint(HINT_CARD, 1 - PL, c:GetCode())
	Duel.Hint(HINT_OPSELECTED, 1 - PL, aux.Stringid(c:GetCode(), 0))

	local g = cm.GetFaceUp(PL, 0, LOCATION_SZONE):Filter(Card.IsCode, nil, m + 33)
	if #g > 0 then
		for gc in aux.Next(g) do
			local ct = gc:GetFlagEffect(m)
			if ct == 2 then
				Duel.SendtoHand(gc, nil, REASON_RULE)
			else
				gc:RegisterFlagEffect(m, 0, 0, 1)
				gc:SetHint(CHINT_NUMBER, ct + 1)
			end
		end
	end

	local name = SKILLS[cm.GetNumber(c) - 11]
	local leave = not (name == "Up" or name == "Shield" or name == "Go_17" or name == "Go_24"
		or name == "Go_27" or name == "Assault" or name == "Desire" or name == "Mind" or name == "Conjure"
		or name == "Black" or name == "Twenty" or name == "Dead" or name == "Desperation")
	local get_n = { Two = 2, Three = 3, Four = 4, Five = 5, Six = 6, Seven = 7 }

	if leave then Duel.MoveSequence(c, 5) end

	if name == "Up" then
		if MODE == NIGHTMARE then
			cm.DrawTrump(PL, 1)
		end
	elseif get_n[name] then
		local n = get_n[name]
		local ind = cm.HasN(n)
		if ind and cm.CanDraw(p) then
			table.remove(DECK, ind)
			cm.SetCard(PL, m + n, LOCATION_MZONE, POS_FACEUP_ATTACK)
		end
	elseif name == "Remove" or name == "Return" then
		local rc = cm.GetLast(name == "Return" and PL or 1 - PL)
		if rc then
			table.insert(DECK, math.random(1, #DECK + 1), cm.GetNumber(rc))
			Duel.SendtoHand(rc, nil, REASON_RULE)
		end
	elseif name == "Exchange" then
		local sc = cm.GetLast(PL)
		local scode = cm.GetNumber(sc)
		local oc = cm.GetLast(1 - PL)
		local ocode = cm.GetNumber(oc)
		Duel.SendtoHand(Group.FromCards(sc, oc), nil, REASON_RULE)
		cm.SetCard(PL, m + ocode, LOCATION_MZONE, POS_FACEUP_ATTACK)
		cm.SetCard(1 - PL, m + scode, LOCATION_MZONE, POS_FACEUP_ATTACK)
	elseif name == "Trump" then
		g = cm.GetFaceDown(PL, LOCATION_SZONE, 0)
		if #g > 0 then Duel.SendtoHand(g:RandomSelect(ORDER, 1), nil, REASON_RULE) end
		cm.DrawTrump(PL, 2)
	elseif name == "Destroy" then
		g = cm.GetFaceUp(PL, 0, LOCATION_SZONE)
		if MODE ~= NIGHTMARE and #g > 0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			g = g:Select(PL, 1, 1, nil)
		end
		Duel.SendtoHand(g, nil, REASON_RULE)
	elseif name == "Perfect" then
		cm.DrawHope(PL)
		if MODE == NIGHTMARE then
			cm.DrawTrump(PL, 2)
		end
	elseif name == "Go_17" or name == "Go_24" or name == "Go_27" then
		g = cm.GetFaceUp(0, LOCATION_SZONE, LOCATION_SZONE)
		Duel.SendtoHand(g:Filter(Card.IsCode, c, m + 26, m + 27, m + 28), nil, REASON_RULE)
	elseif name == "Love" then
		cm.DrawHope(1 - PL)
	elseif name == "Assault" then
		g = cm.GetFaceUp(PL, LOCATION_SZONE, 0):Filter(Card.IsCode, nil, m + 23)
		Duel.SendtoHand(g:RandomSelect(ORDER, 1), nil, REASON_RULE)
	elseif name == "Happiness" then
		cm.DrawTrump(PL, 1)
		cm.DrawTrump(1 - PL, 1)
	elseif name == "Conjure" then
		cm.DrawTrump(PL, 3)
	elseif name == "Curse" then
		g = cm.GetFaceDown(PL, LOCATION_SZONE, 0)
		Duel.SendtoHand(g:RandomSelect(ORDER, 1), nil, REASON_RULE)
		cm.DrawMax(1 - PL)
	elseif name == "Black" then
		g = cm.GetFaceDown(PL, LOCATION_SZONE, 0)
		Duel.SendtoHand(g:RandomSelect(ORDER, #g // 2), nil, REASON_RULE)
		cm.DrawMax(PL)
	elseif name == "Oblivion" then
		cm.Oblivion(PL)
	end

	if leave then Duel.SendtoHand(c, nil, REASON_RULE) end
end

------------------------------------------------------------ bot
function cm.RiskLevel(p)
	local lp = (Duel.GetLP(p) - 1) % 10000
	if lp > 7000 then
		return 1
	elseif lp > 3000 then
		return 2
	end
	return 3
end

function cm.DrawNightmareTrump(p, ct)
	local g = Duel.GetFieldGroup(p, LOCATION_SZONE, 0)
	local lv = 5 - (Duel.GetLP(p) - 1) // 10000
	if lv == 1 then
		local hasshield = g:IsExists(Card.IsCode, 1, nil, m + 23)
		if cm.RiskLevel(p) == 3 then
			if hasshield then return 0 end
			cm.SetCard(p, m + 23, LOCATION_SZONE, POS_FACEDOWN_ATTACK)
			return 1
		elseif hasshield then
			cm.SetCard(p, m + 30, LOCATION_SZONE, POS_FACEDOWN_ATTACK)
			return 1
		elseif ct > 1 then
			cm.SetCard(p, m + 23, LOCATION_SZONE, POS_FACEDOWN_ATTACK)
			cm.SetCard(p, m + 30, LOCATION_SZONE, POS_FACEDOWN_ATTACK)
			return 2
		end
		cm.SetCard(p, m + 23, LOCATION_SZONE, POS_FACEDOWN_ATTACK)
		return 1
	elseif lv == 2 then
		if g:IsExists(Card.IsCode, 1, nil, m + 31, m + 32, m + 33) then return 0 end
		local code = m + 30 + math.random(1, 3)
		cm.SetCard(p, code, LOCATION_SZONE, POS_FACEDOWN_ATTACK)
		return 1
	elseif lv == 3 then
		if g:IsExists(Card.IsCode, 1, nil, m + 34, m + 35, m + 36) then return 0 end
		local code = m + 33 + math.random(1, 3)
		cm.SetCard(p, code, LOCATION_SZONE, POS_FACEDOWN_ATTACK)
		return 1
	elseif lv == 4 then
		if g:IsExists(Card.IsCode, 1, nil, m + 37) then return 0 end
		cm.SetCard(p, m + 37, LOCATION_SZONE, POS_FACEDOWN_ATTACK)
		return 1
	end

	if g:IsExists(Card.IsCode, 1, nil, m + 38, m + 39, m + 40) then return 0 end

	if Duel.GetLP(p) == 1000 then
		cm.SetCard(p, m + 40, LOCATION_SZONE, POS_FACEDOWN_ATTACK)
		return 1
	end

	local code = m + 39
	if math.random(1, 9 - 2 * cm.RiskLevel(p)) == 1 then
		code = code - 1
	end

	cm.SetCard(p, code, LOCATION_SZONE, POS_FACEDOWN_ATTACK)
	return 1
end

function cm.ExpectOppoSum()
	local oppo_sum = cm.GetSum(1 - PL, true)
	local oppo_best = cm.GetGuessBest(1 - PL, true)
	local risk = cm.RiskLevel(PL)

	if PRESTAY or risk == 3 then
		oppo_sum = oppo_sum + oppo_best
	elseif risk == 2 then
		local deck = cm.GetGuessDeck(PL)
		local hide_mean = 0
		for _, n in ipairs(deck) do
			hide_mean = hide_mean + n
		end
		oppo_sum = oppo_sum + (hide_mean // #deck)
	else
		oppo_sum = oppo_sum + cm.GetGuessMax(PL)
	end
	return oppo_sum, oppo_best
end

function cm.BotHitStay()
	local oppo_sum, oppo_best = cm.ExpectOppoSum()
	local self_sum = cm.GetSum(PL)
	local goal = cm.GetGoal() + 1

	if self_sum >= oppo_sum or self_sum == goal - 1 then return STAY end

	local deck = cm.GetGuessDeck(PL)
	local safe_ct = 0
	for _, n in ipairs(deck) do
		if not (PRESTAY and oppo_best == n) and (self_sum + n < goal) then
			safe_ct = safe_ct + 1
		end
	end

	local g = cm.GetFaceDown(PL, LOCATION_SZONE, 0)
	if g:IsExists(Card.IsCode, 1, nil, m + 20) then return HIT end

	local risk = cm.RiskLevel(PL)
	local threshold = #deck

	if risk == 1 then
		threshold = (2 * threshold) // 3
	elseif risk == 2 then
		threshold = threshold // 2
	else
		threshold = threshold // 4
	end

	return (safe_ct > threshold) and HIT or STAY
end

function cm.IsBetter(ps_sum, po_sum, s_sum, o_sum)
	local goal = cm.GetGoal()
	local pres, pp = cm.GetWiner(ps_sum, po_sum)
	if pp == goal then return false end

	local res, p = cm.GetWiner(s_sum, o_sum)
	if p == goal then
		return true
	elseif res == 0 then
		return pres ~= 0
	elseif res == "Draw" then
		return pres == 1
	end
	return false
end

function cm.BotCanUse(c)
	if not cm.CanUse(c) then return false end
	local name = SKILLS[cm.GetNumber(c) - 11]

	local goal = cm.GetGoal()
	local s_sum = cm.GetSum(PL)
	local o_sum = cm.ExpectOppoSum()
	local ex_res = cm.GetWiner(s_sum, o_sum)
	local risk = cm.RiskLevel(PL)
	local danger = (risk == 3) or (PRESTAY and (cm.BotHitStay() == STAY) and (ex_res ~= 0))
	local safe = (risk ~= 3) or ((cm.BotHitStay() == STAY) and (ex_res ~= 1))

	local get_n = { Two = 2, Three = 3, Four = 4, Five = 5, Six = 6, Seven = 7 }
	if get_n[name] then
		local deck = cm.GetGuessDeck(PL)
		local isexist = false
		for _, v in ipairs(deck) do
			isexist = isexist or v == get_n[name]
		end
		return isexist and cm.IsBetter(s_sum, o_sum, s_sum + get_n[name], o_sum)
	elseif name == "Up" then
		return (MODE == NIGHTMARE) or safe
	elseif name == "Remove" or name == "Oblivion" then
		return danger
	elseif name == "Return" then
		return s_sum > goal
	elseif name == "Exchange" then
		local add = cm.GetNumber(cm.GetLast(1 - PL)) - cm.GetNumber(cm.GetLast(PL))
		return cm.IsBetter(s_sum, o_sum, s_sum + add, o_sum - add)
	elseif name == "Shield" then
		return safe and cm.GetFaceDown(PL, LOCATION_SZONE, 0):IsExists(Card.IsCode, 1, nil, m + 30)
			or (danger and cm.GetPay(PL, 0) > 0)
	elseif name == "Perfect" then
		return s_sum + cm.GetGuessBest(PL, false) == goal
	elseif name == "Love" then
		return PRESTAY
	elseif name == "Go_17" or name == "Go_24" or name == "Go_27" then
		local _goal = tonumber(name:sub(4))
		return (ex_res ~= 0) and (cm.GetWiner(s_sum, o_sum, _goal) == 0)
	elseif name == "Assault" then
		return safe
	elseif name == "Curse" then
		return PRESTAY or (cm.GetSum(1 - PL, true) + cm.GetGuessMax(PL) > goal)
	elseif name == "Black" then
		return safe or (s_sum + cm.GetGuessMax(PL) < goal + 1)
			or cm.GetFaceDown(PL, LOCATION_SZONE, 0):IsExists(Card.IsCode, 1, nil, m + 20, m + 21)
	elseif name == "Twenty" then
		return s_sum == 21
	end
	return true
end

function cm.BotUseSkill()
	local og = cm.GetFaceDown(PL, LOCATION_SZONE, 0)
	local g = og:Filter(cm.BotCanUse, nil)
	local use = #g > 0
	while #g > 0 do
		local c = g:GetMaxGroup(Card.GetLevel):GetFirst()
		cm.Use(c)
		og = cm.GetFaceDown(PL, LOCATION_SZONE, 0)
		g = og:Filter(cm.BotCanUse, nil)
	end
	return use
end

------------------------------------------------------------ operate
function cm.UseSkill()
	local og = cm.GetFaceDown(PL, LOCATION_SZONE, 0)
	local g = og:Filter(cm.CanUse, nil)
	while #g > 0 do
		Duel.Hint(HINT_SELECTMSG, PL, USESKILL)
		local c = g:SelectUnselect(Group.CreateGroup(), PL, false, true, 1, 1)
		if not c then break end
		if Duel.SelectOption(PL, 1211, 1212) == 0 then
			cm.Use(c)
			og = cm.GetFaceDown(PL, LOCATION_SZONE, 0)
			g = og:Filter(cm.CanUse, nil)
		end
	end
end

function cm.HitStay()
	::RESELECTHITORSTAY::
	local g = cm.GetFaceDown(PL, LOCATION_SZONE, 0)
	if Duel.GetLocationCount(PL, LOCATION_MZONE, PLAYER_NONE, 0) == 0 then
		if ORDER ~= PL and not MULTI then
			if g:IsExists(cm.BotCanUse, 1, nil) then
				cm.BotUseSkill()
				PRESTAY = false
				goto RESELECTHITORSTAY
			end
			return STAY
		end
		if not g:IsExists(cm.CanUse, 1, nil) then return STAY end
		if Duel.SelectOption(PL, STAY, USESKILL) == 1 then
			cm.UseSkill()
			PRESTAY = false
			goto RESELECTHITORSTAY
		end
		return STAY
	end

	local sel
	if ORDER ~= PL and not MULTI then
		if g:IsExists(cm.BotCanUse, 1, nil) then
			cm.BotUseSkill()
			PRESTAY = false
			goto RESELECTHITORSTAY
		else
			sel = cm.BotHitStay()
		end
	else
		local ops = { HIT, STAY }
		if g:IsExists(cm.CanUse, 1, nil) then ops[3] = USESKILL end
		sel = ops[Duel.SelectOption(PL, table.unpack(ops)) + 1]
		if sel == USESKILL then
			cm.UseSkill()
			PRESTAY = false
			goto RESELECTHITORSTAY
		end
	end

	if sel == STAY then return STAY end
	cm.Draw()
	return HIT
end

------------------------------------------------------------ Control
function cm.Control(e)
	if cm.HitStay() == STAY then
		if PRESTAY then
			Duel.ChangePosition(cm.GetFaceDown(0, LOCATION_MZONE, LOCATION_MZONE), POS_FACEUP_ATTACK)
			local res, p = cm.GetWiner(cm.GetSum(0), cm.GetSum(1))
			cm.EndRound(res, p)
			cm.NewRound()
		else
			PRESTAY = true
		end
	else
		PRESTAY = false
	end
	PL = 1 - PL
	Duel.SkipPhase(Duel.GetTurnPlayer(), Duel.GetCurrentPhase(), RESET_PHASE+PHASE_END, 1)
end

function cm.EndRound(result, win_point)
	if result == "Draw" then
		Duel.Hint(HINT_MESSAGE, 0, DRAW)
		Duel.Hint(HINT_MESSAGE, 1, DRAW)
	else
		Duel.Hint(HINT_MESSAGE, result, WIN)
		Duel.Hint(HINT_MESSAGE, 1 - result, LOSE)
		local pay = cm.GetPay(1 - result, win_point)
		Duel.Damage(1 - result, pay, REASON_RULE)
		if MULTI then
			PL = result
		else
			PL = 1 - ORDER
		end
	end

	local g = cm.GetFaceUp(0, LOCATION_MZONE, LOCATION_MZONE)
	Duel.SendtoHand(g, nil, REASON_RULE)

	g = cm.GetFaceUp(0, LOCATION_SZONE, LOCATION_SZONE)
	if g:IsExists(Card.IsCode, 1, nil, m + 33) then
		Duel.Hint(HINT_CARD, ORDER, m + 33)
		g = g + Duel.GetFieldGroup(ORDER, LOCATION_SZONE, 0)
	end
	Duel.SendtoHand(g, nil, REASON_RULE)
end

function cm.NewRound()
	local deck = {}
	for i = 1, 11 do
		deck[i] = i
	end
	for i = #deck, 2, -1 do
		local j = math.random(i)
		deck[i], deck[j] = deck[j], deck[i]
	end
	DECK = deck
	PRESTAY = false

	for p = 0, 1 do
		local code = m + table.remove(DECK)
		local card = Duel.CreateToken(p, code)
		Duel.MoveToField(card, ORDER, p, LOCATION_MZONE, POS_FACEDOWN_ATTACK, true, 1)
	end

	if MODE == SKILL then
		cm.DrawTrump(0, 1)
		cm.DrawTrump(1, 1)
	elseif MODE == NIGHTMARE then
		cm.DrawTrump(ORDER, 1)
		local ct = cm.DrawNightmareTrump(1 - ORDER, 2)
		if 2 - ct > 0 then
			cm.DrawTrump(1 - ORDER, 2 - ct)
		end
	end
end

function cm.GameStart(p)
	ORDER, PL = p, p
	MULTI = Duel.SelectOption(ORDER, 1201, 1200) == 1
	local modes = {NORMAL, SKILL, NIGHTMARE}
	if MULTI then
		MODE = modes[Duel.SelectOption(ORDER, NORMAL, SKILL) + 1]
		local sp = Duel.RockPaperScissors(true)
		local isfirst = Duel.SelectOption(sp, 100, 101) == 0
		PL = isfirst and sp or 1 - sp
	else
		MODE = modes[Duel.SelectOption(ORDER, NORMAL, SKILL, NIGHTMARE) + 1]
	end

	Duel.SetLP(PL, 10000)
	Duel.SetLP(1 - PL, (MODE == NIGHTMARE) and 50000 or 10000)

	cm.NewRound()
end

------------------------------------------------------------
function cm.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	for _, pha in ipairs{1, 2, 4, 512} do
		local e2 = Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE_START + pha)
		e2:SetRange(LOCATION_ONFIELD)
		e2:SetOperation(cm.Control)
		c:RegisterEffect(e2)
	end
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1, 1)
	e3:SetCode(EFFECT_CANNOT_BP)
	e3:SetRange(0xFF)
	c:RegisterEffect(e3)
end
function cm.op1(e, tp, eg, ep, ev, re, r, rp)
	math.randomseed(Duel.GetFieldGroup(0, 0xFF, 0xFF):RandomSelect(0, 3):GetSum(Card.GetCode))
	local g = Duel.GetFieldGroup(tp, LOCATION_ONFIELD, LOCATION_ONFIELD)
	if #g > 0 then Duel.SendtoGrave(g, REASON_RULE) end
	Duel.SpecialSummon(e:GetHandler(), 0, tp, tp, true, true ,POS_FACEUP_ATTACK, 0x20)
	cm.GameStart(tp)
	Duel.SkipPhase(tp, PHASE_MAIN1, RESET_PHASE+PHASE_END, 1, 1)
end