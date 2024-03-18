--美味诱惑 百江渚
Duel.LoadScript("c60152900.lua")
local s,id,o = GetID()
function s.initial_effect(c)
	local e1 = Scl.CreateIgnitionEffect(c, "Search", {1, id}, "Search,Add2Hand",
		nil, "Hand,MonsterZone", nil, { "Cost", Card.IsReleasable, "Tribute" },
		{"~Target", s.thfilter, "Add2Hand", "Deck"}, s.thop)
	local e2 = Scl.CreateQuickOptionalEffect(c, nil, {id, 1}, {1, id + 100}, nil, 
		nil, "GY", nil, aux.bfgcost, nil, s.buffop)
end
function s.thfilter(c)
	return not c:IsCode(id) and c:IsSetCard(0x6b29) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thop(e,tp)
	Scl.SelectAndOperateCards("Add2Hand",tp,s.thfilter,tp,"Deck",0,1,1,nil)()
end
function s.tg(e,c)
	return c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_NORMAL)
end
function s.buffop(e,tp)
	local c = e:GetHandler()
	local e1 = Scl.CreateFieldBuffEffect({c,tp}, "!BeEffectTarget", 1, s.tg, {"MonsterZone", 0}, nil, nil, RESET_EP_SCL)
	local e2 = Scl.CreateFieldBuffEffect({c,tp}, "!BeDestroyedByEffect", 1, s.tg, {"MonsterZone", 0}, nil, nil, RESET_EP_SCL)
	local e3 = Scl.CreateFieldBuffEffect({c,tp}, "!NegateEffect", 1, s.tg, {"MonsterZone", 0}, nil, nil, RESET_EP_SCL)
	local e4 = Scl.CreateEffectBuffEffect({c,tp}, "!NegateActivatedEffect", s.val, nil, nil, RESET_EP_SCL)
end
function s.val(e,ct)
	local p = e:GetHandler():GetControler()
	local te, tp, loc = Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc = te:GetHandler()
	return p == tp and loc & LOCATION_MZONE ~= 0 and s.tg(e, tc)
end