function c10111138.initial_effect(c)
	aux.AddCodeList(c,10111128)
	 --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	  --activate (return)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111138,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10111138)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c10111138.thcost)
	e1:SetTarget(c10111138.thtg1)
	e1:SetOperation(c10111138.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c10111138.thtg2)
	c:RegisterEffect(e2)
    --fusion
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10111138,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c10111138.fstg)
	e3:SetOperation(c10111138.fsop)
	c:RegisterEffect(e3)
end
function c10111138.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(10111138)==0 end
	e:GetHandler():RegisterFlagEffect(10111138,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c10111138.thfilter(c)
	return aux.IsCodeOrListed(c,10111128) and not c:IsCode(10111138) and c:IsAbleToHand()
end
function c10111138.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10111138.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10111138.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10111138.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	c10111138.target(e,tp,eg,ep,ev,re,r,rp,1)
end
function c10111138.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10111138.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10111138.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10111138.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10111138.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9008) and c:IsType(TYPE_FUSION)
end
function c10111138.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	if Duel.IsExistingMatchingCard(c10111138.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(10111138,1)) then 
		Duel.BreakEffect() 
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) 
	end 
end
function c10111138.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c10111138.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9008)
		and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c10111138.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c10111138.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c10111138.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10111138.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c10111138.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c10111138.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c10111138.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end