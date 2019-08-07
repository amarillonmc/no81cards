--界限龙 努特
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10103001
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_HAND+LOCATION_MZONE,nil,nil,rstg.target(rsop.list(cm.xyzfilter,"sp",LOCATION_EXTRA)),cm.xyzop)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+100},"sp","de",nil,nil,rstg.target(rsop.list(cm.spfilter,"sp",LOCATION_HAND+LOCATION_GRAVE)),rsop.operation(aux.NecroValleyFilter(cm.spfilter),"sp",LOCATION_HAND+LOCATION_GRAVE))
	cm.rs_ghostdom_dragon_effect={e1,e2}
end
function cm.matfilter(c)
	return c:IsRace(RACE_DRAGON) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function cm.xyzfilter(xyzc,e,tp)
	if not xyzc:IsType(TYPE_XYZ) then return false end
	local matc=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	return mg:IsContains(matc) and mg:CheckSubGroup(cm.xyzfilter2,1,#mg,xyzc,matc)
end
function cm.xyzfilter2(g,xyzc,matc)
	return g:IsContains(matc) and xyzc:IsXyzSummonable(g,#g,#g)
end
function cm.xyzop(e,tp) 
	local c=aux.ExceptThisCard(e)
	if not c then return end
	rsof.SelectHint(tp,"sp")
	local xyzc=Duel.SelectMatchingCard(tp,cm.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if not xyzc then return end
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	Duel.SetSelectedCard(c)
	rsof.SelectHint(tp,HINTMSG_XMATERIAL)
	local mat=mg:SelectSubGroup(tp,cm.xyzfilter2,false,1,#mg,xyzc,c)
	Duel.XyzSummon(tp,xyzc,mat)
	if mat:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) then
		Duel.ShuffleHand(tp)
	end
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsSetCard(0x337) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end