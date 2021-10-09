--背德露出
function c9951315.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9951315+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9951315.cost)
	e1:SetTarget(c9951315.target)
	e1:SetOperation(c9951315.activate)
	c:RegisterEffect(e1)
end
function c9951315.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c9951315.filter(c,e,tp,mc)
	return  c:IsLink(1) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9951315.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL)
		and Duel.IsExistingMatchingCard(c9951315.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9951315.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c9951315.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	if Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(9951315,RESET_EVENT+RESETS_STANDARD,0,1)
		tc:CompleteProcedure()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(tc)
		e2:SetCondition(c9951315.descon)
		e2:SetOperation(c9951315.desop)
		Duel.RegisterEffect(e2,tp)
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_FIELD)
	   e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	   e1:SetTargetRange(1,0)
	   e1:SetTarget(c9951315.splimit)
	   e1:SetReset(RESET_PHASE+PHASE_END)
	   Duel.RegisterEffect(e1,tp)
	end
end
function c9951315.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(9951315)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c9951315.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c9951315.splimit(e,c)
	return not c:IsType(TYPE_LINK) and c:IsLocation(LOCATION_EXTRA)
end

