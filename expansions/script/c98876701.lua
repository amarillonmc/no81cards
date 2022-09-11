--三色堇之寻芳精
function c98876701.initial_effect(c)
	--fusion 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98876701) 
	e1:SetCost(c98876701.fucost)
	e1:SetTarget(c98876701.futg)
	e1:SetOperation(c98876701.fuop)
	c:RegisterEffect(e1) 
	--search
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,18876701) 
	e2:SetCondition(c98876701.thcon)
	e2:SetTarget(c98876701.thtg)
	e2:SetOperation(c98876701.thop)
	c:RegisterEffect(e2)
end 
function c98876701.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c98876701.spfilter1(c,e,tp,m,f,chkf)
	return c:IsRace(RACE_PLANT) and c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end 
function c98876701.spfilter2(c,e,tp,m,f,chkf)
	return c:IsSetCard(0x988) and c:IsRace(RACE_PLANT) and c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end 
function c98876701.fexfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x988) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c98876701.costfilter(c,e,tp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp)
	if mg1:IsContains(c) then mg1:RemoveCard(c) end
	local res=Duel.IsExistingMatchingCard(c98876701.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf) 
	if res then return c:IsDiscardable() end 
	local mg2=Duel.GetMatchingGroup(c98876701.fexfilter,tp,LOCATION_DECK,0,nil) 
		aux.FCheckAdditional=c98876701.frcheck
		aux.GCheckAdditional=c98876701.gcheck
	mg2:Merge(mg1)
	res=Duel.IsExistingMatchingCard(c98876701.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,nil,chkf) 
		aux.FCheckAdditional=nil 
		aux.GCheckAdditional=nil 
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg2=fgroup(ce,e,tp)
			if mg2:IsContains(c) then mg2:RemoveCard(c) end
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(c98876701.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
		end
	end
	return c:IsDiscardable() and res
end
function c98876701.fucost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.IsExistingMatchingCard(c98876701.costfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c98876701.costfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	e:SetLabel(100)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end 
function c98876701.frcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c98876701.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c98876701.futg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c98876701.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if res then return true end
		local mg2=Duel.GetMatchingGroup(c98876701.fexfilter,tp,LOCATION_DECK,0,nil) 
		aux.FCheckAdditional=c98876701.frcheck
		aux.GCheckAdditional=c98876701.gcheck
		mg2:Merge(mg1)
		res=Duel.IsExistingMatchingCard(c98876701.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,nil,chkf) 
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c98876701.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98876701.fuop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp)
	local sg1=Duel.GetMatchingGroup(c98876701.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=Duel.GetMatchingGroup(c98876701.fexfilter,tp,LOCATION_DECK,0,nil,e)
	mg2:Merge(mg1) 
		aux.FCheckAdditional=c98876701.frcheck
		aux.GCheckAdditional=c98876701.gcheck
	local sg2=Duel.GetMatchingGroup(c98876701.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,nil,chkf) 
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
	sg1:Merge(sg2)
	local mg3=nil
	local sg3=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg3=Duel.GetMatchingGroup(c98876701.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg3~=nil and sg3:GetCount()>0) then
		local sg=sg1:Clone()
		if sg3 then sg:Merge(sg3) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg3==nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if tc:IsSetCard(0x988) then 
		aux.FCheckAdditional=c98876701.frcheck
		aux.GCheckAdditional=c98876701.gcheck
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
				tc:SetMaterial(mat1)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
				local mat2=mat1:Filter(Card.IsLocation,nil,LOCATION_DECK)
				mat1:Sub(mat2)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat2)
				Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat)
		end
		tc:CompleteProcedure()
	end
end 
function c98876701.thcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():IsSummonLocation(LOCATION_GRAVE)  
end 
function c98876701.thfilter(c)
	return c:IsSetCard(0x988) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c98876701.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98876701.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98876701.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98876701.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND) 
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end 







