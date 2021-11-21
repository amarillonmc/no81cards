--治安战警队 肆
function c22180090.initial_effect(c)
	--spsummon cost
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetCode(EFFECT_SPSUMMON_COST)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e01:SetCost(c22180090.spcost)
	e01:SetOperation(c22180090.spcop)
	c:RegisterEffect(e01)
	local e02=e01:Clone()
	e02:SetCode(EFFECT_SUMMON_COST)
	c:RegisterEffect(e02)
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22180090)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c22180090.mattg)
	e1:SetValue(c22180090.matval)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22180090,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_MAIN_END,TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,22180091)
	e2:SetCondition(c22180090.rmcon)
	e2:SetCost(c22180090.rmcost)
	e2:SetOperation(c22180090.rmop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(22180090,ACTIVITY_SPSUMMON,c22180090.counterfilter)
	Duel.AddCustomActivityCounter(22180090,ACTIVITY_SUMMON,c22180090.counterfilter)
end
function c22180090.spcost(e,c,tp)
	return Duel.GetCustomActivityCount(22180090,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetCustomActivityCount(22180090,tp,ACTIVITY_SUMMON)==0
end
function c22180090.spcop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c22180090.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c22180090.counterfilter(c)
	return c:IsSetCard(0x156) or not c:IsSummonLocation(LOCATION_HAND) or not c:IsSummonLocation(LOCATION_GRAVE)
end
function c22180090.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x156) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c22180090.mattg(e,c)
	local cg=c:GetColumnGroup()
	return c:IsLocation(LOCATION_MZONE) and cg:IsExists(c22180090.cfilter,1,nil,e:GetHandlerPlayer())
end
function c22180090.exmfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x156) and c:IsControler(tp)
end
function c22180090.matval(e,lc,mg,c,tp)
	return true,not mg or mg:IsExists(c22180090.exmfilter,1,nil,tp)
end
function c22180090.cfilter2(c)
	return c:IsSetCard(0x156) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c22180090.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c22180090.rmcheck(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetLocation)==#sg
end
function c22180090.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22180090.cfilter2,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.GetMatchingGroup(c22180090.cfilter2,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,nil)
	local sg=g:SelectSubGroup(tp,c22180090.rmcheck,false,1,3)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	e:SetLabelObject(sg)
	local tc=sg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(22180090,RESET_EVENT+RESETS_STANDARD,0,0)
		tc=sg:GetNext()
	end
	sg:KeepAlive()
end
function c22180090.splimit(e,c)
	return not c:IsSetCard(0x156) and (c:IsSummonLocation(LOCATION_HAND) or c:IsSummonLocation(LOCATION_GRAVE))
end
function c22180090.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetLabelObject(g)
	e1:SetCondition(c22180090.spcon)
	e1:SetOperation(c22180090.spop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local ge1=Effect.CreateEffect(e:GetHandler())
	ge1:SetType(EFFECT_TYPE_FIELD)
	ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	ge1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ge1:SetReset(RESET_PHASE+PHASE_END)
	ge1:SetTargetRange(1,0)
	ge1:SetTarget(c22180090.splimit)
	Duel.RegisterEffect(ge1,tp)
	local e2=ge1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c22180090.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>e:GetLabel()
end
function c22180090.spfilter(c,e,tp)
	return c:IsLocation(LOCATION_REMOVED) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetFlagEffect(22180090)~=0 and c:GetReasonEffect():GetHandler()==e:GetHandler()
end
function c22180090.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22180090)
	local c=e:GetHandler()
	local g=e:GetLabelObject():Filter(c22180090.spfilter,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or g:GetCount()==0 or (ft>1 and g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if g:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c22180090.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
