--万色的虚数姬
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(130002101)
function cm.initial_effect(c)
	local e1=rsef.I(c,{m,0},nil,"sp",nil,LOCATION_HAND,nil,rscost.reglabel(100),cm.sptg,cm.spop)
	local e2=rsef.QO(c,nil,{m,1},nil,"res,sp",nil,LOCATION_HAND,nil,nil,cm.linktg,cm.linkop)
	local e3=rsef.STO(c,EVENT_TO_DECK,{m,2},nil,"sp","de,dsp",cm.tdcon,nil,rsop.target(rscf.spfilter2(Card.IsType,TYPE_LINK),"sp",LOCATION_GRAVE),cm.tdop)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()==100 and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	e:SetLabel(0)
	local tc=rsop.SelectSolve(HINTMSG_CONFIRM,tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil,cm.sfun,e,tp)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.cfilter(c,e,tp)
	return not c:IsPublic() and c:IsRace(RACE_MACHINE+RACE_CYBERSE+RACE_PSYCHO) and rscf.spfilter2()(c,e,tp) and Duel.CheckLPCost(tp,c:GetLevel()*100)
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
	local att=0
	for tc in aux.Next(g) do
		att=att|tc:GetAttribute()
	end
	local ct=0
	while att~=0 do
		if att & 0x1 ~=0 then ct=ct+1 end
		att=bit.rshift(att,1)
	end
	return cm.spfilter(c,e,tp,g,ct) 
end
function cm.spfilter(c,e,tp,g,attct)
	return c:IsType(TYPE_LINK) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and c:GetLink()<=attct
end
function cm.linktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetReleaseGroup(tp,true)
	if chk==0 then return rg:CheckSubGroup(cm.gcheck,1,#rg,e,tp) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,rg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.linkop(e,tp)
	local rg=Duel.GetReleaseGroup(tp,true)
	rshint.Select(tp,"res")
	local rg2=rg:SelectSubGroup(tp,cm.gcheck,false,1,#rg,e,tp)
	if #rg2<=0 then return end
	local att=0
	for tc in aux.Next(rg2) do
		att=att|tc:GetAttribute()
	end
	local ct=0
	while att~=0 do
		if att & 0x1 ~=0 then ct=ct+1 end
		att=bit.rshift(att,1)
	end 
	if Duel.Release(rg2,REASON_EFFECT)<=0 then return end
	rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,{SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP,nil,{"cp"} },e,tp,nil,ct)
end
function cm.tdcon(e,tp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function cm.tdop(e,tp)
	rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(rscf.spfilter2(Card.IsType,TYPE_LINK)),tp,LOCATION_GRAVE,0,1,1,nil,{},e,tp)
end
