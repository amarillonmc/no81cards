--召唤之传承者
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174055)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	local e1=rsef.I(c,{m,0},{1,m},"sp","tg",LOCATION_MZONE,nil,nil,cm.sptg,cm.spop)
	local e2=rsef.FV_UPDATE(c,"atk",1000,cm.tg,{ LOCATION_MZONE,LOCATION_MZONE })
end
function cm.cfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function cm.gfilter(g,e,tp) 
	local tc=g:GetFirst()
	return g:FilterCount(cm.cfilter,nil,e)==#g and g:GetClassCount(Card.GetOriginalCodeRule)==1 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,tc:GetOriginalCodeRule()) 
end
function cm.spfilter(c,e,tp,code)
	if not c:IsOriginalCodeRule(code) then return false end
	local res=false
	for p=0,1 do
		local zone=Duel.GetLinkedZone(p)&0xff
		res=res or (Duel.GetLocationCount(p,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,p,zone))
	end
	return res
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=c:GetLinkedGroup()
	if chkc then return false end
	if chk==0 then return g:CheckSubGroup(cm.gfilter,2,2,e,tp) end
	rshint.Select(tp,HINTMSG_FACEUP)
	local tg=g:SelectSubGroup(tp,cm.gfilter,false,2,2,e,tp)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function cm.spop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	if not c then return end
	local g=rsgf.GetTargetGroup()
	local zonelist={[0]=c:GetLinkedZone(0),[1]=c:GetLinkedZone(1)}
	rshint.Select(tp,"sp")
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp,g:GetFirst():GetCode()):GetFirst()
	if tc then
		rssf.SpecialSummonEither(tc,e,0,tp,nil,true,false,POS_FACEUP,zonelist)
	end
end
function cm.tg(e,rc)
	local c=e:GetHandler()
	local g=c:GetLinkedGroup()
	local ag=Group.CreateGroup()	
	for tc in aux.Next(g) do
		if g:IsExists(Card.IsOriginalCodeRule,1,tc,tc:GetOriginalCodeRule()) then 
			ag:AddCard(tc)
			ag:AddCard(c)
		end
	end
	return ag:IsContains(rc)
end
