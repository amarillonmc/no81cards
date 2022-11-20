--奇迹之门
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10174029
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"sp",nil,nil,rscost.reglabel(100),cm.target,cm.activate)
end
function cm.resfilter(g,e,tp)
	local g1=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,nil,e,0,tp,false,false)
	local g2=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,nil,e,0,tp,true,false)
	return g:GetClassCount(Card.GetOriginalCode)==#g and ((g1:GetClassCount(Card.GetOriginalCode)>=#g and Duel.GetMZoneCount(tp,g,tp)==#g) or (#g==5 and #g2>=1 and Duel.GetMZoneCount(tp,g,tp)>=1))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp)
	if chk==0 then 
		if e:GetLabel()~=100 then return false end
		return g:CheckSubGroup(cm.resfilter,1,5,e,tp)
	end
	e:SetLabel(0)
	rshint.Select(tp,"res")
	local sg=g:SelectSubGroup(tp,cm.resfilter,false,1,5,e,tp)
	local ct=Duel.Release(sg,REASON_COST)
	e:SetValue(ct)
end
function cm.activate(e,tp)
	local ct=e:GetValue()
	local g1=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,nil,e,0,tp,false,false) 
	local g2=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,nil,e,0,tp,true,false)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct and g1:GetClassCount(Card.GetOriginalCode)>=ct
	local b2=ct==5 and #g2>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if not b1 and not b2 then return end
	local op=rsop.SelectOption(tp,b1,{m,1},b2,{m,2})
	local sg=nil
	rshint.Select(tp,"sp")
	if op==1 then
		sg=g1:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
		rssf.SpecialSummon(sg)
	else
		sg=g2:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end
end