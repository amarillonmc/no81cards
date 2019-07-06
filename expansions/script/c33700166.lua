--轮回轮舞轮次轮回
function c33700166.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	 --damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700166,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,33700166)
	e2:SetCondition(c33700166.condition)
	e2:SetCost(c33700166.cost)
	e2:SetTarget(c33700166.target)
	e2:SetOperation(c33700166.operation)
	c:RegisterEffect(e2)
end
function c33700166.cfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
		and c:IsPreviousLocation(LOCATION_SZONE) 
end
function c33700166.condition(e,tp,eg,ep,ev,re,r,rp)
	return  bit.band(r,REASON_DESTROY)~=0 and eg:FilterCount(c33700166.cfilter,nil)==1
end
function c33700166.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c33700166.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:Filter(c33700166.cfilter,nil):IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg:Filter(c33700166.cfilter,nil),1,tp,LOCATION_GRAVE)
end
function c33700166.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=eg:Filter(c33700166.cfilter,nil):GetFirst()
   if tg:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) and Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)>0 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	e1:SetCondition(c33700166.thcon)
	e1:SetOperation(c33700166.thop)
	tg:RegisterEffect(e1)
end
end
function c33700166.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c33700166.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)   
end
