--焰之巫女的呼声
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40009756)
function cm.initial_effect(c)
	local e1 = rsef.A(c,nil,nil,{1,m},"sp,se,th,dd",nil,
		nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.act)
	local e2 =  aux.AddRitualProcGreater2(c,cm.ritfilter,LOCATION_HAND+LOCATION_GRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	rsfwh.ExtraRitualFun(c,e2,LOCATION_HAND+LOCATION_GRAVE,cm.ritfilter)
end
function cm.thfilter(c,e,tp)
	local b1 = c:IsCode(40009577) and rscf.spfilter2()(c,e,tp)
	local b2 = c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand()
	return b1 or b2
end
function cm.act(e,tp)
	local og,tc = rsop.SelectCards("th",tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if not tc then return end
	local b1 = tc:IsCode(40009577) and rscf.spfilter2()(tc,e,tp)
	local b2 = tc:IsRace(RACE_DRAGON) and tc:IsAttribute(ATTRIBUTE_FIRE) and tc:IsAbleToHand()
	if b1 and (not b2 or not rshint.SelectYesNo(tp,"th")) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)		
	end
end
function cm.ritfilter(c)
	return c:IsRace(RACE_DRAGON)
end