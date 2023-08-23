--自负之恶念体
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl.CreateQuickOptionalEffect(c, "ActivateEffect", "Equip", {1, "Chain"}, 
		"Equip", "Target", "Hand,MonsterZone", s.eqcon, nil, 
		s.eqtg, s.eqop)
	local e2 = Scl.CreateFieldTriggerContinousEffect(c, "BeforeEffectResolving", nil, nil, nil, "Spell&TrapZone", s.cecon, s.ceop)
	--[[local e1 = Scl.CreateQ(c, "BeSpecialSummoned",
		"Equip", nil, "Equip", 
		"Delay", "Hand,MonsterZone", s.eqcon, nil,
		{ "~Target", "Equip", s.eqfilter, true }, s.eqop)
	local e2 = Scl.CreateEquipBuffEffect(c, "+ATK", 800)
	local e3,e4 = Scl.CreateEquipBuffEffect(c, 
		"NegateEffect,NegateActivatedEffect", 1)
	--]]
	local e5,e6 = Scl.CreateSingleTriggerOptionalEffect(c, "BeNormalSummoned,BeAdded2Hand", 
		"Draw", nil, "Draw,ShuffleIn2Deck", "Delay", nil, 
		nil, { "PlayerTarget", "Draw", 1 }, s.drop)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3338)
end
function s.eqcon(e,tp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) 
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc = re:GetHandler()
	if chk == 0 then 
		return rc:IsFaceup() and rc:IsCanBeEffectTarget(e) and rc:IsSummonType(SUMMON_TYPE_SPECIAL) and re:IsActiveType(TYPE_MONSTER) and rc:IsLocation(LOCATION_MZONE) and rp ~= tp and rc:IsRelateToChain(ev) and Duel.GetLocationCount(tp,LOCATION_SZONE) > 0 
	end
	Duel.SetTargetCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.eqfilter(c,e,tp)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsSummonPlayer(1-tp) and Duel.GetLocationCount(tp,LOCATION_SZONE) > 0
end
function s.egfilter(c)
	return c:IsRelateToChain() and c:IsFaceup()
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local _, rc = Scl.GetTargetsReleate2Chain(Card.IsFaceup)
	local _,c = Scl.GetActivateCard()
	if rc and c then
		Scl.Equip(c, rc)
	end
end
function s.cecon(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	return re:GetHandler():GetEquipGroup():IsContains(c)
end
function s.ceop(e,tp,eg,ep,ev,re,r,rp)
	Scl.HintCard(id)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.rep_op)
end
function s.rep_op(e,tp)
	local c = e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Scl.AddSingleBuff2Self(c, "+ATK", 800, "Reset", RESETS_SCL)
	end
end
function s.rvfilter(c)
	return not c:IsPublic()
end
function s.drop(e,tp)
	if Duel.Draw(tp,1,REASON_EFFECT) > 0 then
		Scl.SetExtraSelectAndOperateParama(nil,true)
		Scl.SelectAndOperateCards("ShuffleIn2Deck",tp,Card.IsAbleToDeck,tp,"Hand,OnField",0,1,1,nil)()
	end
end