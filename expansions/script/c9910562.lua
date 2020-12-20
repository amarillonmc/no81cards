--甜心机仆 永恒的礼物
function c9910562.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9910562.rmcon)
	e1:SetOperation(c9910562.rmop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_MOVE)
	e2:SetCondition(c9910562.drcon)
	e2:SetTarget(c9910562.drtg)
	e2:SetOperation(c9910562.drop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_MOVE)
	e3:SetCondition(c9910562.rmcon2)
	e3:SetTarget(c9910562.rmtg2)
	e3:SetOperation(c9910562.rmop2)
	c:RegisterEffect(e3)
end
function c9910562.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK 
end
function c9910562.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if c:IsFaceup() and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910562,0)) then
		Duel.Hint(HINT_CARD,0,9910562)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		sg:AddCard(c)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
		local og=Duel.GetOperatedGroup()
		if og:GetCount()~=2 then return end
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(9910562,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			oc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCountLimit(1)
		e1:SetCondition(c9910562.retcon)
		e1:SetOperation(c9910562.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910562.retfilter(c,fid)
	return c:GetFlagEffectLabel(9910562)==fid
end
function c9910562.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g:FilterCount(c9910562.retfilter,nil,e:GetLabel())~=2 then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c9910562.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if Duel.SelectYesNo(tp,aux.Stringid(9910562,1)) then
		Duel.ReturnToField(g:GetFirst())
		Duel.ReturnToField(g:GetNext())
		g:DeleteGroup()
		e:Reset()
	end
end
function c9910562.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON)
end
function c9910562.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9910562.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c9910562.rmcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_REMOVED) and c:IsReason(REASON_RETURN)
end
function c9910562.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil,tp,POS_FACEDOWN) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c9910562.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil,tp,POS_FACEDOWN)
	local tc=g:GetFirst()
	if tc==nil or Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)==0 then return end
	local fid=c:GetFieldID()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(tc)
	e1:SetCondition(c9910562.thcon)
	e1:SetOperation(c9910562.thop)
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		e1:SetValue(Duel.GetTurnCount())
		tc:RegisterFlagEffect(9910563,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2,fid)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		e1:SetValue(0)
		tc:RegisterFlagEffect(9910563,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1,fid)
	end
	Duel.RegisterEffect(e1,tp)
end
function c9910562.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetValue()
end
function c9910562.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:GetFlagEffectLabel(9910563)==e:GetLabel() then
		Duel.Hint(HINT_CARD,0,9910562)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
