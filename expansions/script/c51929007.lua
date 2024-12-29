--集光少女 魔法钻石
function c51929007.initial_effect(c)
	c:SetSPSummonOnce(51929007)
	--spsummon-self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1152)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c51929007.spcon)
	e1:SetTarget(c51929007.sptg)
	e1:SetOperation(c51929007.spop)
	c:RegisterEffect(e1)
	--collect light!
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c51929007.setcon)
	e2:SetOperation(c51929007.setop)
	c:RegisterEffect(e2)
c51929007.fusion_effect=true
end
function c51929007.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c51929007.mfilter(c,e)
	return c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c51929007.ffilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x3258) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c51929007.exfilter(c,e)
	return c:IsCanBeFusionMaterial() and c51929007.mfilter(c,e) and ((c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)) or (c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:GetSequence()<5 and c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER))
end
function c51929007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=1<<c:GetSequence()
	if chk==0 then
		if not c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) then return false end
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c51929007.mfilter,nil,e)
			+Duel.GetMatchingGroup(c51929007.exfilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,nil,e)
		local res=Duel.IsExistingMatchingCard(c51929007.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c51929007.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD)
end
function c51929007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local c=e:GetHandler()
	local zone=1<<c:GetSequence()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)==0 then return end
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c51929007.mfilter,nil,e)
		+Duel.GetMatchingGroup(c51929007.exfilter,tp,LOCATION_SZONE+LOCATION_GRAVE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c51929007.ffilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c51929007.ffilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if #sg1>0 or (sg2~=nil and #sg2>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		::cancel::
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			if #mat<2 then goto cancel end
			tc:SetMaterial(mat)
			Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			if #mat<2 then goto cancel end
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat)
		end
		tc:CompleteProcedure()
	end
end
function c51929007.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c51929007.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not c:IsRelateToEffect(e) then return end
	if not Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(e1)
end
