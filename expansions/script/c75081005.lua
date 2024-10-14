--罪秽之魔女 史菈希尔
function c75081005.initial_effect(c)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75081005,2))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2,75081005)
	e1:SetCondition(c75081005.drepcon)
	e1:SetTarget(c75081005.dreptg)
	e1:SetOperation(c75081005.drepop)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetRange(LOCATION_HAND)
	e2:SetOperation(c75081005.drepop1)
	c:RegisterEffect(e2)
end
function c75081005.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x75c)
end
function c75081005.drepcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75081005.cfilter,1,nil)
end  
function c75081005.dreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c75081005.drepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==75081005 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c75081005.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c75081005.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.ReturnToField(e:GetLabelObject())~=0 and Duel.GetFlagEffect(tp,75081005)==0 and Duel.SelectYesNo(tp,aux.Stringid(75081005,0)) then
		Duel.RegisterFlagEffect(tp,75081005,RESET_PHASE+PHASE_END,0,1)
		local ct=1
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetTargetRange(0,LOCATION_MZONE)
		if Duel.GetTurnPlayer()==1-tp then
			ct=2
		end
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,ct)
		Duel.RegisterEffect(e1,tp)
	end
end
--
function c75081005.drepop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	local fid=c:GetFieldID()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(c)
	e1:SetCondition(c75081005.retcon1)
	e1:SetOperation(c75081005.retop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	c:RegisterFlagEffect(75081005,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
end
function c75081005.retcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(75081005)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c75081005.spfilter(c,e,tp)
	return c:IsSetCard(0x75c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75081005.retop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c75081005.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,75081006)==0 and Duel.SelectYesNo(tp,aux.Stringid(75081005,1)) then
		Duel.RegisterFlagEffect(tp,75081006,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75081005.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

