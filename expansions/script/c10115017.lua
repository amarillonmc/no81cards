--混沌炼金术·X
if not pcall(function() require("expansions/script/c10115001") end) then require("script/c10115001") end
local m=10115017
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_FZONE,nil,rscost.reglabel(100),cm.sptg,cm.spop)
	local e3=rsef.FTO(c,EVENT_SPSUMMON_SUCCESS,{m,1},nil,nil,"tg,de",LOCATION_FZONE,cm.mvcon,nil,cm.mvtg,cm.mvop)
	local e4=rsef.RegisterClone(c,e3,"code",EVENT_SUMMON_SUCCESS)
end
function cm.resfilter(c,tp)
	return c:IsSetCard(0x3330) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function cm.spfilter(c,e,tp)
	return c:IsCode(10115016) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	if chk==0 then
		if e:GetLabel()==100 then return Duel.CheckReleaseGroup(tp,cm.resfilter,1,nil,tp) and b1
		else
			return b1
		end
	end 
	if e:GetLabel()==100 then
		e:SetLabel(0)
		local rg=Duel.SelectReleaseGroup(tp,cm.resfilter,1,1,nil,tp)
		Duel.Release(rg,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	rsof.SelectHint(tp,"sp")
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc then
		tc:SetMaterial(nil)
		if rssf.SpecialSummon(tc,SUMMON_TYPE_LINK)>0 then
			tc:CompleteProcedure()
		end
	end
end
function cm.mvcon(e,tp,eg)
	local lg=Duel.GetMatchingGroup(rscf.FilterFaceUp(Card.IsCode,10115016),tp,LOCATION_MZONE,0,nil)
	local zone=0
	for tc in aux.Next(lg) do
		zone=zone|tc:GetLinkedZone(tp)
	end
	return eg:IsExists(cm.cfilter,1,nil,tp,zone)	
end
function cm.cfilter(c,tp,zone)
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then
		if c:IsControler(1-tp) then seq=seq+16 end
	else
		seq=c:GetPreviousSequence()
		if c:GetPreviousControler()==1-tp then seq=seq+16 end
	end
	return bit.extract(zone,seq)~=0
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) and ft>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,2,nil)
end
function cm.cfilter2(c,e,tp)
	return c:IsControler(tp) and not c:IsImmuneToEffect(e)
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=aux.ExceptThisCard(e)
	local tg=rsgf.GetTargetGroup(cm.cfilter2,e,tp)
	if not c or #tg<=0 then return end
	for tc in aux.Next(tg) do
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(tc,nseq)
	end
end