--盛装的古之邀 千夜咏叹调
function c28362718.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c28362718.cost)
	e1:SetTarget(c28362718.target)
	e1:SetOperation(c28362718.activate)
	c:RegisterEffect(e1)
	--fusion summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28362718.fscon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c28362718.fstg)
	e2:SetOperation(c28362718.fsop)
	c:RegisterEffect(e2)
	if not c28362718.global_check then
		c28362718.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetCondition(c28362718.checkcon)
		ge1:SetOperation(c28362718.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c28362718.ctfilter(c)
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsType(TYPE_FUSION) and c:IsFaceup()
end
function c28362718.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c28362718.ctfilter,1,nil)-- and re and not re:IsHasProperty(EFFECT_FLAG_UNCOPYABLE)
end
function c28362718.checkop(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c28362718.ctfilter,nil)
	for tc in aux.Next(sg) do
		local code=tc:GetCode()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(28362718)
		e1:SetTargetRange(LOCATION_EXTRA,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,code))
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tc:GetSummonPlayer())
	end
end
function c28362718.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)<=3000 or Duel.CheckLPCost(tp,2000) end
	if Duel.GetLP(tp)>3000 then Duel.PayLPCost(tp,2000) end
end
function c28362718.cfilter(c,code1,code2)
	return c:IsCode(code1,code2) and c:IsFaceup()
end
function c28362718.thfilter(c,tp,code)
	return c:IsSetCard(0x285) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(c28362718.cfilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode(),code)
end
function c28362718.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local code=e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():GetCode() or 0
	if chk==0 then return Duel.IsExistingMatchingCard(c28362718.thfilter,tp,LOCATION_DECK,0,1,nil,tp,code) and (Duel.GetLP(tp)>3000 or Duel.IsPlayerCanDraw(tp,1)) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28362718.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c28362718.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp,0):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	if Duel.GetLP(tp)<=3000 and Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		--Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e))
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c28362718.fscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) and not eg:IsContains(e:GetHandler())
end
function c28362718.filter1(c,e)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsDestructable(e) and not c:IsImmuneToEffect(e)
end
function c28362718.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and not c:IsHasEffect(28362718) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c28362718.fcheck(tp,sg,fc)
	return true--sg:GetSum(Card.GetAttack)>=Duel.GetLP(tp)
end
function c28362718.fstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsFusionAttribute,nil,ATTRIBUTE_DARK)
		aux.FCheckAdditional=c28362718.fcheck
		local res=Duel.IsExistingMatchingCard(c28362718.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c28362718.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		aux.FCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function c28362718.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c28362718.filter1,nil,e)
	aux.FCheckAdditional=c28362718.fcheck
	local sg1=Duel.GetMatchingGroup(c28362718.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c28362718.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			if Duel.Destroy(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)==#mat1 then
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
				tc:CompleteProcedure()
			end
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
			tc:CompleteProcedure()
		end
	end
	aux.FCheckAdditional=nil
end
