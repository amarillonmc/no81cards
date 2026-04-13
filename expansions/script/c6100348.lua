--朦雨的箱庭-临界的雨境
local s,id,o=GetID()
function s.initial_effect(c)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	--①
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(3,id)
	e1:SetCondition(s.effcon)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	--②
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)

	if not s.sp_hack_check then
		s.sp_hack_check=true
		
		s._SpecialSummon = Duel.SpecialSummon
		Duel.SpecialSummon = function(tg, sumtype, sumplayer, targetplayer, nocheck, nolimit, pos, zone)
			sumtype = sumtype or 0
			targetplayer = targetplayer or sumplayer
			if nocheck == nil then nocheck = false end
			if nolimit == nil then nolimit = false end
			pos = pos or POS_FACEUP
			zone = zone or 0xff

			local sg = Group.CreateGroup()
			if aux.GetValueType(tg)=="Card" then sg:AddCard(tg) else sg:Merge(tg) end
			
			local effect_tp = nil
			if Duel.GetCurrentChain() > 0 then
				effect_tp = Duel.GetChainInfo(0, CHAININFO_TRIGGERING_PLAYER)
			end
			
			if effect_tp and effect_tp == sumplayer then
				local sub_card = nil
				local sub_monster = nil
				for tc in aux.Next(sg) do
					if tc:IsSetCard(0x613) and tc:IsType(TYPE_MONSTER) then
						local loc = tc:GetLocation()
						if loc ~= 0 then
							local fc = Duel.GetFirstMatchingCard(Card.IsCode, effect_tp, loc, 0, nil, id)
							if fc then
								if Duel.SelectYesNo(effect_tp, aux.Stringid(id, 2)) then
									sub_card = fc
									sub_monster = tc
									break
								end
							end
						end
					end
				end
				
				if sub_card and sub_monster then
					sg:RemoveCard(sub_monster)
					
					local old_field = Duel.GetFieldCard(effect_tp, LOCATION_FZONE, 0)
					if old_field then Duel.SendtoGrave(old_field, REASON_RULE) end
					Duel.Hint(HINT_CARD,0,id)
					Duel.MoveToField(sub_card, effect_tp, effect_tp, LOCATION_FZONE, POS_FACEUP, true)
					if #sg > 0 then
						return s._SpecialSummon(sg, sumtype, sumplayer, targetplayer, nocheck, nolimit, pos, zone)
					else
						return 0
					end
				end
			end
			return s._SpecialSummon(tg, sumtype, sumplayer, targetplayer, nocheck, nolimit, pos, zone)
		end
		
		s._SpecialSummonStep = Duel.SpecialSummonStep
		Duel.SpecialSummonStep = function(tc, sumtype, sumplayer, targetplayer, nocheck, nolimit, pos, zone)
			sumtype = sumtype or 0
			targetplayer = targetplayer or sumplayer
			if nocheck == nil then nocheck = false end
			if nolimit == nil then nolimit = false end
			pos = pos or POS_FACEUP
			zone = zone or 0xff

			local effect_tp = nil
			if Duel.GetCurrentChain() > 0 then
				effect_tp = Duel.GetChainInfo(0, CHAININFO_TRIGGERING_PLAYER)
			end
			
			if effect_tp and effect_tp == sumplayer then
				if tc:IsSetCard(0x613) and tc:IsType(TYPE_MONSTER) then
					local loc = tc:GetLocation()
					if loc ~= 0 then
						local fc = Duel.GetFirstMatchingCard(Card.IsCode, effect_tp, loc, 0, nil, id)
						if fc then
							if Duel.SelectYesNo(effect_tp, aux.Stringid(id, 2)) then
								local old_field = Duel.GetFieldCard(effect_tp, LOCATION_FZONE, 0)
								if old_field then Duel.SendtoGrave(old_field, REASON_RULE) end
								Duel.MoveToField(fc, effect_tp, effect_tp, LOCATION_FZONE, POS_FACEUP, true)
								return false 
							end
						end
					end
				end
			end
			return s._SpecialSummonStep(tc, sumtype, sumplayer, targetplayer, nocheck, nolimit, pos, zone)
		end
	end
end

-- === 效果① ===
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()
end

function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter, 1, nil, tp)
end

local SUMMON_TYPES_TABLE = {0, SUMMON_TYPE_FUSION, SUMMON_TYPE_SYNCHRO, SUMMON_TYPE_XYZ, SUMMON_TYPE_LINK, SUMMON_TYPE_SPECIAL, SUMMON_VALUE_SELF}

function s.sprule_filter(c)
	if not c:IsAttribute(ATTRIBUTE_WATER) then return false end
	for _,sumtype in pairs(SUMMON_TYPES_TABLE) do
		if c:IsSpecialSummonable(sumtype) and aux.NecroValleyFilter()(c) then return true end
	end
	return false
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1 = Duel.IsExistingMatchingCard(s.sprule_filter, tp, 0xff, 0, 1, nil)
	local b2 = Duel.GetFlagEffect(tp, id)==0 and Duel.CheckLPCost(tp, 500) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp, id+1, 0x613, TYPE_MONSTER+TYPE_TUNER, 0, 0, 1, RACE_AQUA, ATTRIBUTE_WATER)
		
	if chk==0 then return b1 or b2 end
	
	local op = 0
	if b1 and b2 then
		op = Duel.SelectOption(tp, aux.Stringid(id, 3), aux.Stringid(id, 4))
	elseif b1 then
		op = Duel.SelectOption(tp, aux.Stringid(id, 3))
	else
		op = Duel.SelectOption(tp, aux.Stringid(id, 4)) + 1
	end
	e:SetLabel(op)
	
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, 0)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
		Duel.RegisterFlagEffect(tp, id, RESET_PHASE+PHASE_END, 0, 1) 
		Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, 0)
		Duel.SetOperationInfo(0, CATEGORY_TOKEN, nil, 1, tp, 0)
	end
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local op = e:GetLabel()
	
	if op==0 then
		-- 规则特召
		local g = Duel.GetMatchingGroup(s.sprule_filter, tp, 0xff, 0, nil)
		if #g > 0 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
			local tc = g:Select(tp, 1, 1, nil):GetFirst()
			if tc then
				for _,sumtype in pairs(SUMMON_TYPES_TABLE) do
					if tc:IsSpecialSummonable(sumtype) then
						Duel.SpecialSummonRule(tp, tc, sumtype)
						break
					end
				end
			end
		end
	else
		-- 生Token
		if Duel.CheckLPCost(tp, 500) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 
			and Duel.IsPlayerCanSpecialSummonMonster(tp, 6100239, 0x613, TYPE_MONSTER+TYPE_TUNER, 0, 0, 1, RACE_AQUA, ATTRIBUTE_WATER) then
			Duel.PayLPCost(tp, 500)
			local token = Duel.CreateToken(tp, 6100239)
			Duel.SpecialSummon(token, 0, tp, tp, false, false, POS_FACEUP)
		end
	end
end

-- === 效果② ===
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_FZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_EFFECT)
end

function s.thfilter(c, e, tp)
	if not (c:IsSetCard(0x613) and c:IsType(TYPE_MONSTER) and not c:IsLevel(4)) then return false end
	return c:IsAbleToHand() or (Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and c:IsCanBeSpecialSummoned(e, 0, tp, false, false))
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_GRAVE+LOCATION_REMOVED, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_OPERATECARD)
	local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.thfilter), tp, LOCATION_GRAVE+LOCATION_REMOVED, 0, 1, 1, nil, e, tp)
	local tc = g:GetFirst()
	if tc then
		local b1 = tc:IsAbleToHand()
		local b2 = Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and tc:IsCanBeSpecialSummoned(e, 0, tp, false, false)
		local op = 0
		if b1 and b2 then
			op = Duel.SelectOption(tp, 1190, 1152) 
		elseif b1 then
			op = 0
		else
			op = 1
		end
		
		if op == 0 then
			Duel.SendtoHand(tc, nil, REASON_EFFECT)
			Duel.ConfirmCards(1-tp, tc)
		else
			Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
		end
	end
end