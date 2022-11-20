--两极对峙
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10151001)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"sp","tg",nil,nil,rstg.target2(cm.fun,cm.tgfilter,"dum",LOCATION_MZONE,LOCATION_MZONE),cm.act)
end
function cm.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsDefenseAbove(0) and c:IsType(rscf.extype) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function cm.spfilter(c,e,tp,rc)
	local sp=1-rc:GetControler()
	for _,ctype in pairs(rscf.exlist_p) do
		if rc:IsType(ctype) and c:IsType(ctype) then return false end
	end
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,sp) and Duel.GetLocationCountFromEx(sp,tp,nil,c,0x1f)>0 and c:IsType(rscf.extype) and c:IsRace(rc:GetRace()) and c:IsDefense(rc:GetDefense()) 
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.act(e,tp)
	local c=aux.ExceptThisCard(e)
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if not tc then return end
	local ct,og,sc=rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,{0,tp,1-tc:GetControler(),false,false,POS_FACEUP,0x1f },e,tp,tc)
	if sc and sc:IsType(TYPE_XYZ) and c and not sc:IsImmuneToEffect(e) then
		c:CancelToGrave()
		Duel.Overlay(sc,Group.FromCards(c))
	end
end