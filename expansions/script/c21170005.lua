--天启录D
function c21170005.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21170005+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c21170005.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21170005,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetCondition(c21170005.con2)
	e2:SetTarget(c21170005.tg2)
	e2:SetOperation(c21170005.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c21170005.con3)
	e3:SetOperation(c21170005.op3)
	c:RegisterEffect(e3)	
end
function c21170005.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c21170005.con0)
	e1:SetOperation(c21170005.op0)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c21170005.con0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c21170005.q(c)
	return c:IsAbleToHand() and not c:IsCode(21170005) and c:IsSetCard(0x6917) and c:GetOriginalType()==TYPE_SPELL
end
function c21170005.op0(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(10,0,21170005)
	if Duel.IsExistingMatchingCard(c21170005.q,tp,1,0,1,nil) then
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c21170005.q,tp,1,0,1,1,nil):GetFirst()
		if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(2) then
		local code=_G["c"..tc:GetOriginalCode()]
		local e1 = code.copy
		if not e1 then return end
		local tg=e1:GetTarget() or aux.TRUE
		local op=e1:GetOperation() or aux.TRUE
			if tg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(21170005,1)) then
			op(e,tp,eg,ep,ev,re,r,rp,0)
			end
		end
	end
	e:Reset()
end
function c21170005.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	return rp==1-tp and Duel.IsChainDisablable(ev)
end
function c21170005.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c21170005.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c21170005.con3(e,tp,eg,ep,ev,re,r,rp)
	return r&(REASON_LINK|REASON_FUSION|REASON_SYNCHRO)>0
end
function c21170005.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not rc:IsSetCard(0x6917) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21170005,1))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetCondition(c21170005.con2)
	e1:SetTarget(c21170005.tg2)
	e1:SetOperation(c21170005.op2)
	e1:SetOwnerPlayer(ep)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end