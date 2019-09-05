--黑白视界·沉浸
function c77771005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c77771005.condition)
	e1:SetTarget(c77771005.target)
	e1:SetOperation(c77771005.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c77771005.handcon)
	c:RegisterEffect(e2)
	  --to hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,77771005)
	e3:SetCondition(c77771005.setcon)	
	e3:SetTarget(c77771005.settg)
	e3:SetOperation(c77771005.setop)
	c:RegisterEffect(e3)
	end
function c77771005.handcon(e)
   local g=Duel.GetMatchingGroup(c77771005.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)
    return g:GetClassCount(Card.GetCode)>=3
end
function c77771005.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x77a)
end
function c77771005.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x77a)
end
function c77771005.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77771005.filter,tp,LOCATION_MZONE,0,1,nil)
		and rp==1-tp and Duel.IsChainNegatable(ev)
end
function c77771005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77771005.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re)
	  and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)>0 then
	  Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
function c77771005.setfilter(c,tp)
	return c:IsSetCard(0x77a) and c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE) and not c:IsReason(REASON_DRAW)
end
function c77771005.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77771005.setfilter,1,nil,tp) and aux.exccon(e)
end
function c77771005.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c77771005.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECK)
		c:RegisterEffect(e1)
	end
end

