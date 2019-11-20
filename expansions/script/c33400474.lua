--不存在的过往
function c33400474.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,33400474+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c33400474.cost)
	e1:SetTarget(c33400474.sptg)
	e1:SetOperation(c33400474.operation)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
end
function c33400474.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c33400474.cfilter(c,e,tp)
	local nm
	if c:IsType(TYPE_XYZ) then nm=c:GetRank()
	elseif c:IsType(TYPE_LINK) then nm=2*(c:GetLinkMarker())
	else nm=c:GetLevel()
	end   
	return c:IsSetCard(0x341) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c33400474.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,nm) 
end
function c33400474.filter(c,e,tp,nm)
	return c:IsSetCard(0x341) and  c:IsType(TYPE_XYZ) and c:IsRank(nm)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) 
end
function c33400474.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then 
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and  Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c33400474.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	 end
	local g=Duel.SelectMatchingCard(tp,c33400474.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local g1=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33400474.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local nm
	if tc:IsType(TYPE_XYZ) then nm=tc:GetRank()
	elseif tc:IsType(TYPE_LINK) then nm=2*(tc:GetLinkMarker())
	else nm=tc:GetLevel()
	end   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33400474.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nm)
	if g:GetCount()>0 then
	   local tc1=g:GetFirst()
	   tc1:SetMaterial(nil)
	   Duel.SpecialSummon(tc1,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) 
	   tc1:CompleteProcedure()
		if c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.Overlay(tc1,Group.FromCards(c))
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e1,true)
		tc1:RegisterFlagEffect(33400474,RESET_EVENT+RESETS_STANDARD,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(tc)
		e2:SetCondition(c33400474.descon)
		e2:SetOperation(c33400474.desop)
		Duel.RegisterEffect(e2,tp)
	end
end
function c33400474.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(33400474)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c33400474.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,REASON_EFFECT)
end
