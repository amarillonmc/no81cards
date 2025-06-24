--「」下级三号
function c44401003.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c44401003.condition)
	e1:SetTarget(c44401003.target)
	e1:SetOperation(c44401003.operation)
	c:RegisterEffect(e1)
	--run!
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_QUICK_F)
	e0:SetCode(EVENT_BECOME_TARGET)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c44401003.runcon)
	e0:SetCost(c44401003.run)
	e0:SetTarget(c44401003.runtg)
	e0:SetOperation(c44401003.runop)
	c:RegisterEffect(e0)
	--sign
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetOperation(c44401003.regop)
	c:RegisterEffect(e2)
end
function c44401003.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c44401003.cfilter(c,e,tp,check)
	return c:IsRace(RACE_PSYCHO) and c:IsLocation(LOCATION_HAND+LOCATION_MZONE) and c:IsSummonable(true,nil) or check and c:IsSetCard(0xa4a) and c:IsLocation(LOCATION_DECK+LOCATION_REMOVED) and c:IsFaceupEx() and Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c44401003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local check=c:IsSummonType(SUMMON_TYPE_NORMAL) and c:GetFlagEffect(44401003)==0
	if chk==0 then return Duel.IsExistingMatchingCard(c44401003.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp,check) end
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(44401003,4))
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c44401003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local check=c:IsRelateToEffect(e) and c:IsSummonType(SUMMON_TYPE_NORMAL) and c:GetFlagEffect(44401003)==0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,c44401003.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e,tp,check):GetFirst()
	if not tc then return end
	if tc:IsLocation(LOCATION_HAND+LOCATION_MZONE) then
		Duel.Summon(tp,tc,true,nil)
	else
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
		c:RegisterFlagEffect(44401003,RESET_EVENT+RESETS_WITHOUT_TEMP_REMOVE+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(44401003,0))
	end
end
function c44401003.runcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c44401003.run(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAIN_END)
		e0:SetReset(RESET_PHASE+PHASE_END)
		e0:SetLabelObject(c)
		e0:SetCountLimit(1)
		e0:SetOperation(c44401003.retop)
		Duel.RegisterEffect(e0,tp)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(44401003,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(44401001)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		c:RegisterEffect(e1)
	end
end
function c44401003.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c44401003.runtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_GRAVE)
end
function c44401003.runop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c44401003.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_NORMAL) then return end
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_WITHOUT_TEMP_REMOVE,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(44401003,3))
end
