--Library for Player Couners
--Scripted by: XGlitchy30
if PLAYER_COUNTER_LIB_LOADED then return end

PLAYER_COUNTER_LIB_LOADED = true
PLAYER_COUNTER_FLAG			= 33720383
PLAYER_COUNTER_COUNT_FLAG	= 33720384

--Custom Categories
CATEGORY_PLAYER_COUNTER	=	0x1

--Player Counters
PLAYER_COUNTER_HEAT	=	0x1

PLAYER_COUNTERS_TABLE = {}

function Auxiliary.GetPlayerCounterDescription(counter)
	return aux.Stringid(table.unpack(PLAYER_COUNTERS_TABLE[counter]))
end
function Auxiliary.GetPlayerCounterOwner(counter)
	return PLAYER_COUNTERS_TABLE[counter][1]
end

--Functions
function Duel.GetPlayerCounter(p)
	if not Duel.PlayerHasFlagEffect(p,PLAYER_COUNTER_FLAG) then return end
	local counters,descs={},{}
	for _,label in ipairs({Duel.GetFlagEffectLabel(p,PLAYER_COUNTER_FLAG)}) do
		local desc=aux.GetPlayerCounterDescription(label)
		if not aux.FindInTable(descs,desc) then
			table.insert(counters,label)
			table.insert(descs,desc)
		end
	end
	local opt=Duel.SelectOption(p,table.unpack(descs))+1
	local counter=counters[opt]
	return counter, PLAYER_COUNTERS_TABLE[counter][1]
end

function Duel.GetPlayerCounterCount(p,counter)
	if not Duel.PlayerHasFlagEffect(p,PLAYER_COUNTER_FLAG) then return 0 end
	if not counter then
		return Duel.GetFlagEffect(p,PLAYER_COUNTER_FLAG)
	else
		local ct=0
		for _,label in ipairs({Duel.GetFlagEffectLabel(p,PLAYER_COUNTER_FLAG)}) do
			if label==counter then
				ct=ct+1
			end
		end
		return ct
	end
end
function Duel.IsCanAddPlayerCounter(p,counter,ct,e,tp,r)
	return true	--placeholder
end
function Duel.IsCanRemovePlayerCounter(p,counter,ct,e,tp,r)
	return Duel.GetPlayerCounterCount(p,counter)>=ct --placeholder
end

aux.TempAddedPlayerCounterCount = 0
function Duel.AddPlayerCounter(p,counter,ct,e,tp,r)
	if not Duel.IsCanAddPlayerCounter(p,counter,ct,e,tp,r) then return 0 end
	local ct0=Duel.GetPlayerCounterCount(p,counter)
	if Duel.PlayerHasFlagEffectLabel(p,PLAYER_COUNTER_COUNT_FLAG,counter) then
		for _,fe in ipairs({Duel.IsPlayerAffectedByEffect(p,PLAYER_COUNTER_COUNT_FLAG|EFFECT_FLAG_EFFECT)}) do
			if fe:GetLabel()==counter then
				fe:Reset()
			end
		end
	end

	for i=1,ct do
		Duel.RegisterFlagEffect(p,PLAYER_COUNTER_FLAG,0,0,1,counter)
	end
	
	local ct1=Duel.GetPlayerCounterCount(p,counter)
	if ct1>0 then
		local fe=Duel.RegisterFlagEffect(p,PLAYER_COUNTER_COUNT_FLAG,0,EFFECT_FLAG_CLIENT_HINT,1,counter)
		local fe2=fe:Clone()
		fe2:SetDescription(aux.GetPlayerCounterDescription(counter)+math.min(5,ct1-1))
		Duel.RegisterEffect(fe2,p)
		fe:Reset()
	end
	return math.max(0,ct1-ct0)
end

function Duel.RemovePlayerCounter(p,counter,ct,e,tp,r)
	if not Duel.IsCanRemovePlayerCounter(p,counter,ct,e,tp,r) then return 0 end
	local ct0=Duel.GetPlayerCounterCount(p,counter)
	if Duel.PlayerHasFlagEffectLabel(p,PLAYER_COUNTER_COUNT_FLAG,counter) then
		for _,fe in ipairs({Duel.IsPlayerAffectedByEffect(p,PLAYER_COUNTER_COUNT_FLAG|EFFECT_FLAG_EFFECT)}) do
			if fe:GetLabel()==counter then
				fe:Reset()
			end
		end
	end
	
	Duel.GetFlagEffectWithSpecificLabel(p,PLAYER_COUNTER_FLAG,counter,true)
	local x=ct0-ct
	if x>0 then
		for i=1,x do
			Duel.RegisterFlagEffect(p,PLAYER_COUNTER_FLAG,0,0,1,counter)
		end
	end
	
	local ct1=Duel.GetPlayerCounterCount(p,counter)
	if ct1>0 then
		local fe=Duel.RegisterFlagEffect(p,PLAYER_COUNTER_COUNT_FLAG,0,EFFECT_FLAG_CLIENT_HINT,1,counter)
		local fe2=fe:Clone()
		fe2:SetDescription(aux.GetPlayerCounterDescription(counter)+math.min(5,ct1-1))
		Duel.RegisterEffect(fe2,p)
		fe:Reset()
	end
	return math.max(0,ct1-ct0)
end