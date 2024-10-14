--罪秽之剑士 利布
function c75081001.initial_effect(c)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCountLimit(2,75081001)
	e1:SetTarget(c75081001.dreptg)
	e1:SetOperation(c75081001.drepop)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetRange(LOCATION_HAND)
	e2:SetOperation(c75081001.drepop1)
	c:RegisterEffect(e2) 
  
end
function c75081001.dreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
		and c:IsAbleToRemove() end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c75081001.drepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==75081001 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c75081001.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c75081001.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.ReturnToField(e:GetLabelObject())~=0 and Duel.GetFlagEffect(tp,75081001)==0 and Duel.SelectYesNo(tp,aux.Stringid(75081001,0)) then
		Duel.RegisterFlagEffect(tp,75081001,RESET_PHASE+PHASE_END,0,1)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil)
		if g:GetCount()>0 then
			local sg=g:RandomSelect(tp,1)
			sg:AddCard(c)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
--
function c75081001.drepop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	local fid=c:GetFieldID()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(c)
	e1:SetCondition(c75081001.retcon1)
	e1:SetOperation(c75081001.retop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	c:RegisterFlagEffect(75081001,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
end
function c75081001.retcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(75081001)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c75081001.spfilter(c,e,tp)
	return c:IsSetCard(0x75c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75081001.retop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c75081001.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,75081002)==0 and Duel.SelectYesNo(tp,aux.Stringid(75081001,1)) then
		Duel.RegisterFlagEffect(tp,75081002,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75081001.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
