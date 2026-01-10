--照亮暗夜的月光 卡米拉
function c75081061.initial_effect(c)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75081061,2))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(2,75081061)
	--e1:SetCondition(c75081061.drepcon)
	e1:SetTarget(c75081061.dreptg)
	e1:SetOperation(c75081061.drepop)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetRange(LOCATION_HAND)
	e2:SetOperation(c75081061.drepop1)
	c:RegisterEffect(e2)
end
function c75081061.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x75c)
end
function c75081061.drepcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75081061.cfilter,1,nil) and e:GetHandler():GetFlagEffect(75081061)==0
end  
function c75081061.dreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	c:RegisterFlagEffect(75081061,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c75081061.drepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==75081061 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c75081061.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c75081061.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.ReturnToField(e:GetLabelObject())~=0 and c:IsLocation(LOCATION_MZONE)  and Duel.GetFlagEffect(tp,75081061)==0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(75081061,0)) then
		Duel.RegisterFlagEffect(tp,75081061,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
--
function c75081061.drepop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	local fid=c:GetFieldID()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(c)
	e1:SetCondition(c75081061.retcon1)
	e1:SetOperation(c75081061.retop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	c:RegisterFlagEffect(75081061,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
end
function c75081061.retcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(75081061)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c75081061.thfilter(c)
	return c:IsSetCard(0x75c) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c75081061.retop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c75081061.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,75081062)==0 and Duel.SelectYesNo(tp,aux.Stringid(75081061,1)) then
		Duel.RegisterFlagEffect(tp,75081062,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c75081061.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end


