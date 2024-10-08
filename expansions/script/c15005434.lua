local m=15005434
local cm=_G["c"..m]
cm.name="泣声融合"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter1(c)
	return c:IsCanBeFusionMaterial()
end
function cm.filter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.filter3(c,e)
	return cm.filter1(c) and not c:IsImmuneToEffect(e)
end
function cm.spfilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsType(TYPE_TUNER) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.chkfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_FUSION) and c:IsType(TYPE_TUNER)
end
function cm.fcheck(tp,sg,fc)
	if sg:IsExists(cm.chkfilter,1,nil,tp) then
		return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
	else
		return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=0
	end
end
function cm.gcheck(tp)
	return  function(sg)
				return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
			end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil)
		if mg1:IsExists(cm.chkfilter,1,nil,tp) and mg2:GetCount()>0 then
			mg1:Merge(mg2)
			aux.FCheckAdditional=cm.fcheck
			aux.GCheckAdditional=cm.gcheck(tp)
		end
		local res=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter2,nil,e)
	local mg2=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_DECK,0,nil,e)
	local exmat=false
	if mg1:IsExists(cm.chkfilter,1,nil,tp) and mg2:GetCount()>0 then
		mg1:Merge(mg2)
		exmat=true
	end
	if exmat then
		aux.FCheckAdditional=cm.fcheck
		aux.GCheckAdditional=cm.gcheck(tp)
	end
	local sg1=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	local sg=sg1:Clone()
	if sg2 then sg:Merge(sg2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	if not tc then return end
	if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
		if exmat then
			aux.FCheckAdditional=cm.fcheck
			aux.GCheckAdditional=cm.gcheck(tp)
		end
		local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		tc:SetMaterial(mat1)
		Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	else
		local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
		local fop=ce:GetOperation()
		fop(ce,e,tp,tc,mat2)
	end
	tc:CompleteProcedure()
end