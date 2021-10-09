--是非曲直厅
function c9980320.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980320,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c9980320.spcon)
	e2:SetTarget(c9980320.sptg)
	e2:SetOperation(c9980320.spop)
	c:RegisterEffect(e2)
	 --Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980320,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMING_ATTACK)
	e2:SetCountLimit(1,9980320)
	e2:SetTarget(c9980320.sptg2)
	e2:SetOperation(c9980320.spop2)
	c:RegisterEffect(e2)
end
function c9980320.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bcc)
end
function c9980320.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsControler(tp) and (not e or c:IsRelateToEffect(e))
end
function c9980320.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9980320.tgfilter,1,nil,nil,1-tp) and Duel.IsExistingMatchingCard(c9980320.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9980320.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function c9980320.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c9980320.tgfilter,nil,e,1-tp)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c9980320.exfilter0(c)
	return c:IsSetCard(0x6bcc) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c9980320.exfilter1(c,e)
	return c:IsSetCard(0x6bcc) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c9980320.filter1(c,e)
	return c:IsOnField() and c:IsSetCard(0x6bcc) and (not e or not c:IsImmuneToEffect(e))
end
function c9980320.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c9980320.filter3(c)
	return c:IsCanBeFusionMaterial() and c:IsSetCard(0x6bcc)
end
function c9980320.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=2
end
function c9980320.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=2
end
function c9980320.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c9980320.filter1,nil)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>1 then
			local sg=Duel.GetMatchingGroup(c9980320.exfilter0,tp,LOCATION_EXTRA,0,nil)
			if sg:GetCount()>0 then
				mg1:Merge(sg)
				Auxiliary.FCheckAdditional=c9980320.fcheck
				Auxiliary.GCheckAdditional=c9980320.gcheck
			end
		end
		local res=Duel.IsExistingMatchingCard(c9980320.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp):Filter(c9980320.filter3,nil)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c9980320.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9980320.spop2(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c9980320.filter1,nil,e)
	local exmat=false
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>1 then
		local sg=Duel.GetMatchingGroup(c9980320.exfilter1,tp,LOCATION_EXTRA,0,nil,e)
		if sg:GetCount()>0 then
			mg1:Merge(sg)
			exmat=true
		end
	end
	if exmat then
		Auxiliary.FCheckAdditional=c9980320.fcheck
		Auxiliary.GCheckAdditional=c9980320.gcheck
	end
	local sg1=Duel.GetMatchingGroup(c9980320.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp):Filter(c9980320.filter3,nil)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c9980320.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
		if exmat then
				Auxiliary.FCheckAdditional=c9980320.fcheck
				Auxiliary.GCheckAdditional=c9980320.gcheck
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			Auxiliary.FCheckAdditional=nil
			Auxiliary.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.Destroy(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc:CompleteProcedure()
	end
end
