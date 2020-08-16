--喰星壳·暴食
function c79029574.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2,c79029574.ovfilter,aux.Stringid(79029574,0),99)
	c:EnableReviveLimit()
	c:EnableReviveLimit() 
	--Overlay 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c79029574.ovtg)
	e1:SetOperation(c79029574.ovop)
	c:RegisterEffect(e1) 
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(c79029574.atkval)
	c:RegisterEffect(e1)
	--fusion
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029574)
	e1:SetTarget(c79029574.target)
	e1:SetOperation(c79029574.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c79029574.qkcon)
	c:RegisterEffect(e2)
end
function c79029574.atkval(e,c)
	return c:GetOverlayCount()*300
end
function c79029574.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xad) and c:IsType(TYPE_FUSION)
end
function c79029574.dfil(c,e)
	return c:IsSetCard(0xc3) or c:IsSetCard(0xa9)
end
function c79029574.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=e:GetHandler():GetOverlayCount()
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and Duel.IsExistingMatchingCard(c79029574.dfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e) end
	local g=Duel.SelectMatchingCard(tp,c79029574.dfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,x,nil,e)
	Duel.SetTargetCard(g)
end
function c79029574.ovop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Overlay(e:GetHandler(),g)
end
function c79029574.filter0(c)
	return c:IsAbleToRemove()
end
function c79029574.filter1(c,e)
	return c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c79029574.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c79029574.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c79029574.xilter(c)
	return c:IsSetCard(0xad) and c:IsType(TYPE_FUSION)
end
function c79029574.qkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c79029574.xilter,1,nil)
end
function c79029574.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c79029574.filter0,nil)
		local mg2=Duel.GetMatchingGroup(c79029574.filter3,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c79029574.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c79029574.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c79029574.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c79029574.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c79029574.filter3,tp,LOCATION_GRAVE,0,nil)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c79029574.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c79029574.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
		if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,TYPE_MONSTER) and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,tc:GetLevel(),nil,TYPE_MONSTER)
		Duel.Overlay(e:GetHandler(),g)
		Duel.Recover(tp,g:GetCount()*500,REASON_EFFECT)
		end
	end
end


