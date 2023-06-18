--焦躁之恶念体
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl.CreateFieldTriggerOptionalEffect(c, "BeSpecialSummoned",
		"Equip", nil, "Equip,NormalSummon", 
		"Target", "Hand,MonsterZone", s.eqcon, nil,
		{ "Target", "Equip", s.eqfilter, 0, "MonsterZone" }, s.eqop)
	local e2 = Scl.CreateFieldTriggerContinousEffect(c, "BeforeEffectResolving",
		nil, nil, nil, "Spell&TrapZone", s.drcon, s.drop)
	local e3 = Scl.CreateFieldTriggerContinousEffect(c, "NegateActivatedEffect",
		nil, nil, nil, "Spell&TrapZone", s.drcon, s.drop)
end
function s.cfilter(c,tp)
	return (c:IsSummonLocation(LOCATION_EXTRA) or c:IsSummonLocation(LOCATION_DECK) ) and c:IsSummonPlayer(1-tp) and c:IsType(TYPE_EFFECT)
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
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tc = e:GetHandler():GetEquipTarget()
	local re2=Duel.GetChainInfo(ev, CHAININFO_TRIGGERING_EFFECT)
	return tc and re2:GetHandler() == tc
end
function s.drop(e,tp)
	Scl.HintCard(id)
	Duel.Draw(tp,1,REASON_EFFECT)
	--Duel.Draw(1-tp,1,REASON_EFFECT)
	--local c = e:GetHandler()
	--local e1,e2 = Scl.CreatePlayerBuffEffect({c,tp}, "!Normal&SpecialSummon",1,aux.TargetBoolFunction(Card.IsSetCard,0x3338),nil,nil,{RESET_EP_SCL,2})
end