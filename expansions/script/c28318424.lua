--闪耀的集合 多彩的天空
function c28318424.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c28318424.condition)
	e1:SetTarget(c28318424.target)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28318424.thcon)
	e2:SetCost(c28318424.thcost)
	e2:SetTarget(c28318424.thtg)
	e2:SetOperation(c28318424.thop)
	c:RegisterEffect(e2)
end
function c28318424.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c28318424.matfilter(c)
	return c:IsFaceup() or c:IsLocation(LOCATION_HAND)
end
function c28318424.fsfilter(c,g,e,tp)
	return c:IsSetCard(0x283) and c:CheckFusionMaterial(g) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c28318424.syfilter(c,mg)
	return c:IsSetCard(0x283) and c:IsSynchroSummonable(nil,mg)
end
function c28318424.lkfilter(c,mg)
	return c:IsSetCard(0x283) and c:IsLinkSummonable(mg)
end
function c28318424.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c28318424.matfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_MZONE+LOCATION_HAND,0,nil):Filter(Card.IsType,nil,TYPE_MONSTER)
	local b1=Duel.IsExistingMatchingCard(c28318424.fsfilter,tp,LOCATION_EXTRA,0,1,nil,g,e,tp)
	 and g:GetCount()>1
	local b2=Duel.IsExistingMatchingCard(c28318424.syfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	local b3=Duel.IsExistingMatchingCard(c28318424.lkfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(28318424,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(28318424,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(28318424,2)
		opval[off-1]=3
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetOperation(c28318424.fsop)
	elseif opval[op]==2 then
		e:SetOperation(c28318424.syop)
	elseif opval[op]==3 then
		e:SetOperation(c28318424.lkop)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c28318424.ifilter(c,e)
	return not c:IsImmuneToEffect(e)
end
function c28318424.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c28318424.ifilter,nil,e)
	local sg1=Duel.GetMatchingGroup(c28318424.fsfilter,tp,LOCATION_EXTRA,0,nil,mg1,e,tp)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c28318424.fsfilter,tp,LOCATION_EXTRA,0,nil,mg2,e,tp)
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
function c28318424.syop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c28318424.matfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c28318424.syfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
	local tc=tg:GetFirst()
	if tc then
		Duel.SynchroSummon(tp,tc,nil,mg)
	end
end
function c28318424.lkop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c28318424.matfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c28318424.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
	local tc=tg:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,mg)
	end
end
function c28318424.filter(c)
	return c:IsSetCard(0x283) and c:IsRace(RACE_FAIRY) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c28318424.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28318424.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,16,nil)
end
function c28318424.cfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER) and c:GetOriginalLevel()<=4 and c:GetOriginalLevel()>0 and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c28318424.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28318424.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c28318424.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c28318424.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,LOCATION_GRAVE)
end
function c28318424.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c28318424.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c28318424.splimit(e,c)
	return not c:IsSetCard(0x283) and c:IsLocation(LOCATION_EXTRA)
end
