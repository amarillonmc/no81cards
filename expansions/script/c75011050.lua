--炼金工房一锅炖
function c75011050.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(c75011050.target)
	e1:SetOperation(c75011050.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1190)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c75011050.thcon1)
	--e2:SetCost(aux.bfgcost)
	e2:SetTarget(c75011050.thtg)
	e2:SetOperation(c75011050.thop)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetCode(EVENT_DAMAGE)
	e5:SetCondition(c75011050.thcon2)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(75011050,ACTIVITY_CHAIN,c75011050.chainfilter)
end
function c75011050.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsCode(75011050) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c75011050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c75011050.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Recover(p,d,REASON_EFFECT)==0 then return end
	local ct=Duel.GetCustomActivityCount(75011050,tp,ACTIVITY_CHAIN)
	if ct>=1 and Duel.IsExistingMatchingCard(Card.IsStatus,tp,0,LOCATION_MZONE,1,nil,STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN) and Duel.SelectYesNo(tp,aux.Stringid(75011050,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,Card.IsStatus,tp,0,LOCATION_MZONE,1,1,nil,STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN):GetFirst()
		Duel.HintSelection(Group.FromCards(tc))
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(75011050,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(75011050,3))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c75011050.descon)
		e1:SetOperation(c75011050.desop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e2,tp)
	end
	if ct>=2 and Duel.SelectYesNo(tp,aux.Stringid(75011050,1)) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x75e))
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if ct>=3 and Duel.SelectYesNo(tp,aux.Stringid(75011050,2)) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x75e))
		e1:SetCondition(c75011050.atkcon)
		e1:SetValue(1000)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c75011050.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x75e)
end
function c75011050.descon(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(c75011050.ctfilter,1,nil) then return false end
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(75011050)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c75011050.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,75011050)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
function c75011050.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function c75011050.chkfilter(c,tp,rp)
	return c:IsPreviousControler(1-tp) and rp==tp
end
function c75011050.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75011050.chkfilter,1,nil,tp,rp)
end
function c75011050.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and bit.band(r,REASON_EFFECT)~=0
end
function c75011050.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c75011050.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
