--围绕地球的圆弧
function c36700134.initial_effect(c)
	c:SetUniqueOnField(1,0,36700134)
	c:EnableCounterPermit(0xc23)
	c:SetCounterLimit(0xc23,26)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(c36700134.ctop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,36700134)
	e2:SetCondition(c36700134.spcon)
	e2:SetCost(c36700134.spcost)
	e2:SetTarget(c36700134.sptg)
	e2:SetOperation(c36700134.spop)
	c:RegisterEffect(e2)
	--check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c36700134.regop)
	c:RegisterEffect(e3)
end
function c36700134.ctfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousLevelOnField()>=5
end
function c36700134.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c36700134.ctfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0xc23,ct,true)
	end
end
function c36700134.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0xc23)==26
end
function c36700134.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	local ct=c:GetFlagEffectLabel(36700134)
	if not ct then ct=0 end
	e:SetLabel(ct)
	Duel.SendtoGrave(c,REASON_COST)
end
function c36700134.spfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xc22) and c:CheckFusionMaterial()
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c36700134.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(c36700134.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c36700134.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c36700134.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
		tc:CompleteProcedure()
		local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		if #g>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
			local ct=e:GetLabel()
			Duel.Damage(1-tp,tc:GetAttack()*ct,REASON_EFFECT)
		end
	end
end
function c36700134.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffectLabel(36700134)
	if not ct then
		c:RegisterFlagEffect(36700134,RESET_EVENT+RESETS_STANDARD,0,1,1)
	else
		c:SetFlagEffectLabel(36700134,ct+1)
	end
end
