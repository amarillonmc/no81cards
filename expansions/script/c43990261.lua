--不可见之金黄
function c43990261.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990261,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c43990261.cost)
	e1:SetTarget(c43990261.target)
	e1:SetOperation(c43990261.activate)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c43990261.regtg)
	e2:SetOperation(c43990261.regop)
	c:RegisterEffect(e2)
end
function c43990261.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(43990261,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
		Duel.SendtoGrave(g,REASON_COST)
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c43990261.thfilter(c,chk)
	return c:IsSetCard(0x1d3) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))-- and c:IsFaceupEx() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c43990261.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990261.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c43990261.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c43990261.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,1):GetFirst()
	if not tc then return end
	--Duel.HintSelection(Group.FromCards(tc))
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	--
	if not tc:IsLocation(LOCATION_HAND) or ct==0 or not c43990261.fstg(e,tp,eg,ep,ev,re,r,rp,0) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(43990261,2)) then return end
	Duel.ShuffleHand(tp)
	Duel.BreakEffect()
	c43990261.fsop(e,tp,eg,ep,ev,re,r,rp)
end
function c43990261.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c43990261.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x1d3) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c43990261.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c43990261.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c43990261.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
end
function c43990261.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c43990261.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c43990261.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c43990261.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c43990261.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,43990261)==0 end
end
function c43990261.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTurnPlayer()==tp and 2 or 1
	Duel.RegisterFlagEffect(tp,43990261,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,ct)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c43990261.distg)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,ct)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(c43990261.discon)
	e2:SetOperation(c43990261.disop)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,ct)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c43990261.immtg)
	e3:SetValue(c43990261.efilter)
	e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,ct)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c43990261.ptfilter)
	e4:SetValue(1)
	e4:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,ct)
	Duel.RegisterEffect(e4,tp)
end
function c43990261.distg(e,c)
	return e:GetOwnerPlayer()~=c:GetOwner() and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c43990261.discon(e,tp,eg,ep,ev,re,r,rp)
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetOwner()~=tp and loc==LOCATION_MZONE and p==tp
end
function c43990261.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c43990261.immtg(e,c)
	return e:GetOwnerPlayer()~=c:GetOwner()
end
function c43990261.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()-- and e:GetOwner()~=re:GetOwner()
end
function c43990261.ptfilter(e,c)
	return e:GetOwnerPlayer()~=c:GetOwner() or c:IsSetCard(0x1d3)
end
