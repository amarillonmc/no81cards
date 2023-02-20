--焰之巫女的呼声
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40009756,"BlazeMaiden")
function cm.initial_effect(c)
	local e1 = rsef.A(c,nil,nil,{1,m},"sp,se,th,dd",nil,
		nil,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.act)
	e1:SetCost(cm.thcost)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)
	local e2 =  aux.AddRitualProcGreater2(c,cm.ritfilter,LOCATION_HAND+LOCATION_GRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	rsfwh.ExtraRitualFun(c,e2,LOCATION_HAND+LOCATION_GRAVE,cm.ritfilter)
end
function cm.counterfilter(c)
	return (c:IsRace(RACE_DRAGON) and c:IsType(TYPE_RITUAL)) or c:CheckSetCard("BlazeMaiden","Vairina")
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0
		and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
end
function cm.splimit(e,c)
	return not ((c:IsRace(RACE_DRAGON) and c:IsType(TYPE_RITUAL)) or c:CheckSetCard("BlazeMaiden","Vairina"))
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
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_RITUAL)
end