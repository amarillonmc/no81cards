--深土之下的护卫 森之徘徊者
if not pcall(function() require("expansions/script/c30000100") end) then require("script/c30000100") end
local m,cm = rscf.DefineCard(30013035)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_FLIP),aux.FilterBoolFunction(Card.IsFusionSetCard,0x92c),2,true)
	local e1 = rsef.I(c,"td",{1},"td,rec",nil,LOCATION_MZONE,nil,
		nil,rsop.target(Card.IsAbleToDeck,"td",rsloc.gr,rsloc.gr),cm.tdop)
	local e2 = rsef.RegisterOPTurn(c,e1,cm.qcon)
	local e3 = rsef.STO_Flip(c,"th",{75,m+100},"se,th,res","de",
		aux.NOT(cm.qcon),nil,
		rsop.target({cm.thfilter,"th",rsloc.dg},
		{Card.IsReleasableByEffect,"res",rsloc.ho}),cm.thop)
	local e4 = rsef.STO_Flip(c,"th",{75,m+100},"se,th,res","de",
		cm.qcon,nil,
		rsop.target({cm.thfilter,"th",rsloc.dg},
		{Card.IsReleasableByEffect,"res",rsloc.ho},{Card.IsAbleToHand,"th",LOCATION_ONFIELD,LOCATION_ONFIELD }),cm.thop)
	local e5 = rsef.FTO(c,EVENT_PHASE+PHASE_END,"sp",{1,m+200},"sp",nil,
		LOCATION_GRAVE,cm.spcon,rscost.cost(1,"dh"),
		rsop.target(cm.spfilter,"sp",LOCATION_GRAVE),cm.spop)
	local e6 = rsef.RegisterOPTurn(c,e5,cm.qcon)
end
function cm.spcon(e,tp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.spop(e,tp)
	local spct = (cm.qcon(e,tp) and not rssf.CheckBlueEyesSpiritDragon(tp)) and 2 or 1
	local ft = Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft <= 0 then return end
	spct = math.min(spct, ft)
	local ct,og = rsop.SelectOperate("sp",tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,spct,nil,{0,tp,tp,false,false,POS_FACEDOWN_DEFENSE },e,tp)
	if ct > 0 then
		Duel.ConfirmCards(1-tp,og)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_FLIP)
end
function cm.thop(e,tp)
	if rsop.SelectOperate("th",tp,cm.thfilter,tp,rsloc.dg,0,1,1,nil,{}) > 0 and rsop.CheckOperateCorrectly(LOCATION_HAND) and rsop.SelectOperate("res",tp,Card.IsReleasableByEffect,tp,rsloc.ho,0,1,2,nil,{}) > 0 then 
		local ct = Duel.GetOperatedGroup():FilterCount(Card.IsType,nil,TYPE_FLIP)
		if ct >= 2 then
			if not cm.qcon(e,tp) then
				local e1 = rsef.FC({e:GetHandler(),tp},EVENT_PHASE+PHASE_END,nil,1,nil,nil,cm.thcon2,cm.thop2,rsrst.ep)
			else
				cm.thop2(e,tp)
			end
		end
	end
end
function cm.thcon2(e,tp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function cm.thop2(e,tp)
	rshint.Card(m)
	local ct = cm.qcon(e,tp) and 2 or 1
	rsop.SelectOperate("th",tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil,{})
end
function cm.qcon(e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,30013020)
end
function cm.tdop(e,tp)
	if rsop.SelectOperate("td",tp,Card.IsAbleToDeck,tp,rsloc.gr,rsloc.gr,1,5,nil,{}) <= 0 then return end
	local ct = rsop.GetOperatedCorrectlyCount(rsloc.de)
	if ct > 0 then
		Duel.BreakEffect()
		Duel.Recover(tp,ct * 600, REASON_EFFECT)
	end
end
