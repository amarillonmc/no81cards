--超古代生物 齐杰拉
if not pcall(function() require("expansions/script/c25000024") end) then require("script/c25000024") end
local m,cm=rscf.DefineCard(25000030)
function cm.initial_effect(c)
	local e1,e2,e3=rsoc.SpSummonFun(c,m,2,"ctrl","tg",rstg.target(Card.IsControlerCanBeChanged,"ctrl",0,LOCATION_MZONE),cm.conop)
	local e4=rsoc.TributeFun(c,m,"sp",nil,rsop.target(cm.spfilter,"sp",0,LOCATION_EXTRA),cm.spop)   
end
function cm.conop(e,tp,eg,ep,ev,re,r,rp)
	local tc=rscf.GetTargetCard()
	if tc then
		Duel.GetControl(tc,tp,0,1)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.spop(e,tp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if #g<=0 then return end
	Duel.ConfirmCards(tp,g)
	rsgf.SelectSpecialSummon(g,tp,cm.spfilter,1,1,nil,{0,tp,tp,true,false,POS_FACEUP,nil,{"dis,dise",true}},e,tp)
	--rsop.SelectSpecialSummon(tp,cm.spfilter,tp,0,LOCATION_EXTRA,1,1,nil,{0,tp,tp,true,false,POS_FACEUP,nil,{"dis,dise",true}},e,tp)
end
