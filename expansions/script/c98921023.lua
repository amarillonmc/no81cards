--星空之下
function c98921023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	 --LP recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98921023,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c98921023.condition)
	e2:SetTarget(c98921023.target)
	e2:SetOperation(c98921023.activate)
	c:RegisterEffect(e2)
end
function c98921023.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c98921023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,100)
	Duel.SetChainLimit(aux.FALSE)
end
function c98921023.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,100,REASON_EFFECT)
	Duel.Recover(1-tp,100,REASON_EFFECT)
end