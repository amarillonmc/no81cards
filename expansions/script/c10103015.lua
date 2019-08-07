--冥魂龙王 提姆福涅
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10103015
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_PZONE,nil,rscost.reglabel(100),cm.sptg,cm.spop)
	local e2=rsef.QO(c,nil,{m,1},{1,m+100},"td,atk","de",LOCATION_MZONE,rscon.phmp,nil,rstg.target(rsop.list(cm.tdfilter,"td",LOCATION_REMOVED,0,true)),cm.tdop)
end
function cm.tdfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToDeck() and c:IsFaceup()
end
function cm.tdop(e,tp)
	local tg=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_REMOVED,0,nil)
	if #tg<=0 then return end
	local ct=Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(rscf.FilterFaceUp(Card.IsRace,RACE_DRAGON),tp,LOCATION_MZONE,0,nil)
	if ct>0 and #g>0 then
		for tc in aux.Next(g) do
			local e1=rsef.SV_UPDATE({e:GetHandler(),tc},"atk",300*ct,nil,rsreset.est,"cd")
		end
	end
end
function cm.rmfilter(c)
	return c:IsSetCard(0x337) and c:IsAbleToRemoveAsCost()
end 
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.rmfilter2(g,tp)
	return Duel.GetMZoneCount(tp,g,tp)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,nil)
	local b1=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp)
	local b2=g:CheckSubGroup(cm.rmfilter2,2,2,tp)
	if chk==0 then
		if e:GetLabel()==100 then return b1 and b2
		else return b1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		end
	end
	if e:GetLabel()==100 then
		e:SetLabel(0)
		rsof.SelectHint(tp,"rm")
		local rg=g:SelectSubGroup(tp,cm.rmfilter2,false,2,2,tp)
		Duel.Remove(rg,POS_FACEUP,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	if #sg>0 then
		Duel.HintSelection(sg)
		rssf.SpecialSummon(sg)
	end
end