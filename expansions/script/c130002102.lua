--万色的天狱姬
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(130002102)
function cm.initial_effect(c)
	local e1=rsef.I(c,{m,0},nil,"sp",nil,LOCATION_HAND,nil,rscost.reglabel(100),cm.sptg,cm.spop)
	local e2=rsef.QO(c,nil,{m,1},nil,"res,sp",nil,LOCATION_HAND,nil,nil,cm.syntg,cm.synop)
	local e3=rsef.STO(c,EVENT_TO_DECK,{m,2},nil,"sp","de,dsp",cm.tdcon,nil,rsop.target(rscf.spfilter2(Card.IsType,TYPE_SYNCHRO+TYPE_FUSION+TYPE_XYZ),"sp",LOCATION_GRAVE),cm.tdop)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()==100 and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	e:SetLabel(0)
	local tc=rsop.SelectSolve(HINTMSG_CONFIRM,tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil,cm.sfun,e,tp)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.cfilter(c,e,tp)
	return not c:IsPublic() and c:IsRace(RACE_THUNDER+RACE_AQUA+RACE_PYRO+RACE_ROCK) and rscf.spfilter2()(c,e,tp) and Duel.CheckLPCost(tp,c:GetLevel()*100)
end
function cm.sfun(g,e,tp)
	local tc=g:GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.PayLPCost(tp,tc:GetLevel()*100)
	return tc
end
function cm.spop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then
		rssf.SpecialSummon(tc)
	end
end
function cm.gcheck(g,e,tp)
	return Duel.IsExistingMatchingCard(cm.linkfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
end
function cm.linkfilter(c,e,tp,g)
	local race=0
	for tc in aux.Next(g) do
		race=race|tc:GetRace()
	end
	local ct=0
	while race~=0 do
		if race & 0x1 ~=0 then ct=ct+1 end
		race=bit.rshift(race,1)
	end
	return cm.spfilter(c,e,tp,g,ct) 
end
function cm.spfilter(c,e,tp,g,racect)
	local typelist={ TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ }
	local mustlist={EFFECT_MUST_BE_FMATERIAL,EFFECT_MUST_BE_SMATERIAL,EFFECT_MUST_BE_XMATERIAL }
	local sumlist={SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ }
	local lvlist={Card.GetLevel,Card.GetLevel,Card.GetRank}
	for index, ctype in pairs(typelist) do 
		if c:IsType(ctype) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and aux.MustMaterialCheck(nil,tp,mustlist[index]) and c:IsCanBeSpecialSummoned(e,sumlist[index],tp,false,false) and lvlist[index](c)<=racect then return true end
	end
	return false
end
function cm.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetReleaseGroup(tp,true)
	if chk==0 then return rg:CheckSubGroup(cm.gcheck,1,#rg,e,tp) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,rg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.synop(e,tp)
	local rg=Duel.GetReleaseGroup(tp,true)
	rshint.Select(tp,"res")
	local rg2=rg:SelectSubGroup(tp,cm.gcheck,false,1,#rg,e,tp)
	if #rg2<=0 then return end
	local race=0
	for tc in aux.Next(rg2) do
		race=race|tc:GetRace()
	end
	local ct=0
	while race~=0 do
		if race & 0x1 ~=0 then ct=ct+1 end
		race=bit.rshift(race,1)
	end 
	if Duel.Release(rg2,REASON_EFFECT)<=0 then return end
	rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,{SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP,nil,{"cp"} },e,tp,nil,ct)
end
function cm.tdcon(e,tp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function cm.tdop(e,tp)
	rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(rscf.spfilter2(Card.IsType,TYPE_SYNCHRO+TYPE_FUSION+TYPE_XYZ)),tp,LOCATION_GRAVE,0,1,1,nil,{},e,tp)
end