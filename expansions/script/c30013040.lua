--深土之物 来自深谷的侵染
if not pcall(function() require("expansions/script/c30000100") end) then require("script/c30000100") end
local m,cm = rscf.DefineCard(30013040)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1 = rsef.QO(c,EVENT_CHAINING,"dd",{75,m},"dd","dsp",
		LOCATION_HAND,cm.ddcon,rscost.cost(0,"dh"),
		rsop.target(5,"dd"),cm.ddop)
	local e2 = rsef.STO_Flip(c,"pos",{75,m+100},"pos","de",
		nil,nil,rsop.target(cm.posfilter,"pos",
		LOCATION_ONFIELD,LOCATION_ONFIELD),cm.posop)
	local e3 = rsef.FTO(c,EVENT_PHASE+PHASE_END,"dis",{1,m+200},
		"dis,se,th",nil,LOCATION_GRAVE,nil,rscost.cost(1,"dh"),
		rsop.target({aux.disfilter1,"dis",
		0,LOCATION_ONFIELD },
		{cm.thfilter,"th",rsloc.dg}),cm.thop)
	local e4 = rsef.RegisterOPTurn(c,e3,cm.qcon)
end
function cm.qcon(e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,30013020)
end
function cm.thfilter(c)
	return c:IsSetCard(0x92c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thop(e,tp)  
	local c = e:GetHandler()
	local og,tc = rsop.SelectCards("dis",tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	if not tc then return end
	local e1,e2 = rscf.QuickBuff({c,tc},"dis,dise","rst",{rsrst.std_ep,2})
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	Duel.BreakEffect()
	if not tc:IsDisabled() then return end
	rsop.SelectOperate("th",tp,cm.thfilter,tp,rsloc.dg,0,1,1,nil,{ })
end
function cm.posfilter(c)
	return c:IsCanTurnSet() and not c:IsComplexType(TYPE_SPELL+TYPE_PENDULUM)
end
function cm.posop(e,tp)
	local e1 = rscf.GetSelf(e)
	if rsop.SelectOperate("dpd",tp,cm.posfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil,{ }) <= 0 then return end
	local sg = Duel.GetOperatedGroup():Filter(Card.IsFacedown,nil)
	local sg2 = sg:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP) 
	if #sg2 > 0 then
		for tc in aux.Next(sg2) do 
			local e1 = rscf.QuickBuff({c,tc},"tri~","rst",{RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END,2})
		end
		Duel.RaiseEvent(sg2,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function cm.ddop(e,tp)
	Duel.DiscardDeck(tp,5,REASON_EFFECT)
end
function cm.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_FLIP)
end
