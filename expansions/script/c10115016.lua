--炼金生命体 聚合奇形体
if not pcall(function() require("expansions/script/c10115001") end) then require("script/c10115001") end
local m=10115016
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,cm.gf)
	local e1=rsef.SV_CANNOT_BE_MATERIAL(c,"link",nil,nil,nil,"cd,uc")
	local e2=rsef.I(c,{m,0},1,"sp",nil,LOCATION_MZONE,nil,nil,cm.sptg,cm.spop)
	local e3=rsef.I(c,{m,0},nil,"sp",nil,LOCATION_GRAVE,nil,rscost.cost(cm.resfilter,"res",LOCATION_MZONE),rstg.target(rsop.list(cm.spfilter,"sp",true)),cm.spop2)
end
function cm.gf(g)
	return g:GetClassCount(Card.GetLinkAttribute)==#g
end 
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c or c:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
	local zone=c:GetLinkedZone(tp)&0x1f
	if zone==0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter0),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp,zone)
	if #g<=0 or not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
	rsof.SelectHint(tp,"sp")
	local sg=g:SelectSubGroup(tp,cm.spcheck,false,1,2,e,tp,zone)
	if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,zone)~=0 then
		local og=Duel.GetOperatedGroup()
		for tc in aux.Next(og) do
			local e1=rsef.SV_CANNOT_BE_MATERIAL({c,tc},"link",nil,nil,rsreset.est)
		end
	end
end
function cm.spfilter0(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and c:IsLevel(4) and c:IsSetCard(0x3330)
end
function cm.spcheck(g,e,tp,zone)
	local ct=Duel.GetMZoneCount(tp,Group.CreateGroup(),tp,LOCATION_REASON_TOFIELD,zone)
	return #g<=ct and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<=1 and g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1
end
function cm.resfilter(c,e,tp)
	return c:IsReleasable() and rsab.typecheck2(c) and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spop2(e,tp)
	local c=aux.ExceptThisCard(e)
	if c then rssf.SpecialSummon(c) end
end