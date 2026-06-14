--主宰权能
function c11182340.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11182340,1))
	e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCountLimit(1,11182340)
	e1:SetTarget(c11182340.target)
	e1:SetOperation(c11182340.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11182340,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCountLimit(1,11182340+1)
	e2:SetCost(c11182340.DisCardCost2)
	e2:SetTarget(c11182340.target2)
	e2:SetOperation(c11182340.activate2)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c11182340.val)
	c:RegisterEffect(e3)
end
function c11182340.atkfilter(c)
	return c:IsSetCard(0x6454) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx()
end
function c11182340.val(e,c)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c11182340.atkfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return g:GetCount()*(-200)
end
function c11182340.DisCardCostFilter(c,tp)
	return c:IsAbleToDeckAsCost() and c:IsHasEffect(11182305,tp)
end
function c11182340.CostFilter1(c)
	return c:IsAbleToGraveAsCost()
end
function c11182340.CostFilter2(c)
	return c:IsAbleToRemoveAsCost()
end
function c11182340.DisCardCost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c11182340.DisCardCostFilter,tp,0x30,0,nil,tp)
	g1:Merge(g2)
	local g3=Duel.GetMatchingGroup(c11182340.CostFilter1,tp,0xc,0,nil)
	local g4=Duel.GetMatchingGroup(c11182340.CostFilter2,tp,0xc,0,nil)
	if chk==0 then return g1:GetCount()>0 or #g3>0 or #g4>0 end
	local op=aux.SelectFromOptions(tp,{#g1>0,aux.Stringid(11182340,0)},{#g3>0,aux.Stringid(11182340,1)},{#g4>0,aux.Stringid(11182340,2)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local tc=g1:Select(tp,1,1,nil):GetFirst()
		local te=c:IsHasEffect(11182305,tp)
		if te then
			te:UseCountLimit(tp)
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT+REASON_REPLACE)
		else
			Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g3:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,0x80)
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g4:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,0x80)
	end
end
function c11182340.filter1(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function c11182340.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsSetCard(0x6454)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c11182340.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		local res=Duel.IsExistingMatchingCard(c11182340.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c11182340.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		local b1=Duel.IsExistingMatchingCard(c11182340.filter1,tp,LOCATION_EXTRA,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(c11182340.filter2,tp,LOCATION_EXTRA,0,1,nil)
		local b3=Duel.IsExistingMatchingCard(c11182340.filter3,tp,LOCATION_EXTRA,0,1,nil)
		return res or b1 or b2 or b3
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11182340.sfilter1(c)
	return c:IsSynchroSummonable(nil) and c:IsSetCard(0x6454)
end
function c11182340.sfilter2(c)
	return c:IsXyzSummonable(nil) and c:IsSetCard(0x6454)
end
function c11182340.sfilter3(c)
	return c:IsLinkSummonable(nil) and c:IsSetCard(0x6454)
end
function c11182340.activate2(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c11182340.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c11182340.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c11182340.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	local b0=sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)
	local b1=Duel.IsExistingMatchingCard(c11182340.sfilter1,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c11182340.sfilter2,tp,LOCATION_EXTRA,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(c11182340.sfilter3,tp,LOCATION_EXTRA,0,1,nil)
	local op=aux.SelectFromOptions(tp,{b0,aux.Stringid(11182340,3)},{b1,aux.Stringid(11182340,4)},{b2,aux.Stringid(11182340,5)},{b3,aux.Stringid(11182340,6)})
	if op==1 then
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
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c11182340.sfilter1,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
		Duel.SynchroSummon(tp,sc,nil)
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c11182340.sfilter2,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,sc,nil)
	elseif op==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c11182340.sfilter3,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
		Duel.LinkSummon(tp,sc,nil)
	end
end
function c11182340.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x6454)
		and Duel.IsExistingMatchingCard(c11182340.setfilter,tp,0x31,0,1,nil,c,tp)
end
function c11182340.setfilter(c,tc,tp)
	return c:IsType(TYPE_QUICKPLAY) and c:IsSetCard(0x6454) and c:IsFaceupEx() and c:IsSSetable()
		and aux.IsCodeListed(c,tc:GetAttribute())
end
function c11182340.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11182340.filter(chkc,tp) end
	local ft=0
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=1 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>ft
		and Duel.IsExistingTarget(c11182340.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c11182340.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c11182340.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11182340.setfilter),tp,0x31,0,1,1,nil,tc,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			if Duel.SSet(tp,tc)>0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(11182340,0))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end
end
