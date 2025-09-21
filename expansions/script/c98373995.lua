--幻在之更
function c98373995.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(c98373995.cost)
	e1:SetTarget(c98373995.target)
	e1:SetOperation(c98373995.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,98373995)
	e2:SetTarget(c98373995.settg)
	e2:SetOperation(c98373995.setop)
	c:RegisterEffect(e2)
	--count
	Duel.AddCustomActivityCounter(98373995,ACTIVITY_SUMMON,c98373995.counterfilter)
	Duel.AddCustomActivityCounter(98373995,ACTIVITY_SPSUMMON,c98373995.counterfilter)
end
function c98373995.counterfilter(c)
	return c:IsSetCard(0xaf0)
end
function c98373995.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(98373995,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(98373995,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98373995.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c98373995.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xaf0)
end
function c98373995.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c98373995.cfilter(c,chk)
	return c:IsSetCard(0xaf0) and c:IsFaceup() and (chk==0 or c:IsSummonLocation(LOCATION_EXTRA))
end
function c98373995.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and Duel.IsExistingMatchingCard(c98373995.cfilter,tp,LOCATION_MZONE,0,1,nil,0) and rc:IsRelateToEffect(re) and rc:IsAbleToRemove() and not rc:IsLocation(LOCATION_REMOVED) then
		Duel.BreakEffect()
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
end
function c98373995.tfilter(c)
	return c:IsSetCard(0xaf0) and c:IsFaceup() and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c98373995.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c98373995.tfilter,tp,LOCATION_ONFIELD,0,1,nil) and e:GetHandler():IsSSetable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectTarget(tp,c98373995.tfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c98373995.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_HAND) then return end
	else
		if Duel.SendtoGrave(tc,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_GRAVE) then return end
	end
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(98373995,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCondition(c98373995.accon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c98373995.accon(e)
	return Duel.IsExistingMatchingCard(c98373995.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,1)
end
