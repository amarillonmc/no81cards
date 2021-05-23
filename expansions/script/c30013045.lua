--深土之物 斜纹刃刺龙
if not pcall(function() require("expansions/script/c30000100") end) then require("script/c30000100") end
local m,cm = rscf.DefineCard(30013045)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1 = rsef.FTO(c,EVENT_LEAVE_FIELD,"sp",{75,m},"sp","dsp",
		LOCATION_HAND,nil,rscost.cost(0,"dh"),
		rsop.target3(cm.check,cm.spfilter,"sp",true,true,true),
		cm.spop)
	local e2 = rsef.STO_Flip(c,"sset",{75,m+100},"pos","de",
		aux.NOT(cm.qcon),nil,nil,cm.setop)
	local e3 = rsef.STO_Flip(c,"sset",{75,m+100},"pos","de",
		cm.qcon,nil,
		rsop.target(cm.setfilter,"sset",LOCATION_GRAVE,LOCATION_GRAVE),
		cm.setop)
	local e4 = rsef.FTO(c,EVENT_PHASE+PHASE_END,"th",{1,m+200},"th",
		nil,LOCATION_GRAVE,nil,rscost.cost(1,"dh"),
		rsop.target(cm.thfilter,"th",LOCATION_GRAVE),cm.thop)
	local e5 = rsef.RegisterOPTurn(c,e4,cm.qcon)
end
function cm.thfilter(c)
	return c:IsSetCard(0x92c) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectOperate("th",tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,2,nil,{})
end
function cm.setfilter(c,e,tp)
	return c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.GetLocationCount(tp,LOCATION_SZONE) > 0 
end
function cm.setop(e,tp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() and rshint.SelectYesNo(tp,"pos") then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end  
	if not cm.qcon(e,tp) then
		local e1 = rsef.FC({c,tp},EVENT_PHASE+PHASE_END,nil,1,nil,nil,cm.setcon2,cm.setop2,rsrst.ep)
	else
		cm.setop2(e,tp)
	end
end
function cm.setcon2(e,tp)
	return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp)
end
function cm.setop2(e,tp)
	rshint.Card(m)
	local ct, og ,tc = rsop.SelectOperate("sset",tp,aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,{},e,tp)
	if not tc or not tc:IsSetCard(0x92c) or not tc:IsType(TYPE_TRAP) then return end
	local e1 = rscf.QuickBuff({e:GetHandler(),tc},"tas")
end
function cm.qcon(e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,30013020)
end
function cm.check(e,tp,eg)
	local ct = eg:FilterCount(cm.spfilter,nil,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE) >= ct and (ct <= 1 or not rssf.CheckBlueEyesSpiritDragon(tp))
end
function cm.spfilter(c,e,tp)
	return c:GetReasonPlayer() ~= tp and (c:IsPreviousComplexType(TYPE_FLIP) or c:IsPreviousPosition(POS_FACEDOWN)) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and not c:IsLocation(LOCATION_DECK) and (not c:IsLocation(LOCATION_EXTRA) or c:IsFaceup())
end
function cm.spop(e,tp,eg)
	local sg = eg:Filter(Card.IsRelateToEffect,nil,e):Filter(cm.spfilter,nil,e,tp)
	if #sg <= 0 then return end
	local ft = Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft < #sg or (#sg >= 2 and rssf.CheckBlueEyesSpiritDragon(tp)) then return end
	Duel.HintSelection(sg)
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) > 0 then
		Duel.ConfirmCards(1-tp,sg)
	end
end