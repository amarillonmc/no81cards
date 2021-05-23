--深土之下
if not pcall(function() require("expansions/script/c30000100") end) then require("script/c30000100") end
local m,cm = rscf.DefineCard(30013025)
function cm.initial_effect(c)
	local e1 = rsef.A(c)
	local e2 = rsef.FV_Card(c,"def+",cm.dval,aux.TargetBoolFunction(
		Card.IsType,TYPE_FLIP),{LOCATION_MZONE,0},nil,LOCATION_FZONE)
	local e3 = rsef.FV_Player(c,"rm~",1,cm.rmtg,{0,1},"sa",
		LOCATION_FZONE)
	local e4 = rsef.FC(c,EVENT_CHAIN_NEGATED,nil,nil,nil,LOCATION_FZONE,
		cm.drcon,cm.drop)
	local e5 = rsef.FC(c,EVENT_CHAIN_DISABLED,nil,nil,nil,LOCATION_FZONE,
		cm.drcon,cm.drop)
	local e6 = rsef.FC(c,EVENT_DESTROYED,nil,nil,nil,LOCATION_FZONE,
		cm.drcon2,cm.drop)
	local e7 = rsef.QO_NegateEffect(c,nil,{1,m},LOCATION_GRAVE,
		cm.discon,rscost.cost(Card.IsAbleToDeckAsCost,"td"),
		"pos",nil,nil,cm.exop)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp == tp or ev < 2 then return false end
	local re2,rp2 = Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return rp ~= tp and ev >= 2 and rp2 == tp and (re2:GetHandler():IsSetCard(0x92c) or re2:IsActiveType(TYPE_FLIP)) and Duel.IsChainDisablable(ev)
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk ~= 1 then return end
	rsop.SelectExPara("pos",true)
	rsop.SelectOperate("posd",tp,cm.pfilter,tp,LOCATION_MZONE,0,1,1,nil,{})
end
function cm.pfilter(c)
	return c:IsCanTurnSet() or (c:IsCanChangePosition() and (c:IsAttackPos() or c:IsFacedown()))
end
function cm.cfilter(c)
	return c:FieldPosCheck() and c:IsType(TYPE_FLIP)
end
function cm.dval(e,c)
	local g = Duel.GetMatchingGroup(cm.cfilter,0,rsloc.mg,rsloc.mg,nil)
	return g:GetClassCount(Card.GetCode) * 200
end
function cm.rmtg(e,c)
	return (c:IsFacedown() or c:IsType(TYPE_FLIP) or c == e:GetHandler() or c:IsSetCard(0x92c) ) and c:IsControler(e:GetHandlerPlayer())
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local rc = re:GetHandler()
	--local dp=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER)
	return rc:IsType(TYPE_FLIP) and ep == tp
end
function cm.drop(e,tp)
	rshint.Card(m)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.drcon2(e,tp,eg)
	return eg:IsExists(cm.desfilter,1,nil,tp)
end
function cm.desfilter(c,tp)
	return c:IsType(TYPE_FLIP) and c:IsPreviousControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end