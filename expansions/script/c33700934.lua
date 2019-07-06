--齿械公主的空虚啸
function c33700934.initial_effect(c)
	 --sdasd
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c33700934.cost)
	e1:SetTarget(c33700934.target)
	e1:SetOperation(c33700934.operation)
	c:RegisterEffect(e1)   
end
function c33700934.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c33700934.cfilter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c33700934.cfiltr2,tp,LOCATION_DECK,0,1,c,tp,c) 
end
function c33700934.cfilter2(c,tp,rc)
	local g=Group.FromCards(c,rc)
	return c:IsAbleToGrave() and c:IsCode(rc:GetCode()) and Duel.IsExistingMatchingCard(c33700934.cfiltr3,tp,LOCATION_DECK,0,1,g,c:GetCode()) and c:IsType(TYPE_MONSTER)
end
function c33700934.cfilter3(c,code)
	return c:IsCode(code) and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c33700934.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then e:SetLabel(0) return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c33700934.cfilter,1,nil,tp)
	end
	e:SetLabel(0)
	local g=Duel.SelectReleaseGroup(tp,c33700934.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c33700934.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c33700934.cfiltr2,tp,LOCATION_DECK,0,1,nil,tp,tc)
	if #tg<=0 or Duel.SendtoGrave(tg,REASON_EFFECT)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc2=Duel.SelectMatchingCard(tp,c33700934.cfiltr3,tp,LOCATION_DECK,0,1,nil,tc:GetCode()):GetFirst()
	if not tc2 or Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)<=0 then return end
	local fid=tc2:GetFieldID()
	local ct=1 
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()<=PHASE_STANDBY then ct=2 end
	tc2:RegisterFlagEffect(33700934,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,ct,fid)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,ct)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetLabelObject(tc2)
	e2:SetValue(fid)
	e2:SetLabel(Duel.GetTurnCount())
	e2:SetCondition(c33700934.thcon)
	e2:SetOperation(c33700934.thop)
	Duel.RegisterEffect(e2,tp)
end
function c33700934.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(33700934)~=e:GetValue() or Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetLabel() then
		e:Reset()
		return false
	else
		return true
	end
end
function c33700934.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,33700934)
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end