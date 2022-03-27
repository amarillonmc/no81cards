--简单调合
function c9310043.initial_effect(c)
	aux.AddCodeList(c,9310027)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9310043+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9310043.target)
	e1:SetOperation(c9310043.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9311043)
	e2:SetCondition(c9310043.thcon)
	e2:SetTarget(c9310043.thtg)
	e2:SetOperation(c9310043.thop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9310043,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,9311043)
	e3:SetCondition(c9310043.thcon2)
	e3:SetTarget(c9310043.thtg)
	e3:SetOperation(c9310043.thop)
	c:RegisterEffect(e3)
end
function c9310043.chkfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_TUNER) and c:IsOnField()
end
function c9310043.filter0(c)
	return c:IsSetCard(0x3f91) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_TUNER)
			and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c9310043.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c9310043.spfilter1(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsType(TYPE_TUNER) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c9310043.spfilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x3f91) and c:IsType(TYPE_TUNER) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c9310043.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1 and sg:IsExists(c9310043.chkfilter,1,nil,tp)
end
function c9310043.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1 
end
function c9310043.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c9310043.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if res then return true end
		local mg2=Duel.GetMatchingGroup(c9310043.filter0,tp,LOCATION_DECK,0,nil)
		if mg1:IsExists(c9310043.chkfilter,1,nil,tp) and mg2:GetCount()>0 then
		   mg1:Merge(mg2)
		   aux.FCheckAdditional=c9310043.fcheck
		   aux.GCheckAdditional=c9310043.gcheck
		end
		res=Duel.IsExistingMatchingCard(c9310043.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c9310043.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9310043.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c9310043.filter1,nil,e)
	local exmat=false
	if mg1:IsExists(c9310043.chkfilter,1,nil,tp) then
		local mg2=Duel.GetMatchingGroup(c9310043.filter0,tp,LOCATION_DECK,0,nil)
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
			exmat=true
		end
	end
	if exmat then
		aux.FCheckAdditional=c9310043.fcheck
		aux.GCheckAdditional=c9310043.gcheck
	end
	local sg1=Duel.GetMatchingGroup(c9310043.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg3=nil
	local sg2=Duel.GetMatchingGroup(c9310043.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	sg1:Merge(sg2)
	local sg3=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg3=Duel.GetMatchingGroup(c9310043.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg3~=nil and sg3:GetCount()>0) then
		local sg=sg1:Clone()
		if sg3 then sg:Merge(sg3) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg3==nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if exmat and tc:IsSetCard(0x3f91) then
				aux.FCheckAdditional=c9310043.fcheck
				aux.GCheckAdditional=c9310043.gcheck
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
end
function c9310043.cfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsSummonPlayer(tp)
			and c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_TUNER)
end
function c9310043.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9310043.cfilter,1,nil,tp)
end
function c9310043.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(9310027)
end
function c9310043.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9310043.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
