--流界女·不死升阶
local m=57300010
local cm=_G["c"..m]
function cm.initial_effect(c)
	--be Remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetCountLimit(1,m+100)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFlagEffect(tp,0x3520)~=0 then
	Duel.ResetFlagEffect(tp,0x3520) end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
	if Duel.GetFlagEffect(tp,0x3520)==0 then
	Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,0x3520)~=0 then
	Duel.ResetFlagEffect(tp,0x3520) end
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g2:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	--cant remove,cant activate
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.flagcon)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetFlagEffect(tp,0x3520)==0 then
	Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(1,0)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetValue(cm.actlimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--
	if Duel.GetFlagEffect(tp,0x3520)==0 then
	Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
end
function cm.filter(c)
	return c:IsAbleToHand()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if Duel.GetFlagEffect(tp,0x3520)~=0 then
	Duel.ResetFlagEffect(tp,0x3520) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	if Duel.GetFlagEffect(tp,0x3520)==0 then
	Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,0x3520)~=0 then
	Duel.ResetFlagEffect(tp,0x3520) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local tg1=Duel.GetOperatedGroup()
				local tc=tg1:GetFirst()	
				if tc:IsLocation(LOCATION_REMOVED) and tc:GetOwner()==1-tp and tc:GetType()==TYPE_MONSTER then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CANNOT_TRIGGER)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
					e1:SetReset(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e1)
				end
	end
	--cant remove,cant activate
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.flagcon)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetFlagEffect(tp,0x3520)==0 then
	Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(1,0)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetValue(cm.actlimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--
	if Duel.GetFlagEffect(tp,0x3520)==0 then
	Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
end

	--flag,limit
function cm.flagcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,0x3520)~=0
end
function cm.actlimit(e,re,tp)
	local c=re:GetHandler()
	return c:IsLocation(LOCATION_REMOVED) and not c:IsSetCard(0x3520)
end
	--

--tg and op
	--if Duel.GetFlagEffect(tp,0x3520)~=0 then
	--Duel.ResetFlagEffect(tp,0x3520) end
	--if Duel.GetFlagEffect(tp,0x3520)==0 then
	--Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
--
