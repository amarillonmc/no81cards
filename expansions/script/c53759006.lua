local m=53759006
local cm=_G["c"..m]
cm.name="心术对抗域"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.thcon)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.con)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetOperation(cm.mtop)
	c:RegisterEffect(e5)
end
function cm.filter(c)
	return c:IsType(TYPE_QUICKPLAY) and c:IsSetCard(0x6e) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.con(e)
	return Duel.IsExistingMatchingCard(function(c)return c:IsSetCard(0x41) and c:IsFaceup()end,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return e:GetHandler():GetFlagEffect(m)==0 and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_QUICKPLAY) and rc:IsRelateToEffect(re) and Duel.IsPlayerCanSendtoHand(tp,rc) and rc:IsStatus(STATUS_LEAVE_CONFIRMED) and rc:IsSetCard(0x6e) and Duel.IsExistingMatchingCard(function(c)return c:IsSetCard(0x41) and c:IsFaceup()end,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectEffectYesNo(tp,rc,aux.Stringid(m,0)) then
		rc:CancelToGrave()
		Duel.SendtoHand(rc,nil,REASON_EFFECT)
		e:GetHandler():RegisterFlagEffect(m,RESET_PHASE+PHASE_END,0,0)
	end
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,800) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.PayLPCost(tp,800)
	else Duel.Destroy(e:GetHandler(),REASON_COST) end
end
