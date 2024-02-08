--天峦之王
local cm,m=GetID()
function cm.initial_effect(c)
	--public
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHANGE_POS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAINING)
		ge2:SetOperation(cm.checkop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(Card.IsPreviousPosition,nil,POS_FACEDOWN)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(m-1,RESET_EVENT+0x7c0000,0,1)
		end
	end
end
function cm.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsPreviousPosition(POS_FACEDOWN) and not rc:IsStatus(STATUS_ACT_FROM_HAND) then
		rc:RegisterFlagEffect(m-1,RESET_EVENT+0x7c0000,0,1)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)>0 and c:IsFaceup() then
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(m,3))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(c)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e2:SetLabel(fid)
		e2:SetLabelObject(c)
		e2:SetCondition(cm.indcon)
		e2:SetTarget(cm.indtg)
		e2:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
end
function cm.indcon(e)
	local c=e:GetLabelObject()
	return c:GetFlagEffectLabel(m)==e:GetLabel()
end
function cm.indtg(e,c)
	return c:IsFacedown() or c:GetFlagEffect(m-1)>0
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return r&REASON_EFFECT>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	if c:IsPreviousLocation(LOCATION_REMOVED) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function cm.thfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsAbleToHand()
end
function cm.cffilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) or c:GetOwner()==1-tp
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
		if e:GetLabel()==1 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,3,nil)
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			sg=sg:Filter(cm.cffilter,nil,tp)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetLabel(Duel.GetTurnCount()+1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetCondition(cm.rmcon)
	e1:SetOperation(cm.rmop)
	e1:SetOwnerPlayer(tp)
	Duel.RegisterEffect(e1,tp)
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetOwnerPlayer()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end