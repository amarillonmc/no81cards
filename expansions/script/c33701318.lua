--生自虚拟世界的风
function c33701318.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33701318+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c33701318.cost)
	e1:SetTarget(c33701318.target)
	e1:SetOperation(c33701318.activate)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
end
function c33701318.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c33701318.costfilter(c,e,tp)
	if c:GetSummonLocation()~=LOCATION_EXTRA then
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c33701318.spfilter,tp,LOCATION_DECK,0,1,nil,c,e,tp)
	and Duel.GetMZoneCount(tp,c)>0
	else
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c33701318.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,c,e,tp)
	and Duel.GetMZoneCount(tp,c)>0
	end
end
function c33701318.spfilter(c,tc,e,tp)
	return ((c:IsSetCard(0x344c) and c:IsLocation(LOCATION_DECK)) or
		   ((c:IsSetCard(0x445)) and c:IsLocation(LOCATION_EXTRA)))
		and c:GetOriginalAttribute()==tc:GetOriginalAttribute()
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c33701318.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.CheckReleaseGroup(tp,c33701318.costfilter,1,nil,e,tp)
	end
	e:SetLabel(0)
	local g=Duel.SelectReleaseGroup(tp,c33701318.costfilter,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c33701318.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:GetSummonLocation()==LOCATION_EXTRA then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g=Duel.SelectMatchingCard(tp,c33701318.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,tc,e,tp):GetFirst()
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g=Duel.SelectMatchingCard(tp,c33701318.spfilter,tp,LOCATION_DECK,0,1,1,nil,tc,e,tp):GetFirst()  
	end  
	if Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP) then
		local fid=c:GetFieldID()
		g:RegisterFlagEffect(33701318,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetLabel(fid)
		e3:SetLabelObject(g)
		e3:SetCondition(c33701318.thcon1)
		e3:SetOperation(c33701318.thop1)
		Duel.RegisterEffect(e3,tp)
		Duel.SpecialSummonComplete()
	end
end
function c33701318.thcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(33701318)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c33701318.thop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
end

