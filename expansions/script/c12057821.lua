--教导的魔剑士 维兹
function c12057821.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12057821)
	e1:SetCondition(c12057821.discon)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c12057821.distg)
	e1:SetOperation(c12057821.disop)
	c:RegisterEffect(e1) 
	--to hand   
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9798352,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22057821)
	e2:SetCondition(c12057821.thcon)
	e2:SetTarget(c12057821.thtg)
	e2:SetOperation(c12057821.thop)
	c:RegisterEffect(e2) 
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,32057821)
	e3:SetCost(c12057821.atkcost)
	e3:SetTarget(c12057821.atktg)
	e3:SetOperation(c12057821.atkop)
	c:RegisterEffect(e3)
end
function c12057821.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and bit.band(re:GetActivateLocation(),LOCATION_HAND+LOCATION_GRAVE)~=0 and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) 
end
function c12057821.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_ONFIELD,0,1,nil,0x145,0x16b) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0) 
end
function c12057821.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev) 
end
function c12057821.ckfil(c,e,tp) 
	return c:IsSetCard(0x145,0x16b) and c:GetPreviousControler()==tp and c:GetReasonPlayer()~=tp 
end 
function c12057821.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12057821.ckfil,1,nil,e,tp)
end
function c12057821.thfilter(c)
	return c:IsFaceup() and c:GetType()==TYPE_TRAP and c:IsSSetable()
end
function c12057821.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c12057821.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then 
	Duel.BreakEffect() 
	local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst() 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(0)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	tc:RegisterEffect(e2)
	end
end
function c12057821.ctfil(c) 
	return c:IsSetCard(0x145,0x16b) and c:IsAbleToRemoveAsCost()
end
function c12057821.atkcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c12057821.ctfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,e:GetHandler()) end  
	local g=Duel.SelectMatchingCard(tp,c12057821.ctfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,e:GetHandler()) 
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c12057821.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c12057821.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e1)
	end 
end
