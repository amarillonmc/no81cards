--机械加工 敲击南洋大兜虫
if not pcall(function() require("expansions/script/c40008000") end) then require("script/c40008000") end
local m,cm=rscf.DefineCard(40009281)
local m=40009281
local cm=_G["c"..m]
cm.named_with_Machining=1
function cm.Machining(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Machining
end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_INSECT),2)
	local e1=rsef.QO(c,nil,"des",{1,m},"des","tg",LOCATION_MZONE,nil,rscost.reglabel(100),cm.destg,cm.desop) 
	local e2=rsef.STO(c,EVENT_BE_MATERIAL,"sp",{1,m+100},"sp","tg,de",cm.spcon,nil,rstg.target(cm.spfilter,"sp",LOCATION_GRAVE,0,1,cm.ct),cm.spop)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_ONFIELD) and r & REASON_LINK ~= 0 
end
function cm.spfilter(c,e,tp)
	return c:IsLevelBelow(2) and c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.ct(e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if rscon.bsdcheck(tp) then return 1 
	else
		return math.min(ft,2)
	end
end
function cm.spop(e,tp)
	local sg=rsgf.GetTargetGroup()
	if #sg<=0 or (#sg>=2 and rscon.bsdcheck(tp)) or Duel.GetLocationCount(tp,LOCATION_MZONE)<#sg then return end
	rssf.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,nil,{"dis,dise"})
end
function cm.cfilter(c,g,flag)
	return g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsExistingTarget(cm.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil,flag,c)
end
function cm.desfilter(c,flag,rc)
	return c:IsFaceup() and (flag ~= 100 or not rc:GetEquipGroup():IsContains(c))
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local flag=e:GetLabel()
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(REASON_COST,tp,cm.cfilter,1,nil,lg,flag) end
	if flag == 100 then
		local g=Duel.SelectReleaseGroup(REASON_COST,tp,cm.cfilter,1,1,nil,lg,flag)
		Duel.Release(g,REASON_COST)
	end
	rshint.Select(tp,"des")
	local dg=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end
function cm.desop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then Duel.Destroy(tc,REASON_EFFECT) end
end
