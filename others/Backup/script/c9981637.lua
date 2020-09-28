--你妈疑惑？
function c9981637.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9981637+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9981637.cost)
	e1:SetTarget(c9981637.target)
	e1:SetOperation(c9981637.activate)
	c:RegisterEffect(e1)
end
function c9981637.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c9981637.filter(c,e,tp,mc)
	return  c:IsLevelBelow(6) and c:IsType(TYPE_RITUAL)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9981637.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981637.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9981637.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c9981637.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(9981637,RESET_EVENT+RESETS_STANDARD,0,1)
		tc:CompleteProcedure()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(tc)
		e2:SetCondition(c9981637.descon)
		e2:SetOperation(c9981637.desop)
		Duel.RegisterEffect(e2,tp)
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_FIELD)
	   e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	   e1:SetTargetRange(1,0)
	   e1:SetTarget(c9981637.splimit)
	   e1:SetReset(RESET_PHASE+PHASE_END)
	   Duel.RegisterEffect(e1,tp)
	end
end
function c9981637.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(9981637)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c9981637.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c9981637.splimit(e,c)
	return not c:IsType(TYPE_RITUAL) and c:IsLocation(LOCATION_HAND)
end


