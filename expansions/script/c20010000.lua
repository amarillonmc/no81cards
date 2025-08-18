--贪食蛇
local cm, m = GetID()
local MULTI
local AUTO
local ORDER
local PL
local ZONE_LEFT = 0x400020
local ZONE_RIGHT = 0x200040
local FOOD
local BODY = m + 2
local SNAKE = { }

local function XYToZone(x, y)
	local zone = 1
	if y == 1 then
		return 1 << (7 + x)
	elseif y == 2 then
		return 1 << (x - 1)
	elseif y == 3 then
		return (x == 2) and ZONE_LEFT or ZONE_RIGHT 
	elseif y == 4 then
		return 1 << (21 - x)
	elseif y == 5 then
		return 1 << (29 - x)
	end
end

local function ZoneToXY(zone)
	if (zone & ZONE_LEFT) ~= 0 then
		return 2, 3
	elseif (zone & ZONE_RIGHT) ~= 0 then
		return 4, 3
	end
	for _, y in ipairs{2, 1, 4, 5} do
		local z = zone & 0xFF
		if z ~= 0 then
			for x = 0, 4 do
				if (z & (1 << x)) ~= 0 then
					return (y >= 4) and (5 - x) or (x + 1), y
				end
			end
		end
		zone = zone >> 8
	end
end

local function GetLoc(c)
	local ispl = c:IsControler(ORDER)
	local seq = c:GetSequence()

	if seq == 5 or seq == 6 then
		if ispl then
			return 2 ^ seq, (2 * seq - 8), 3
		end
		return (2 ^ seq) << 16, (14 - 2 * seq), 3
	end

	local x = ispl and (seq + 1) or (5 - seq)
	local y = ispl and 2 or 4
	local zone = 1 << seq << (ispl and 0 or 16)
	if c:IsLocation(LOCATION_SZONE) then
		zone = zone << 8
		y = 2 * y - 3 -- 1 or 5
	end
	return zone, x, y
end

local function XYToSeq(tp, p, x, y)
	if y == 1 or y == 2 then
		return tp, 12 - 4 * y, x - 1
	elseif y == 3 then
		if tp == p then
			return tp, 4, x // 2 + 4
		end
		return p, 4, 7 - x // 2
	end
	return XYToSeq(1 - tp, p, 6 - x, 6 - y)
end

local function CanUP(c, x, y, ft_zone)
	if y == 5 then return false end
	if y == 2 and (x == 1 or x == 3 or x == 5) then return false end
	local p, loc, seq = XYToSeq(ORDER, c:GetControler(), x, y + 1)
	return Duel.CheckLocation(p, loc, seq) or (XYToZone(x, y + 1) & ft_zone) ~= 0
end

local function CanDOWN(c, x, y, ft_zone)
	if y == 1 then return false end
	if y == 4 and (x == 1 or x == 3 or x == 5) then return false end
	local p, loc, seq = XYToSeq(ORDER, c:GetControler(), x, y - 1)
	return Duel.CheckLocation(p, loc, seq) or (XYToZone(x, y - 1) & ft_zone) ~= 0
end

local function CanLEFT(c, x, y, ft_zone) 
	if x == 1 or y == 3 then return false end
	local p, loc, seq = XYToSeq(ORDER, c:GetControler(), x - 1, y)
	return Duel.CheckLocation(p, loc, seq) or (XYToZone(x - 1, y) & ft_zone) ~= 0
end

local function CanRIGHT(c, x, y, ft_zone) 
	if x == 5 or y == 3 then return false end
	local p, loc, seq = XYToSeq(ORDER, c:GetControler(), x + 1, y)
	return Duel.CheckLocation(p, loc, seq) or (XYToZone(x + 1, y) & ft_zone) ~= 0
end

local function GetFTZone()
	local ft_zone = GetLoc(FOOD)
	local len = #SNAKE
	if len < 3 or len % 2 == 0 then return ft_zone end
	local zone = GetLoc(SNAKE[len])
	ft_zone = ft_zone | zone
	return ft_zone
end

local function CanMove(c)
	local _, x, y = GetLoc(c)
	local ft_zone = GetFTZone()
	return CanUP(c, x, y, ft_zone) or CanDOWN(c, x, y, ft_zone)
		or CanLEFT(c, x, y, ft_zone) or CanRIGHT(c, x, y, ft_zone)
end

local function FixSelectZone(zone)
	if ORDER == PL then return zone end
	return ((zone << 16) | (zone >> 16)) & 0x1F7F1F7F
end

local function GetGo(c)
	local _, x, y = GetLoc(c)
	local ft_zone = GetFTZone()
	local dirs = {
		{check = CanUP,  dx =  0, dy =  1},
		{check = CanDOWN,   dx =  0, dy = -1},
		{check = CanLEFT,   dx = -1, dy =  0},
		{check = CanRIGHT,  dx =  1, dy =  0},
	}

	local zone, ct = 0, 0
	for _, dir in ipairs(dirs) do
		if dir.check(c, x, y, ft_zone) then
			zone = zone + XYToZone(x + dir.dx, y + dir.dy)
			ct = ct + 1
		end
	end

	AUTO = ct == 1
	if not AUTO then
		zone = FixSelectZone(zone)
		Duel.Hint(HINT_SELECTMSG, PL, 571)
		zone = Duel.SelectField(PL, 1, LOCATION_ONFIELD, LOCATION_ONFIELD, ~zone)
		zone = FixSelectZone(zone)
	end
	local x, y = ZoneToXY(zone)
	return zone, x, y
end

local function ZoneFix(zone)
	while (zone & 0x7F) == 0 do
		zone = zone >> 8
	end
	return zone
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

local function CreatPart(code, zone, x, y)
	if y ~= 3 then
		local p = (y == 4 or y == 5) and (1 - ORDER) or ORDER
		local part = Duel.CreateToken(p, code)
		local loc = (y == 1 or y == 5) and LOCATION_SZONE or LOCATION_MZONE
		local zone = ZoneFix(zone)
		Duel.MoveToField(part, ORDER, p, loc, POS_FACEUP_ATTACK, true, zone)
		return part
	end

	local xys, ct = GetUseableMzoneXY()
	local _x, _y = table.unpack(xys[math.random(1, ct)])
	local _zone = XYToZone(_x, _y)
	local part = CreatPart(code, _zone, _x, _y)
	local map = {
		[true] = { [2] = 5, [4] = 6 },
		[false] = { [2] = 6, [4] = 5 },
	}
	local seq = map[part:IsControler(ORDER)][x]
	Duel.MoveSequence(part, seq)
	return part
end

local function MovePart(part, zone, x, y)
	local pp = part:GetControler()
	local ploc = part:GetLocation()
	local p, loc, seq = XYToSeq(ORDER, pp, x, y)
	if loc == ploc then
		if p == pp then
			Duel.MoveSequence(part, seq)
		else
			Duel.GetControl(part, p, 0, 0, ZoneFix(zone))
		end
	elseif loc == 8 and ploc == 4 then
		Duel.MoveToField(part, pp, p, loc, POS_FACEUP_ATTACK, true, ZoneFix(zone))
	elseif part:IsCode(m) then
		Duel.SpecialSummon(part, 0, pp, pp, true, true, POS_FACEUP_ATTACK, ZoneFix(zone))
	else
		Duel.Destroy(part, REASON_RULE)
		part = CreatPart(BODY, zone, x, y)
	end
	return part
end

local function MoveBody(zone, x, y)
	local body, index = SNAKE[1], 1
	while body do
		local nzone, nx, ny = GetLoc(body)

		SNAKE[index] = MovePart(body, zone, x, y)

		index = index + 1
		body = SNAKE[index]
		zone, x, y = nzone, nx, ny
	end
end

local function BodyCheck(zone)
	local fzone = GetLoc(FOOD)
	if fzone & zone > 0 then
		Duel.Destroy(FOOD, REASON_RULE)
		FOOD = nil
		return true
	end

	local tail = SNAKE[#SNAKE]
	if not tail or GetLoc(tail) & zone == 0 then return false end
	Duel.Destroy(tail, REASON_RULE)
	table.remove(SNAKE)
	return true
end

local function Move(c)
	local pzone, px, py = GetLoc(c)
	local zone, x, y = GetGo(c)
	local body_chk = BodyCheck(zone)

	MovePart(c, zone, x, y)

	if body_chk then
		for i = #SNAKE, 1, -1 do
			SNAKE[i + 1] = SNAKE[i]
		end
		SNAKE[1] = CreatPart(BODY, pzone, px, py)
	else
		MoveBody(pzone, px, py)
	end
end

local function GetUseableXY()
	local xys = GetUseableMzoneXY()

	for y = 1, 5, 4 do
		local isp = y == 1
		local _, zone = Duel.GetLocationCount(isp and ORDER or 1 - ORDER, LOCATION_SZONE, PLAYER_NONE, 0)

		for i = 0, 4 do
			if (zone & (1 << i)) == 0 then
				local x = isp and (i + 1) or (5 - i)
				xys[#xys + 1] = {x, y}
			end
		end
	end

	for seq = 5, 6 do
		if Duel.CheckLocation(ORDER, LOCATION_MZONE, seq) then
			xys[#xys + 1] = {2 * seq - 8, 3}
		end
	end

	return xys, #xys
end

local function CreatFood()
	local xys, ct = GetUseableXY()
	if ct == 0 then return end
	local x, y = table.unpack(xys[math.random(1, ct)])
	local zone = XYToZone(x, y)
	FOOD = CreatPart(m + 1, zone, x, y)
end

local function GameStart(c, p)
	PL, ORDER = p, p
	MULTI = Duel.SelectOption(ORDER, 1201, 1200) == 1
	if MULTI then
		local sp = Duel.RockPaperScissors(true)
		local isfirst = Duel.SelectOption(sp, 100, 101) == 0
		PL = isfirst and sp or 1 - sp
	end

	Duel.MoveToField(c, p, p, LOCATION_MZONE ,POS_FACEUP_ATTACK, true, 4)
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
	GameStart(e:GetHandler(), tp)
	Duel.SkipPhase(tp, PHASE_MAIN1, RESET_PHASE+PHASE_END, 1, 1)
end
function cm.op2(e)
	if not FOOD then CreatFood() end
	local c = e:GetHandler()
	if CanMove(c) then
		Move(c)
		Duel.SkipPhase(Duel.GetTurnPlayer(), Duel.GetCurrentPhase(), RESET_PHASE+PHASE_END, 1)
	else
		local win = #SNAKE == 20
		local id = win and 1 or 0
		local p = AUTO and 1 - PL or PL
		Duel.Hint(HINT_MESSAGE, p, aux.Stringid(m, id))
		local winp = win and 1 - PL or PL
		Duel.Win(winp, WIN_REASON_EXODIA)
	end
	if MULTI and not AUTO then PL = 1 - PL end
end