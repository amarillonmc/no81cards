--龙界咒 龙枪·击碎行星之光
function c99700278.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99700278,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,99700278)
	e1:SetCost(c99700278.amcost)
	e1:SetCondition(c99700278.discon)
	e1:SetTarget(c99700278.distg)
	e1:SetOperation(c99700278.disop)
	c:RegisterEffect(e1)
	--fusion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99700278,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,99700279)
	e2:SetCost(c99700278.amcost)
	e2:SetTarget(c99700278.futg)
	e2:SetOperation(c99700278.fuop)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99700278,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,99700289)
	e3:SetCost(c99700278.amcost)
	e3:SetTarget(c99700278.tdtg)
	e3:SetOperation(c99700278.tdop)
	c:RegisterEffect(e3)
end
function c99700278.chainlm(e,ep,tp)
	return tp==ep
end
function c99700278.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfd04) and c:IsType(TYPE_FUSION)
end
function c99700278.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsExistingMatchingCard(c99700278.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsChainNegatable(ev)
end
function c99700278.amcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(99700278,tp,ACTIVITY_CHAIN+ACTIVITY_SUMMON+ACTIVITY_SPSUMMON+ACTIVITY_FLIPSUMMON+ACTIVITY_NORMALSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c99700278.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e4,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c99700278.aclimit)
	Duel.RegisterEffect(e3,tp)
end
function c99700278.splimit(e,c)
	return not (c:IsSetCard(0xfd00) or c:IsSetCard(0xfd01) or c:IsSetCard(0xfd02) or c:IsSetCard(0xfd03) or c:IsSetCard(0xfd04))
end
function c99700278.aclimit(e,re,tp)
	return not (re:GetHandler():IsSetCard(0xfd00) or re:GetHandler():IsSetCard(0xfd01) or re:GetHandler():IsSetCard(0xfd02) or re:GetHandler():IsSetCard(0xfd03) or re:GetHandler():IsSetCard(0xfd04))
end
function c99700278.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
		Duel.SetChainLimit(c99700278.chainlm)
	end
end
function c99700278.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c99700278.filter0(c)
	return c:IsOnField() and c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove() and not c:IsCode(99700278)
end
function c99700278.filter1(c,e)
	return c:IsOnField() and c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove() and not c:IsImmuneToEffect(e) and not c:IsCode(99700278)
end
function c99700278.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xfd04) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c99700278.filter3(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and not c:IsCode(99700278) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c99700278.futg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c99700278.filter0,nil)
		local mg2=Duel.GetMatchingGroup(c99700278.filter3,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c99700278.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c99700278.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
	Duel.SetChainLimit(c99700278.chainlm)
end
function c99700278.fuop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c99700278.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c99700278.filter3,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c99700278.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c99700278.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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
function c99700278.tdfilter(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xfd04) and c:IsAbleToDeck()
end
function c99700278.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99700278.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
	Duel.SetChainLimit(c99700278.chainlm)
end
function c99700278.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c99700278.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end