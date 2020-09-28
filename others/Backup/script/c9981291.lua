--骑士时刻-真王斩！
function c9981291.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c9981291.target)
	e1:SetOperation(c9981291.activate)
	c:RegisterEffect(e1)
 --control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981291,0))
	e2:SetCategory(CATEGORY_CONTROL+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9981291)
	e2:SetCondition(c9981291.ctcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9981291.cttg)
	e2:SetOperation(c9981291.ctop)
	c:RegisterEffect(e2)
end
function c9981291.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6bc3)
end
function c9981291.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsAbleToRemove() and chkc:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c9981291.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c9981291.cfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),1-tp,LOCATION_GRAVE+LOCATION_ONFIELD)
end
function c9981291.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981291,0))
end
function c9981291.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c9981291.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbca) and c:IsControlerCanBeChanged()
end
function c9981291.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c9981291.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9981291.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c9981291.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c9981291.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbca)
end
function c9981291.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp)~=0 then
		local atk=0
		local g=Duel.GetMatchingGroup(c9981291.atkfilter,tp,LOCATION_MZONE,0,nil)
		if g:GetCount()>0 then atk=g:GetSum(Card.GetBaseAttack) end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c9981291.ftarget)
		e2:SetLabel(tc:GetFieldID())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981291,0))
end
function c9981291.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
