--惶恐之恶念体
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl.CreateFieldTriggerOptionalEffect(c, "BeSpecialSummoned",
		"Equip", nil, "Equip,NormalSummon", 
		"Target", "Hand,MonsterZone", s.eqcon, nil,
		{ "Target", "Equip", s.eqfilter, 0, "MonsterZone" }, s.eqop)
	--local e2 = Scl.CreateFieldTriggerContinousEffect(c, "Adjust", nil, nil, nil, "Spell&TrapZone", nil, s.bnop)
	local e3 = Scl.CreateFieldTriggerContinousEffect(c, "BeEffectTarget", nil, nil, nil, "Spell&TrapZone", s.bncon2, s.bnop2)
	local e4 = Scl.CreateFieldTriggerContinousEffect(c, "BeAttackTarget", nil, nil, nil, "Spell&TrapZone", s.bncon3, s.bnop2)
	local e5 = Scl.CreateFieldTriggerContinousEffect(c, "BeforeEffectResolving", nil, nil, nil, "Spell&TrapZone", s.bncon4, s.bnop2)
end
function s.cfilter(c,tp)
	return (c:IsSummonLocation(LOCATION_HAND) or c:IsSummonLocation(LOCATION_GRAVE) ) and c:IsSummonPlayer(1-tp)
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
function s.bnop(e,tp)
	local c = e:GetHandler()
	local ec = c:GetEquipTarget()
	if not ec then return end
	if ec:GetOwnerTargetCount()>0 then
		Scl.HintCard(id)
		Scl.AddSingleBuff({c,ec},"NegateEffect",1,"NegateActivatedEffect",1)
	end
end
function s.bncon2(e,tp,eg)
	local c = e:GetHandler()
	local ec = c:GetEquipTarget()
	return ec and eg:IsContains(ec)
end
function s.bnop2(e,tp,eg)
	local c = e:GetHandler()
	local ec = c:GetEquipTarget()
	if not ec then return end
	if not ec:IsDisabled() then
		Scl.HintCard(id)
	end
	Scl.AddSingleBuff({c,ec},"NegateEffect",1,"NegateActivatedEffect",1)
end
function s.bncon3(e,tp,eg)
	local c = e:GetHandler()
	local ec = c:GetEquipTarget()
	local bc = Duel.GetAttackTarget()
	return ec and bc and ec == bc
end
function s.bncon4(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local ec = c:GetEquipTarget()
	local tg = Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg and tg:IsContains(ec)
end