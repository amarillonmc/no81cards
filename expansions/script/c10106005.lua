--自卑之恶念体
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl.CreateFieldTriggerOptionalEffect(c, "DeclareAttack",
		"Equip", nil, "Equip", 
		"Target", "Hand,MonsterZone", s.eqcon, nil, s.eqtg, s.eqop)
	local e2 = Scl.CreateEquipBuffEffect(c, "!Attack", 1)
	local e3,e4 = Scl.CreateEquipBuffEffect(c, 
		"=ATK,=DEF", 0)
	local e5,e6 = Scl.CreateSingleTriggerOptionalEffect(c, "BeNormalSummoned,BeAdded2Hand", 
		{id, 0}, nil, nil, "Delay", nil, nil, nil, s.drop)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3338)
end
function s.eqcon(e,tp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function s.eqfilter(c,e,tp)
	return c:IsControler(1-tp) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsCanBeEffectTarget(e)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc1,bc2 = Duel.GetBattleMonster(tp)
	local g = Scl.Mix2Group(bc1,bc2)
	local sg = g:Filter(s.eqfilter,nil,e,tp)
	if chk == 0 then return #sg > 0 and Duel.GetLocationCount(tp,LOCATION_SZONE) > 0 end
	local tc = sg:GetFirst()
	if #sg > 1 then
		Scl.HintSelect(tp, "Opponent")
		tc = sg:Select(tp,1,1,nil):GetFirst()
	end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.eqop(e,tp,eg)
	local _, tc = Scl.GetTargetsReleate2Chain(Card.IsFaceup)
	local _, c = Scl.GetActivateCard()
	if not tc or not c then return end
	Scl.Equip(c, tc)
end
function s.drop(e,tp)
	Duel.RegisterFlagEffect(tp,id,RESET_EP_SCL,0,1)
	if s.buff then return end
	s.buff = true
	local c = e:GetHandler()
	Scl.CreateFieldBuffEffect({c,tp},"+ATK,+DEF",s.val1,s.limtg,{0, "MonsterZone"},nil, nil, RESET_EP_SCL)
	Scl.CreateFieldBuffEffect({c,tp},"+Level",s.val2,s.limtg,{0, "MonsterZone"},nil, nil, RESET_EP_SCL)
end
function s.val1(e,c)
	local ct = Duel.GetFlagEffect(e:GetHandlerPlayer(), id)
	return ct * -800
end
function s.val2(e,c)
	local ct = Duel.GetFlagEffect(e:GetHandlerPlayer(), id)
	return ct * -1
end
function s.limtg(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
