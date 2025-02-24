--Protoss·护盾充能器
function c65870090.initial_effect(c)
	aux.AddCodeList(c,65870015)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetCondition(c65870090.excondition)
	e3:SetDescription(aux.Stringid(65870090,0))
	c:RegisterEffect(e3)
	--set
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_NEGATE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetCountLimit(1,65870090+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c65870090.discon)
	e0:SetTarget(c65870090.destg1)
	e0:SetOperation(c65870090.desop1)
	c:RegisterEffect(e0)
end

function c65870090.cfilter(c)
	return c:IsCode(65870015) and c:IsFaceup()
end
function c65870090.excondition(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c65870090.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end

function c65870090.discon(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsHasCategory(CATEGORY_DESTROY) or re:IsHasCategory(CATEGORY_TOGRAVE) or re:IsHasCategory(CATEGORY_REMOVE)) and Duel.IsChainDisablable(ev) and rp==1-tp
end
function c65870090.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c65870090.desop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() and Duel.IsExistingMatchingCard(c65870090.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(65870090,1)) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
