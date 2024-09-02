--清荷·花信
function c16372006.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,16372006)
	e1:SetCost(c16372006.spcost)
	e1:SetTarget(c16372006.sptg)
	e1:SetOperation(c16372006.spop)
	c:RegisterEffect(e1)
	--setself
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,16372006+100)
	e2:SetCost(c16372006.costoath)
	e2:SetCondition(c16372006.setscon)
	e2:SetTarget(c16372006.setstg)
	e2:SetOperation(c16372006.setsop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c16372006.negcon)
	e3:SetOperation(c16372006.negop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(16372006,ACTIVITY_SPSUMMON,c16372006.counterfilter)
end
function c16372006.counterfilter(c)
	return c:IsRace(RACE_PLANT)
end
function c16372006.costoath(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(16372006,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16372006.splimitoath)
	Duel.RegisterEffect(e1,tp)
end
function c16372006.splimitoath(e,c)
	return not c:IsRace(RACE_PLANT)
end
function c16372006.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xdc1) and c:GetOriginalType()&TYPE_MONSTER>0 and c:GetSequence()<5
		and c:IsAbleToGraveAsCost()
end
function c16372006.cfilter2(c)
	return c:IsSetCard(0xdc1) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c16372006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c16372006.cfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
	local b2=Duel.IsExistingMatchingCard(c16372006.cfilter2,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return (b1 or b2)
		and Duel.GetCustomActivityCount(16372006,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16372006.splimitoath)
	Duel.RegisterEffect(e1,tp)
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(16372006,5),1},{b2,aux.Stringid(16372006,6),2})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c16372006.cfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c16372006.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c16372006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c16372006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c16372006.setscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c16372006.setstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c16372006.setsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
	local p=aux.SelectFromOptions(tp,{b1,aux.Stringid(16372000+1,5),tp},{b2,aux.Stringid(16372000+1,6),1-tp})
	if p~=nil and Duel.MoveToField(c,tp,p,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function c16372006.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsRace(RACE_PLANT)
		and e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c16372006.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,16372006)
	Duel.NegateEffect(ev,true)
end