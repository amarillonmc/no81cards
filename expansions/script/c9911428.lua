--灵光乍现
function c9911428.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DICE+CATEGORY_DRAW+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9911428+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9911428.target)
	e1:SetOperation(c9911428.activate)
	c:RegisterEffect(e1)
end
c9911428.toss_dice=true
function c9911428.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp,POS_FACEDOWN)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=6 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c9911428.ogfilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end
function c9911428.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,tp,POS_FACEDOWN)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,1,#g,nil)
	if Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)==0 then return end
	local og=Duel.GetOperatedGroup():Filter(c9911428.ogfilter,nil)
	if #og==0 then return end
	local fid=c:GetFieldID()
	for tc in aux.Next(og) do
		tc:RegisterFlagEffect(9911428,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2,fid)
	end
	og:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1:SetLabel(fid,Duel.GetTurnCount())
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetLabel(fid,0)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	e1:SetLabelObject(og)
	e1:SetCountLimit(1)
	e1:SetCondition(c9911428.retcon)
	e1:SetOperation(c9911428.retop)
	Duel.RegisterEffect(e1,tp)
	local ct1=og:FilterCount(Card.IsPreviousLocation,nil,LOCATION_HAND)
	local ct2=og:FilterCount(Card.IsPreviousLocation,nil,LOCATION_MZONE)
	local d=Duel.TossDice(tp,1)
	if d==ct1 or d==ct2 then Duel.Draw(tp,d,REASON_EFFECT)
	else Duel.DiscardDeck(tp,d,REASON_EFFECT) end
end
function c9911428.retfilter(c,fid)
	return c:GetFlagEffectLabel(9911428)==fid
end
function c9911428.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local lab1,lab2=e:GetLabel()
	if not g:IsExists(c9911428.retfilter,1,nil,lab1) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return Duel.GetTurnCount()~=lab2 end
end
function c9911428.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local lab1,lab2=e:GetLabel()
	local sg=g:Filter(c9911428.retfilter,nil,lab1)
	g:DeleteGroup()
	for tc in aux.Next(sg) do
		local loc=tc:GetPreviousLocation()
		if loc==LOCATION_HAND then
			Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
		end
		if loc==LOCATION_MZONE then
			Duel.ReturnToField(tc)
		end
	end
end
