--流界女
local m=57300009
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.thtg2)
	e1:SetOperation(cm.thop2)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCountLimit(1,m+100)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.thfilter(c)
	return c:IsSetCard(0x3520) and c:IsAbleToRemove()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFlagEffect(tp,0x3520)~=0 then
	Duel.ResetFlagEffect(tp,0x3520) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	if Duel.GetFlagEffect(tp,0x3520)==0 then
	Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,0x3520)~=0 then
	Duel.ResetFlagEffect(tp,0x3520) end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
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
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFlagEffect(tp,0x3520)~=0 then
	Duel.ResetFlagEffect(tp,0x3520) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if Duel.GetFlagEffect(tp,0x3520)==0 then
	Duel.RegisterFlagEffect(tp,0x3520,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,0x3520)~=0 then
	Duel.ResetFlagEffect(tp,0x3520) end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
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
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFlagEffect(tp,0x3520)~=0 then
	Duel.ResetFlagEffect(tp,0x3520) end
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
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
