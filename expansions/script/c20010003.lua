--踩地雷
local cm, m = GetID()
local MULTI
local ORDER
local PL
local FIELD = {{ }, { }, { }, { }, { }}
local UNKNOWN  = m + 1
local FLAG   = m + 2
local MINE   = m + 3
local SEL_OPEN  = 16 * m + 1
local SEL_SETFLAG  = 16 * m + 2
local SEL_DELFLAG  = 16 * m + 3
local SEL_REDELECT = 16 * m + 4
local OFFSETS = {
	{-1,-1}, {0,-1}, {1,-1},
	{-1, 0},		 {1, 0},
	{-1, 1}, {0, 1}, {1, 1}
}

local function GetXY(c)
	local ispl = c:IsControler(ORDER)
	local seq = c:GetSequence()

	if seq == 5 or seq == 6 then
		if ispl then
			return (2 * seq - 8), 3
		end
		return (14 - 2 * seq), 3
	end

	local x = ispl and (seq + 1) or (5 - seq)
	local y = ispl and 2 or 4
	if c:IsLocation(LOCATION_SZONE) then
		y = 2 * y - 3 -- 1 or 5
	end
	return x, y
end

local function GetUseableMzoneXY()
	local xys = {}

	for p = 0, 1 do
		local isp = p == ORDER
		local _, zone = Duel.GetLocationCount(p, LOCATION_MZONE, PLAYER_NONE, 0)
		local y = isp and 2 or 4

		for i = 0, 4 do
			if (zone & (1 << i)) == 0 then
				local x = isp and (i + 1) or (5 - i)
				xys[#xys + 1] = {x, y}
			end
		end
	end

	return xys, #xys
end

local function XYToZone(x, y)
	return 1 << ((y == 1 or y == 2) and (x - 1) or (5 - x))
end

local function CreatPart(code, x, y)
	if y ~= 3 then
		local p = (y == 4 or y == 5) and 1 - ORDER or ORDER
		local part = Duel.CreateToken(p, code)
		local loc = (y == 1 or y == 5) and LOCATION_SZONE or LOCATION_MZONE
		local zone = XYToZone(x, y)
		Duel.MoveToField(part, 0, p, loc, POS_FACEUP_ATTACK, true, zone)
		return part
	end

	local xys, ct = GetUseableMzoneXY()
	local _x, _y
	local _code, _ismine
	local map = {
		[true] = { [2] = 5, [4] = 6 },
		[false] = { [2] = 6, [4] = 5 },
	}
	if ct > 0 then
		_x, _y = table.unpack(xys[1])
	else
		local f = function(c) return c:GetSequence() == x - 1 end
		local _part = Duel.GetMatchingGroup(f, ORDER, LOCATION_MZONE, 0, nil):GetFirst()
		_x, _y = x, 2
		_code = _part:GetCode()
		_ismine = _part:GetFlagEffect(MINE) > 0
		Duel.Destroy(_part, REASON_RULE)
	end
	local part = CreatPart(code, _x, _y)
	local seq = map[part:IsControler(ORDER)][x]
	Duel.MoveSequence(part, seq)
	if _code then
		local _part = CreatPart(_code, _x, _y)
		FIELD[_x][_y] = _part
		if _ismine then
			_part:RegisterFlagEffect(MINE, 0, 0, 1)
		end
	end
	return part
end

local function GetAround(x, y)
	local around = { }
	for _, offset in ipairs(OFFSETS) do
		local _x, _y = x + offset[1], y + offset[2]
		if _x > 0 and _x < 6 and FIELD[_x][_y] then
			table.insert(around, {_x, _y})
		end
	end
	return around
end

local function SetMine(c)
	local mineable = {{ }, { }, { }, { }, { }}

	for x = 1, 5 do
		for y = 1, 5 do
			mineable[x][y] = true
		end
	end

	mineable[1][3] = false
	mineable[3][3] = false
	mineable[5][3] = false

	local x, y = GetXY(c)
	mineable[x][y] = false
	for _, around in ipairs(GetAround(x, y)) do
		local x, y = table.unpack(around)
		mineable[x][y] = false
	end

	for i = 1, 5 do
		x, y = math.random(1, 5), math.random(1, 5)
		while not mineable[x][y] do
			x, y = math.random(1, 5), math.random(1, 5)
		end
		mineable[x][y] = false
		local c = FIELD[x][y]
		c:RegisterFlagEffect(MINE, 0, 0, 1)
	end
end

local function Open(c)
	if not c then return false end
	local x, y = GetXY(c)
	local ismine = c:GetFlagEffect(MINE) > 0

	Duel.Destroy(c, REASON_RULE)
	FIELD[x][y] = nil

	if ismine then return CreatPart(MINE, x, y) end

	local arounds = GetAround(x, y)
	local minect = 0
	for _, around in ipairs(arounds) do
		local ax, ay = table.unpack(around)
		if FIELD[ax][ay]:GetFlagEffect(MINE) > 0 then
			minect = minect + 1
		end
	end
	if minect == 0 then
		for _, around in ipairs(arounds) do
			local ax, ay = table.unpack(around)
			Open(FIELD[ax][ay])
		end
	else
		local code = m + minect + 3
		CreatPart(code, x, y)
	end
	return false
end

local function Option(g)
	local c, op
	repeat
		Duel.Hint(HINT_SELECTMSG, PL, 574)
		c = g:Select(PL, 1, 1, nil):GetFirst()
		local ops
		if c:IsCode(FLAG) then
			ops = {SEL_DELFLAG, SEL_REDELECT}
		else
			ops = {SEL_OPEN, SEL_SETFLAG, SEL_REDELECT}
		end
		op = ops[Duel.SelectOption(PL, table.unpack(ops)) + 1]
	until op ~= SEL_REDELECT

	if op == SEL_OPEN then
		if #g == 22 then
			SetMine(c)
		end
		return Open(c)
	end

	local x, y = GetXY(c)
	local ismine = c:GetFlagEffect(MINE) > 0
	Duel.Destroy(c, REASON_RULE)
	local code = (op == SEL_SETFLAG) and FLAG or UNKNOWN
	local part = CreatPart(code, x, y)
	if ismine then
		part:RegisterFlagEffect(MINE, 0, 0, 1)
	end
	FIELD[x][y] = part
	if MULTI then PL = 1 - PL end
	return false
end

local function GameStart(p)
	PL, ORDER = p, p
	MULTI = Duel.SelectOption(ORDER, 1201, 1200) == 1
	if MULTI then
		local sp = Duel.RockPaperScissors(true)
		local isfirst = Duel.SelectOption(sp, 100, 101) == 0
		PL = isfirst and sp or 1 - sp
	end

	for seq = 5, 6 do
		local unknown = Duel.CreateToken(ORDER, UNKNOWN)
		Duel.MoveToField(unknown, ORDER, ORDER, LOCATION_MZONE, POS_FACEUP_ATTACK, true, 1)
		Duel.MoveSequence(unknown, seq)
		local x = 2 * seq - 8
		FIELD[x][3] = unknown
	end

	local map = { }
	map[1] = {{p = ORDER, y = 2}, {p = 1 - ORDER, y = 4}}
	map[2] = {{p = ORDER, y = 1}, {p = 1 - ORDER, y = 5}}
	for loc, py in ipairs(map) do
		loc = loc * 4
		for _, v in ipairs(py) do
			for i = 0, 4 do
				local unknown = Duel.CreateToken(v.p, UNKNOWN)
				Duel.MoveToField(unknown, ORDER, v.p, loc, POS_FACEUP_ATTACK, true, 1 << i)
				local x = (v.y > 3) and (5 - i) or (i + 1)
				FIELD[x][v.y] = unknown
			end
		end
	end
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
		e2:SetRange(LOCATION_EXTRA)
		e2:SetCondition(cm.con2)
		e2:SetOperation(cm.op2)
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
	e:GetHandler():RegisterFlagEffect(m, 0, 0, 1)
	GameStart(tp)
	Duel.SkipPhase(tp, PHASE_MAIN1, RESET_PHASE+PHASE_END, 1, 1)
end
function cm.con2(e)
	return e:GetHandler():GetFlagEffect(m) > 0
end
function cm.op2(e)
	local g = Duel.GetFieldGroup(0, LOCATION_ONFIELD, LOCATION_ONFIELD)
	g = g:Filter(Card.IsCode, nil, UNKNOWN, FLAG)
	if #g == 5 then
		local winp = MULTI and 1 - PL or PL
		Duel.Hint(HINT_MESSAGE, winp, aux.Stringid(m, 6))
		Duel.Win(winp, WIN_REASON_EXODIA)
	elseif Option(g) then
		Duel.Hint(HINT_MESSAGE, PL, aux.Stringid(m, 5))
		Duel.Hint(HINT_MESSAGE, 1 - PL, aux.Stringid(m, 6))
		Duel.Win(1 - PL, WIN_REASON_EXODIA)
	else
		if MULTI then PL = 1 - PL end
		Duel.SkipPhase(Duel.GetTurnPlayer(), Duel.GetCurrentPhase(), RESET_PHASE+PHASE_END, 1)
	end
end