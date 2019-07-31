--炼金生命体 聚合球孢体
if not pcall(function() require("expansions/script/c10115001") end) then require("script/c10115001") end
local m=10115012
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	local e1=rsef.I(c,{m,0},1,"des",nil,LOCATION_MZONE,nil,rscost.reglabel(100),cm.destg,cm.desop)
	local e2=rsef.FTO(c,EVENT_PHASE+PHASE_END,{m,1},{1,m},"td,sp","tg",LOCATION_GRAVE,nil,nil,rstg.target0(cm.fun1,cm.fun2,cm.tdfilter,"td",LOCATION_GRAVE,0,2,2,c),cm.spop)
end
function cm.cfilter(c,tp)
	local eg=c:GetEquipGroup()
	return rsab.typecheck1(c) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,eg)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if e:GetLabel()~=100 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		else return Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil,tp)
		end
	end
	if e:GetLabel()==100 then
		e:SetLabel(0)
		local rg=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil,tp)
		Duel.Release(rg,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
end
function cm.desop(e,tp)
	rsof.SelectHint(tp,"des")
	local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	if #dg>0 then
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function cm.fun1(e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.fun2(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.tdfilter(c)
	return rsab.typecheck1(c) and c:IsAbleToDeck()
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	local g=rsgf.GetTargetGroup()
	if #g<=0 or Duel.SendtoDeck(g,nil,2,REASON_EFFECT)<=0 then return end
	local og=Duel.GetOperatedGroup()
	if #og<=0 or not og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then return end
	if c then rssf.SpecialSummon(c) end
end