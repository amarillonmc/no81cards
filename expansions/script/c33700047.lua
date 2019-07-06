--GUARDIAN的翔援
function c33700047.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33700047+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	 --sp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700047,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c33700047.spcost)
	e2:SetTarget(c33700047.sptg)
	e2:SetOperation(c33700047.spop)
	c:RegisterEffect(e2)
   if not c33700047.global_check then
		c33700047.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c33700047.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c33700047.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsPreviousLocation(LOCATION_MZONE)  and tc:IsReason(REASON_BATTLE+REASON_EFFECT) then
			 if tc:GetPreviousControler()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	 if p1 then Duel.RegisterFlagEffect(0,33700047,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,33700047,RESET_PHASE+PHASE_END,0,1) end
end
function c33700047.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFlagEffect(tp,33700047)==0 then
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1021,2,REASON_COST)  and Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0 end
	Duel.RemoveCounter(tp,1,0,0x1021,2,REASON_COST)
else
  if chk==0 then return  Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0 end
end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
end
function c33700047.spfilter(c,e,tp)
	return c:IsLevelAbove(5) and c:IsAttribute(ATTRIBUTE_EARTH) and  c:IsSetCard(0x441) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700047.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c33700047.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c33700047.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33700047.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		g:GetFirst():RegisterFlagEffect(33700047,RESET_EVENT+0x1fe0000,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(g:GetFirst())
		e2:SetCondition(c33700047.tdcon)
		e2:SetOperation(c33700047.tdop)
		Duel.RegisterEffect(e2,tp)
	end
end
function c33700047.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(33700047)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c33700047.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
