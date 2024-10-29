--尤加特拉希的永恒天堂
function c98930403.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c98930403.indescon)
	e1:SetTarget(c98930403.indestg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c98930403.indescon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--change range
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(98930403)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
	--can not attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98930403,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c98930403.catkcon)
	e3:SetTarget(c98930403.catktg)
	e3:SetOperation(c98930403.catkop)
	c:RegisterEffect(e3)
end
function c98930403.filter(c)
	return c:GetOriginalType()&TYPE_MONSTER>0
		and c:IsFaceup()
end
function c98930403.indescon(e)
	return Duel.IsExistingMatchingCard(c98930403.filter,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
function c98930403.indestg(e,c)
	return c:IsCode(98930401)
end
function c98930403.catkfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsCode(98930401) and c:IsReason(REASON_EFFECT)
end
function c98930403.catkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98930403.catkfilter,1,nil,tp)
end
function c98930403.catktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98930403.catkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
