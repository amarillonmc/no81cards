--女王蜘蛛怪
if not pcall(function() require("expansions/script/c114500") end) then require("script/c114500") end
local m,cm = rscf.DefineCard(114510)
function cm.initial_effect(c)
	local e1 = rsef.QO(c,EVENT_CHAINING,"sp",{1,m},"sp","dsp",rsloc.hg,cm.spcon,nil,rsop.target(cm.spfilter,"sp"),cm.spop)
	local e2 = rsef.STO_Flip(c,"sp",{1,m+100},"sp","de",nil,nil,rsop.target(cm.spfilter2,"sp",LOCATION_DECK),cm.spop2)
	local e3,e4,e5,e6 = rsef.FV_Card(c,"fmat~,ssmat~,xsmat~,lsmat~",nil,nil,{0xff-LOCATION_ONFIELD,0xff-LOCATION_ONFIELD },"sa",LOCATION_MZONE,cm.lcon)
	local e7 = rsef.SC_Easy(c,EVENT_FLIP,"cd",nil,cm.regop)
end
function cm.regop(e,tp)
	e:GetHandler():RegisterFlagEffect(m,rsrst.std,0,1)
end
function cm.lcon(e,tp)
	return e:GetHandler():GetFlagEffect(m) > 0
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end 
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_FLIP)
end
function cm.spop(e,tp)
	local c = rscf.GetSelf(e)
	if c and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) > 0 then
		Duel.ConfirmCards(1-tp,c)
	end
end
function cm.spfilter2(c,e,tp)
	return c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_FLIP) and rscf.spfilter2()(c,e,tp) and not c:IsCode(m)
end
function cm.spop2(e,tp)
	rsop.SelectSpecialSummon(tp,cm.spfilter2,tp,LOCATION_DECK,0,1,1,nil,{},e,tp)
end