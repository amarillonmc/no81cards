--流界女·天使之堕
local m=57300011
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.smtg)
	e1:SetOperation(cm.smop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetCountLimit(1,m+100)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
	local e2=e3:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFlagEffect(tp,0x3520)~=0 then
	Duel.ResetFlagEffect(tp,0x3520) end
	if chk==0 then return Duel.GetDecktopGroup(tp,4):FilterCount(Card.IsAbleToRemove,nil)==4 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,4,1-tp,LOCATION_DECK)
	if Duel.GetFlagEffect(tp,0x3520)==0 then
	Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,0x3520)~=0 then
	Duel.ResetFlagEffect(tp,0x3520) end
	local g=Duel.GetDecktopGroup(tp,4)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	if Duel.GetFlagEffect(tp,0x3520)==0 then
	Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
end
function cm.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFlagEffect(tp,0x3520)~=0 then
	Duel.ResetFlagEffect(tp,0x3520) end
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
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
function cm.smop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,0x3520)~=0 then
	Duel.ResetFlagEffect(tp,0x3520) end
		local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_REMOVED,0,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
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
function cm.fil(c,tp)
	return c:GetOwner()==tp
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