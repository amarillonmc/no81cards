--庇护者融合
function c82566601.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82566601)
	e1:SetTarget(c82566601.target)
	e1:SetOperation(c82566601.activate)
	c:RegisterEffect(e1)  
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,82566601)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c82566601.sptg)
	e2:SetOperation(c82566601.spop)
	c:RegisterEffect(e2)
	--add code
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_ADD_CODE)
	e4:SetValue(82568057)
	c:RegisterEffect(e4)
end
function c82566601.filter(c,e,tp)
	return  c:IsCode(82567853,82567855,82567786,82567787,82568087,82568086) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c82566601.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82566601.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c82566601.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82566601.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ct=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	if ct==0 then return end
	local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		 local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(82566601,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_PHASE+PHASE_END)
		e6:SetCountLimit(1)
		e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_CANNOT_DISABLE)
		e6:SetLabel(fid)
		e6:SetLabelObject(tc)
		e6:SetCondition(c82566601.tdcon)
		e6:SetOperation(c82566601.tdop)
		Duel.RegisterEffect(e6,tp)
	
end
function c82566601.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(82566601)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c82566601.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetLabelObject(),nil,2,REASON_EFFECT)
end
function c82566601.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa825) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c82566601.filter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function c82566601.filter3(c,e)
	return c82566601.filter1(c) and not c:IsImmuneToEffect(e)
end
function c82566601.spfilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (c:IsSetCard(0x825) or c:IsSetCard(0x828)) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c82566601.chkfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0xa825) and c:IsOnField()
end
function c82566601.fcheck(tp,sg,fc)
	if sg:IsExists(c82566601.chkfilter,1,nil,tp) then
		return sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA+LOCATION_DECK)<=1
	else
		return sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA+LOCATION_DECK)<=0
	end
end
function c82566601.gcheck(tp)
	return  function(sg)
				return sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA+LOCATION_DECK)<=1
			end
end
function c82566601.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c82566601.filter1,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil)
		if mg1:IsExists(c82566601.chkfilter,1,nil,tp) and mg2:GetCount()>0 and Duel.GetLP(tp)<=4000 then
			mg1:Merge(mg2)
			aux.FCheckAdditional=c82566601.fcheck
			aux.GCheckAdditional=c82566601.gcheck(tp)
		end
		local res=Duel.IsExistingMatchingCard(c82566601.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c82566601.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82566601.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c82566601.filter2,nil,e)
	local mg2=Duel.GetMatchingGroup(c82566601.filter3,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e)
	if mg1:IsExists(c82566601.chkfilter,1,nil,tp) and mg2:GetCount()>0 and Duel.GetLP(tp)<=4000 then
		mg1:Merge(mg2)
		exmat=true
	end
	if exmat then
		aux.FCheckAdditional=c82566601.fcheck
		aux.GCheckAdditional=c82566601.gcheck(tp)
	end
	local sg1=Duel.GetMatchingGroup(c82566601.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c82566601.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	local sg=sg1:Clone()
	if sg2 then sg:Merge(sg2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	if not tc then return end
	if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
		if exmat then
			aux.FCheckAdditional=c82566601.fcheck
			aux.GCheckAdditional=c82566601.gcheck(tp)
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
	 local atk=tc:GetAttack()
	local def=tc:GetDefense()
	local val=math.max(atk,def)
	Duel.Recover(tp,val/2,REASON_EFFECT)
end
