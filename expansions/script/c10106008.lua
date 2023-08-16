--惊惧之恶念体
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl.CreateFieldTriggerOptionalEffect(c, "BeSpecialSummoned",
		"Equip", nil, "Equip,NormalSummon", 
		"Target,Delay", "Hand,MonsterZone", s.eqcon, nil,
		{ "Target", "Equip", s.eqfilter, 0, "MonsterZone" }, s.eqop)
	local e2 = Scl.CreateFieldTriggerContinousEffect(c, "BeforeLeavingField",nil,nil,nil,"Spell&TrapZone",s.lfcon,s.lfop)
end
function s.cfilter(c,tp)
	return c:IsSummonPlayer(1-tp) and not c:GetReasonEffect():IsHasProperty(EFFECT_FLAG_UNCOPYABLE)
end
function s.eqcon(e,tp,eg)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.eqfilter(c,e,tp)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE) > 0 
end
function s.sumfilter(c)
	return c:IsSetCard(0x3338) and c:IsSummonable(true, nil)
end
function s.eqop(e,tp,eg)
	local _, c = Scl.GetActivateCard()
	local _, tc = Scl.GetTargetsReleate2Chain(Card.IsFaceup)
	if not c or not tc then return end
	if Scl.Equip(c, tc) > 0 then
		Scl.SetExtraSelectAndOperateParama("NormalSummon", true)
		local _,c = Scl.SelectCards("NormalSummon",tp,s.sumfilter,tp,"Hand,MonsterZone",0,1,1,nil)
		if c then
			Duel.Summon(tp,c,true,nil)
		end
	end
end
function s.lfcon(e,tp,eg)
	local c = e:GetHandler()
	local ec = c:GetEquipTarget()
	return ec and eg:IsContains(ec)
end
function s.lfop(e,tp)
	local c = e:GetHandler()
	local ec = c:GetEquipTarget()
	local eg = ec:GetEquipGroup()
	for tc in aux.Next(eg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_HAND)
		tc:RegisterEffect(e1,true)
	end
end