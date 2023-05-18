--自私之恶念体
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl.CreateFieldTriggerOptionalEffect(c, "BeSpecialSummoned",
		"Equip", nil, "Equip", 
		"Target", "Hand,MonsterZone", s.eqcon, nil,
		{ "Target", "Equip", s.eqfilter, true }, s.eqop)
	local e2 = Scl.CreateEquipBuffEffect(c, 
		"!BeUsedAsMaterial4SpecialSummon", 1)
	local e3 = Scl.CreateFieldBuffEffect(c, "!BeTributed", 1, 
		s.tg, {0, 1}, "Spell&TrapZone")
	local e4,e5 = Scl.CreateSingleTriggerOptionalEffect(c, "BeNormalSummoned,BeAdded2Hand", 
		"AddFromDeck2Hand", nil, "AddFromDeck2Hand", "Delay", nil, 
		nil, s.thtg, s.thop)  
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3338)
end
function s.eqcon(e,tp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function s.eqfilter(c,e,tp)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsSummonPlayer(1-tp) and Duel.GetLocationCount(tp,LOCATION_SZONE) > 0
end
function s.egfilter(c)
	return c:IsRelateToChain() and c:IsFaceup()
end
function s.eqop(e,tp,eg)
	local _, tc = Scl.GetTargetsReleate2Chain(Card.IsFaceup)
	local _, c = Scl.GetActivateCard()
	if not tc or not c then return end
	Scl.Equip(c, tc)
end
function s.tg(e,c)
	local ec = e:GetHandler():GetEquipTarget() 
	return ec and ec == c
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g = Duel.GetDecktopGroup(1-tp,1)
	if chk == 0 then return #g > 0 and g:GetFirst():IsAbleToHand(tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function s.thop(e,tp)
	local c = e:GetHandler()
	local g = Duel.GetDecktopGroup(1-tp,1)
	if #g == 0 then return end
	local tc = g:GetFirst()
	if Duel.SendtoHand(g,tp,REASON_EFFECT) <= 0 or not tc:IsLocation(LOCATION_HAND) then return end
	Scl.AddSingleBuff({c,tc},"Reveal",1)
	Scl.CreateFieldTriggerContinousEffect_PhaseOpearte({c,tp},tc,"BanishFacedown",nil, nil, PHASE_END)
end