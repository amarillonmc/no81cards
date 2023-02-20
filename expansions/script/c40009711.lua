--焰之巫女 米玲
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40009711,"BlazeMaiden")
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),3,2,nil,nil,99)
	c:EnableReviveLimit()
	local e1 = rsef.SV_Card(c,"ormat",1,"sr",LOCATION_MZONE)
	local e2 = rsef.STO(c,EVENT_SPSUMMON_SUCCESS,"tf",{1,m},nil,"de,tg",
		rscon.sumtyps("xyz"),nil,
		rstg.target(cm.tffilter,"tf",LOCATION_GRAVE),cm.tfop)
	local e3 = rsef.STO(c,EVENT_SPSUMMON_SUCCESS,"th",{1,m},"se,th","de",
		rscon.sumtyps("xyz"),nil,
		rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	local e4 = rsef.FTF(c,EVENT_PHASE+PHASE_END,"tf",nil,"tg",nil,
		LOCATION_MZONE,cm.tgcon,nil,
		rsop.target({Card.IsAbleToGrave,"tg"},
		{cm.tffilter,"tf",LOCATION_GRAVE }),cm.tgop)
end
function cm.tgcon(e,tp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.tgop(e,tp)
	local c = rscf.GetSelf(e)
	if not c or Duel.SendtoGrave(c,REASON_EFFECT) <= 0 or not c:IsLocation(LOCATION_GRAVE) then return end
	rsop.SelectOperate("tf",tp,aux.NecroValleyFilter(cm.tffilter),tp,LOCATION_GRAVE,0,1,1,nil,{},e,tp)
end
function cm.tffilter(c,e,tp)
	return c:CheckSetCard("BlazeTalisman") and c:IsComplexType(TYPE_SPELL+TYPE_CONTINUOUS) and not c:IsForbidden() and Duel.GetLocationCount(tp,LOCATION_SZONE) > 0
end
function cm.tfop(e,tp)
	local tc = rscf.GetTargetCard()
	if not tc or Duel.GetLocationCount(tp,LOCATION_SZONE) <= 0 then return end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function cm.thfilter(c)
	return c:CheckSetCard("BlazeMaiden") and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsop.SelectOperate("th",tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
end