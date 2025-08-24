--恶魔轮盘
local cm, m = GetID()
local ORDER, PL, MODE, STURN
local BULLET, BOTBULLET = { }, { }
local MAX_LP, ALIVE, REMOTE, FIRST
local GUN1, GUN2 = m + 1, m + 2
local LIVE, BLANK  = m + 3, m + 4
local LIMIT   = m + 5
local ITEM = { "Glass", "Cigarette", "Beer", "Handsaw", "Handcuffs", "Phone", "Inverter", "Adrenaline",
	"Medicine", "Jammer", "Remote" }
local NORMAL  = { 18, 19, 20, 21, 22}
local ENDLESS = { 18, 19, 20, 21, 22, 23, 24, 25, 26 }
local MULTI   = { 18, 19, 20, 21, 23, 24, 25, 27, 28 }

------------------------------------------------------------ Get
function cm.GetName(c)
	local code = c:GetCode()
	return code, ITEM[code - m - 17]
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

function cm.Get(p, loc1, loc2, ...)
	return Duel.GetMatchingGroup(Card.IsCode, p, loc1, loc2, nil, ...)
end

function cm.GetItem(pl)
	local p = cm.PlToP(pl)
	local loc = pl > 2 and LOCATION_MZONE or LOCATION_SZONE
	local codes = { }
	for i = 18, 28 do
		table.insert(codes, m + i)
	end
	return cm.Get(p, loc, 0, table.unpack(codes))
end

function cm.GetGun()
	return cm.Get(ORDER, LOCATION_MZONE, 0, GUN1, GUN2):GetFirst()
end

function cm.GetUsableGroup()
	local items = Group.CreateGroup()
	for pl in cm.ForPlayer(PL) do
		for item in aux.Next(cm.GetItem(pl)) do
			if not item:IsCode(m + 25) and cm.CanUse(item) then
				items:AddCard(item)
			end
		end
	end
	return items
end

function cm.ForPlayer(skip)
	local i, max = 0, math.max(2, MODE)
	return function()
		i = i + 1
		if i == skip then i = i + 1 end
		return i <= max and i or nil
	end
end

------------------------------------------------------------ Set
function cm.Set(p, code, loc, zone)
	local c = Duel.CreateToken(p, code)
	local pos = loc == LOCATION_MZONE and POS_FACEUP_ATTACK or POS_FACEUP
	Duel.MoveToField(c, ORDER, p, loc, pos, true, zone)
	return c
end

function cm.SetGun(gun)
	local f = function(c) return c:GetSequence() == 1 end
	local c = Duel.GetMatchingGroup(f, ORDER, LOCATION_MZONE, 0, nil):GetFirst()
	local code
	if c then
		code = c:GetCode()
		Duel.SendtoHand(c, nil, REASON_RULE)
	end
	local gc = cm.Set(ORDER, gun, LOCATION_MZONE, 2)
	Duel.MoveSequence(gc, 5)
	if code then
		cm.Set(ORDER, code, LOCATION_MZONE, 2)
	end
end

function cm.SetLp()
	MAX_LP = (MODE == 1) and (2 * cm.GetRound()) or math.random(math.max(2, MODE), 6)
	for p = 1, ALIVE do
		cm.SetScore(cm.GetScore(p), "base", MAX_LP, true)
	end
end

function cm.SetBullet()
	local live_ct = math.random(1, 4)
	local blank_ct = ({live_ct - 2, live_ct - 1, live_ct - 1, live_ct, live_ct, live_ct
		, live_ct + 1, live_ct + 1, live_ct + 2})[math.random(1, 9)]

	blank_ct = math.max(1, math.min(4, blank_ct))

	BULLET, BOTBULLET = { }, { }
	for i = 1, live_ct + blank_ct do
		BULLET[i] = i <= live_ct
		BOTBULLET[i] = 0
	end
	for i = #BULLET, 2, -1 do
		local j = math.random(i)
		BULLET[i], BULLET[j] = BULLET[j], BULLET[i]
	end

	local gc = cm.GetGun()
	if gc then 
		local gcod = gc:GetCode()
		Duel.SendtoHand(gc, nil, REASON_RULE)
		gc = gcod
	end

	local codes = { { }, { } }
	for pl = 3, 4 do
		for c in aux.Next(cm.GetItem(pl)) do
			table.insert(codes[c:GetControler() + 1], c:GetCode())
			Duel.SendtoHand(c, nil, REASON_RULE)
		end
	end

	local bg = Group.CreateGroup()
	for i = 1, live_ct do
		bg:AddCard(cm.Set(ORDER, LIVE, LOCATION_MZONE, 1 << (i - 1)))
	end
	for i = 1, blank_ct do
		bg:AddCard(cm.Set(1 - ORDER, BLANK, LOCATION_MZONE, 1 << (i - 1)))
	end
	for c in aux.Next(bg) do
		Duel.MoveSequence(c, 5 + math.abs(c:GetControler() - ORDER))
		Duel.SendtoHand(c, nil, REASON_RULE)
	end

	cm.SetGun(gc or GUN1)

	for p, v in ipairs(codes) do
		for i, code in ipairs(v) do
			cm.Set(p - 1, code, LOCATION_MZONE, 1 << (i - 1))
		end
	end
end

function cm.SetItem()
	local map = MULTI
	local ct = math.random(1, 4)
	if MODE == 1 then
		local r = cm.GetRound()
		if r == 1 then return end
		map = NORMAL
		ct = 2 * r - 2
	elseif MODE == -1 then
		map = ENDLESS
	end

	local map_ct = #map
	for pl in cm.ForPlayer() do
		if cm.GetLp(pl) > 0 then
			local p = cm.PlToP(pl)
			local loc = pl > 2 and LOCATION_MZONE or LOCATION_SZONE
			local pct, zone = Duel.GetLocationCount(p, loc, PLAYER_NONE, 0)
			pct = math.min(pct, ct)
			while pct > 0 do
				local code = m + map[math.random(1, map_ct)]
				cm.Set(p, code, loc, cm.GetNextZone(zone))
				_, zone = Duel.GetLocationCount(p, loc, PLAYER_NONE, 0)
				pct = pct - 1
			end
		end
	end
end

------------------------------------------------------------ Bot
function cm.BotOperate()
	local noshoot = false
	local items = cm.GetItem(PL):Filter(cm.BotCanUse, nil)
	cm.GuessBullet()
	while not noshoot and #items > 0 do
		local item = cm.Use(items:GetFirst())
		if item == "Beer" and #BULLET == 0 then
			noshoot = true
		elseif item == "Medicine" and ALIVE == 1 then
			noshoot = true
		end
		if item == "Beer" or item == "Phone" then
			cm.GuessBullet()
		end
		items = cm.GetItem(PL):Filter(cm.BotCanUse, nil)
	end
	if noshoot then return end
	local guess = cm.GuessBullet()
	cm.Shoot((guess == 1) and (3 - PL) or PL)
end

function cm.GuessBullet()
	local len = #BULLET
	while len < #BOTBULLET do
		table.remove(BOTBULLET, 1)
	end
	if BOTBULLET[1] ~= 0 then return BOTBULLET[1] end

	local islive = 0
	for _, live in ipairs(BULLET) do
		islive = islive + (live and 1 or -1)
	end
	local unknowns = 0
	for i = 1, len do
		if BOTBULLET[i] == 0 then
			unknowns = unknowns + 1
		else
			islive = islive - BOTBULLET[i]
		end
	end
	if math.abs(islive) == unknowns then
		local v = (islive > 0) and 1 or -1
		for i = 1, len do
			if BOTBULLET[i] == 0 then
				BOTBULLET[i] = v
			end
		end
		return BOTBULLET[1]
	end

	return (islive > -1) and 1 or -1
end

function cm.BotCanUse(c)
	if not cm.CanUse(c) then return false end
	local _, name = cm.GetName(c)

	if name == "Glass" then
		return BOTBULLET[1] == 0
	elseif name == "Cigarette" then
		return MAX_LP ~= cm.GetLp(PL)
	elseif name == "Beer" or name == "Inverter" then
		if BOTBULLET[1] == 0 and cm.GetItem(PL):IsExists(Card.IsCode, 1, nil, m + 18) then return false end
		return cm.GuessBullet() == -1
	elseif name == "Handsaw" then
		return cm.GuessBullet() == 1
	elseif name == "Phone" then
		return #BULLET > 1
	elseif name == "Adrenaline" then
		return cm.GetUsableGroup():IsExists(cm.BotCanUse, 1, nil)
	elseif name == "Medicine" then
		return MAX_LP - cm.GetLp(PL) > 1
	end
	return true
end

------------------------------------------------------------ Operate
function cm.CanUse(c)
	local _, name = cm.GetName(c)

	if name == "Handsaw" then
		return cm.GetGun():IsCode(GUN1)
	elseif name == "Handcuffs" then
		return cm.GetScore(3 - PL):GetCode() % 3 ~= 1
	elseif name == "Adrenaline" then
		return #cm.GetUsableGroup() > 0
	elseif name == "Jammer" then
		for pl in cm.ForPlayer(PL) do
			if cm.GetScore(pl):GetCode() % 3 ~= 1 then
				return true
			end
		end
		return false
	end
	return true
end

function cm.Use(c)
	local pl = cm.PlToP(PL)
	local code, name = cm.GetName(c)
	local isbot = MODE < 2 and cm.PlToP(PL) ~= ORDER

	Duel.Hint(HINT_CARD, 1 - pl, code)
	Duel.Hint(HINT_OPSELECTED, 1 - pl, aux.Stringid(code, 0))

	if name == "Glass" then
		local live = BULLET[1]
		if isbot then
			BOTBULLET[1] = live and 1 or -1
		else
			Group.FromCards(Duel.CreateToken(pl, live and LIVE or BLANK)):Select(pl, 1, 1, nil)
		end
	elseif name == "Cigarette" then
		local score = cm.GetScore(PL)
		local lp = math.min(MAX_LP, cm.GetLp(nil, score) + 1)
		cm.ChangeLp(score, lp)
	elseif name == "Beer" then
		local code = table.remove(BULLET, 1) and LIVE or BLANK
		Duel.ConfirmCards(ORDER, Duel.CreateToken(pl, code))
	elseif name == "Handsaw" then
		Duel.SendtoHand(cm.GetGun(), nil, REASON_RULE)
		cm.SetGun(GUN2)
	elseif name == "Handcuffs" then
		cm.SetScore(cm.GetScore(3 - PL), "ban")
	elseif name == "Phone" then
		local len = #BULLET
		if len > (MODE > 1 and 2 or 1) then
			local n = math.random(2, len)
			local live = BULLET[n]
			if isbot then BOTBULLET[n] = live and 1 or -1 end
			msg = 16 * m + n + (live and 368 or 375)
			Duel.Hint(HINT_MESSAGE, pl, msg)
		else
			Duel.Hint(HINT_MESSAGE, pl, 16 * m + 369)
		end
	elseif name == "Inverter" then
		BULLET[1] = not BULLET[1]
		if isbot then BOTBULLET[1] = -cm.GuessBullet() end
	elseif name == "Adrenaline" then
		Duel.Hint(HINT_SELECTMSG, pl, 574)
		name = cm.Use(cm.GetUsableGroup():Select(pl, 1, 1, nil):GetFirst())
	elseif name == "Medicine" then
		local score = cm.GetScore(PL)
		local lp = cm.GetLp(nil, score)
		if Duel.TossCoin(pl, 1) == 1 then
			lp = math.min(MAX_LP, lp + 2)
		else
			lp = lp - 1
		end
		cm.ChangeLp(score, lp)
	elseif name == "Jammer" then
		local pls = { }
		for p in cm.ForPlayer(PL) do
			if cm.GetScore(p):GetCode() % 3 ~= 1 then
				pls[#pls + 1] = p
			end
		end
		local jp = Duel.AnnounceNumber(pl, table.unpack(pls))
		cm.SetScore(cm.GetScore(jp), "ban")
	elseif name == "Remote" then
		REMOTE = not REMOTE
	end
	Duel.SendtoHand(c, nil, REASON_RULE)
	return name
end

function cm.Shoot(pl)
	local live = table.remove(BULLET, 1)
	local score = cm.GetScore(pl)
	Duel.HintSelection(Group.FromCards(score))
	Duel.ConfirmCards(ORDER, Duel.CreateToken(ORDER, live and LIVE or BLANK))

	if live then
		local p = cm.PlToP(pl)
		Duel.Damage(p, 7999, REASON_RULE)
		cm.ChangeLp(score, math.max(0, cm.GetLp(nil, score) - cm.GetGun():GetCode() + m))
		Duel.SetLP(p, 8000)
		cm.NextPlayer()
	elseif pl ~= PL then
		cm.NextPlayer()
	end

	local gc = cm.GetGun()
	if gc:IsCode(GUN2) then 
		Duel.SendtoHand(gc, nil, REASON_RULE)
		cm.SetGun(GUN1)
	end
end

function cm.Operate()
	local pl = cm.PlToP(PL)
	while true do
		Duel.Hint(HINT_SELECTMSG, pl, 574)
		local c = (cm.GetItem(PL):Filter(cm.CanUse, nil) + cm.GetGun()):Select(pl, 1, 1, nil):GetFirst()
		if c:IsCode(GUN1, GUN2) then
			local pls, base = { }, 16 * m + 3
			for spl in cm.ForPlayer() do
				if cm.GetLp(spl) > 0 then table.insert(pls, base + spl) end
			end
			cm.Shoot(pls[Duel.SelectOption(pl, table.unpack(pls)) + 1] - base)
			break
		elseif Duel.SelectOption(pl, 1211, 1212) == 0 then
			local item = cm.Use(c)
			if item == "Beer" and #BULLET == 0 then
				break
			elseif item == "Medicine" and ALIVE == 1 then
				cm.NextPlayer()
				break
			end
		end
	end
end

------------------------------------------------------------ Round
function cm.SetRound(r)
	local c = cm.Get(ORDER, LOCATION_MZONE, 0, m):GetFirst()
	c:SetHint(CHINT_TURN, r)
	c:SetFlagEffectLabel(m, r)
end

function cm.GetRound()
	return cm.Get(ORDER, LOCATION_MZONE, 0, m):GetFirst():GetFlagEffectLabel(m)
end

function cm.NextRound()
	REMOTE, ALIVE = false, math.max(2, MODE)

	local r = cm.GetRound() % 3 + 1
	if MODE > 1 then
		PL = r == 1 and math.random(1, ALIVE) or FIRST
		FIRST = nil
	end

	cm.SetRound(r)

	for pl in cm.ForPlayer() do
		Duel.SendtoHand(cm.GetItem(pl), nil, REASON_RULE)
	end

	cm.SetLp()
	cm.NewMatch()
end

function cm.NewMatch()
	if MODE < 2 then PL = 1 end
	cm.SetBullet()
	cm.SetItem()
end

------------------------------------------------------------ Player
function cm.GetScore(pl)
	local code = m + 3 + pl * 3
	return cm.Get(cm.PlToP(pl), LOCATION_ONFIELD, 0, code, code + 1, code + 2):GetFirst()
end

function cm.SetScore(score, state, lp, hint)
	local pcode = score:GetCode()
	local map = { base = 0, now  = 1, ban  = 2 }
	local code = pcode - (pcode + 1) % 3 + map[state]
	lp = lp or cm.GetLp(nil, score)
	if state == "now" then
		for pl in cm.ForPlayer(PL) do
			local pc = cm.GetScore(pl)
			if cm.IsState(pc, "now") then
				cm.SetScore(pc, "base")
			end
		end
	end
	if code ~= pcode then
		local p, loc = score:GetControler(), score:GetLocation()
		Duel.SendtoHand(score, nil, REASON_RULE)
		score = cm.Set(p, code, loc, 0x10)
	end
	if state == "ban" and lp > 0 then
		score:RegisterFlagEffect(m + 1, 0, EFFECT_FLAG_CLIENT_HINT, 1, 1, 16 * m + 103)
	end
	cm.UpdateLp(score, lp, hint)
	score:SetHint(CHINT_NUMBER, MAX_LP)
	return score
end

function cm.UpdateLp(score, lp, hint)
	score:ResetFlagEffect(m)
	score:RegisterFlagEffect(m, 0, EFFECT_FLAG_CLIENT_HINT, 1, lp, 16 * m + lp + 96)
	if not hint then return end
	score:SetHint(CHINT_TURN, lp)
	score:SetHint(CHINT_NUMBER, MAX_LP)
end

function cm.ChangeLp(score, lp)
	if lp > 0 then
		cm.UpdateLp(score, lp, true)
	else
		score = cm.SetScore(score, "ban", 0)
		score:ResetFlagEffect(m + 1)
		FIRST = FIRST or ((score:GetCode() - m) // 3 - 1)
		ALIVE = ALIVE - 1
	end
end

function cm.GetLp(pl, score)
	if pl then score = cm.GetScore(pl) end
	return score:GetFlagEffectLabel(m)
end

function cm.IsState(score, state)
	local map = {
		base = 2,
		now = 0,
		ban = 1,
	}
	return score:GetCode() % 3 == map[state]
end

function cm.IsPLTurn()
	local turn = Duel.GetTurnCount() - STURN + 1
	if MODE > 2 then
		return (turn - 1) % 4 + 1 == PL
	else
		return (turn % 2 == 1) == (PL == 1)
	end
end

function cm.IsPLBan()
	local score = cm.GetScore(PL)
	if not cm.IsState(score, "ban") then return false end
	if cm.GetLp(nil, score) > 0 then
		if score:GetFlagEffectLabel(m + 1) ~= 1 then return false end
		score:ResetFlagEffect(m + 1)
		score:RegisterFlagEffect(m + 1, 0, EFFECT_FLAG_CLIENT_HINT, 1, 0, 16 * m + 104)
	end
	cm.NextPlayer()
	return true
end

function cm.PlToP(pl)
	return (pl + ORDER - 1) % 2
end

function cm.NextPlayer()
	if MODE < 2 then
		PL = 3 - PL
		return
	end
	if REMOTE then
		PL = (PL - 2 + MODE) % MODE + 1
	else
		PL = (PL % MODE) + 1
	end
end

------------------------------------------------------------ Control
function cm.Control()
	if cm.IsPLTurn() and not cm.IsPLBan() then
		cm.SetScore(cm.GetScore(PL), "now")
		if MODE < 2 and cm.PlToP(PL) ~= ORDER then
			cm.BotOperate()
		else
			cm.Operate()
		end
	end

	if ALIVE == 1 then
		if cm.GetRound() == 3 then
			if cm.GameOver() then return end
			cm.SetRound(0)
		elseif MODE == -1 and cm.EndlessDead() then
			return
		end
		cm.NextRound()
	elseif #BULLET == 0 then
		cm.NewMatch()
	end

	Duel.SkipPhase(Duel.GetTurnPlayer(), Duel.GetCurrentPhase(), RESET_PHASE+PHASE_END, 1)
end

function cm.EndlessDead()
	if cm.GetLp(1) == 0 then
		Duel.SetLP(ORDER, 0)
		return true
	end
	return false
end

function cm.GameOver()
	local winp
	for pl in cm.ForPlayer() do
		if not cm.IsState(cm.GetScore(pl), "ban") then
			winp = cm.PlToP(pl)
			break
		end
	end

	if MODE == -1 and winp == ORDER and Duel.SelectYesNo(winp, aux.Stringid(m, 8)) then
		return false
	end
	Duel.SetLP(1 - winp, 0)
	return true
end

function cm.GameStart(p)
	Duel.SetLP(0, 8000)
	Duel.SetLP(1, 8000)

	ORDER, PL, MODE, STURN = p, 1, 1, Duel.GetTurnCount()   --"NORMAL"
	if Duel.SelectOption(ORDER, 1201, 1200) == 1 then
		MODE = Duel.SelectOption(ORDER, aux.Stringid(m, 1), aux.Stringid(m, 2), aux.Stringid(m, 3)) + 2
	elseif Duel.SelectYesNo(ORDER, aux.Stringid(m, 0)) then
		MODE = -1   --"ENDLESS"
	end

	cm.Set(ORDER, m + 6, LOCATION_SZONE, 0x10)
	cm.Set(1 - ORDER, m + 9, LOCATION_SZONE, 0x10)
	if MODE > 2 then cm.Set(ORDER, m + 12, LOCATION_MZONE, 0x10) end
	if MODE > 3 then cm.Set(1 - ORDER, m + 15, LOCATION_MZONE, 0x10) end

	cm.NextRound()
end

------------------------------------------------------------
function cm.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1, 1)
	e2:SetCode(EFFECT_CANNOT_BP)
	e2:SetRange(0xFF)
	c:RegisterEffect(e2)
	local e3 = e2:Clone()
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e3)
end
function cm.op1(e, tp, eg, ep, ev, re, r, rp)
	math.randomseed(Duel.GetFieldGroup(0, 0xFF, 0xFF):RandomSelect(0, 3):GetSum(Card.GetCode))
	local g = Duel.GetFieldGroup(tp, LOCATION_ONFIELD, LOCATION_ONFIELD)
	if #g > 0 then Duel.SendtoGrave(g, REASON_RULE) end
	local c = e:GetHandler()
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START + PHASE_END)
	e1:SetOperation(cm.Control)
	Duel.RegisterEffect(e1, 0)
	for _, pha in ipairs{1, 2, 4} do
		local e2 = e1:Clone()
		e2:SetCode(EVENT_PHASE_START + pha)
		e2:SetOperation(cm.skip)
		Duel.RegisterEffect(e2, 0)
	end
	Duel.MoveToField(c, tp, tp, LOCATION_MZONE ,POS_FACEUP_ATTACK, true, 0x40)
	c:RegisterFlagEffect(m, 0, 0, 1, 0)
	cm.GameStart(tp)
	Duel.SkipPhase(tp, PHASE_MAIN1, RESET_PHASE+PHASE_END, 1, 1)
end
function cm.skip(e, tp, eg, ep, ev, re, r, rp)
	Duel.SkipPhase(Duel.GetTurnPlayer(), Duel.GetCurrentPhase(), RESET_PHASE+PHASE_END, 1)
end