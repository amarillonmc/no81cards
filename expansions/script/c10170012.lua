--
if not pcall(function() require("expansions/script/c10170001") end) then require("script/c10170001") end
local m=10170012
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rssp.ActivateFun(c,m,"ga,th,sp","dis",cm.fun,cm.op)
end
function cm.fun(e,tp,...)
	local g1=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	local g2=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	local b1={ "sp","sp",PLAYER_ALL,LOCATION_GRAVE }
	local b2={ "sp","sp",PLAYER_ALL,LOCATION_GRAVE }
	return g1,g2,b1,b2
end
function cm.op(op,g,e,tp)
	if op==1 then
		rssf.SpecialSummon(g)
	else
		local tc=g:GetFirst()
		local e1=rsef.SV_CHANGE({tc,true},"type,lv",{TYPE_NORMAL+TYPE_MONSTER,1},nil,0x47c0000,"cd")
		local e2,e3=rsef.SV_SET({tc,true},"batk,bdef",{0,2300},nil,0x47c0000,"cd")
		local e4=rsef.RegisterClone({tc,true},e1,"code",EFFECT_REMOVE_RACE,"value",RACE_ALL)
		local e5=rsef.RegisterClone({tc,true},e1,"code",EFFECT_REMOVE_ATTRIBUTE,"value",0xff)
		Duel.SpecialSummon(tc,181,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spfilter2(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,0x11,0,0,1,0,0,POS_FACEUP_DEFENSE,tp,181) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
