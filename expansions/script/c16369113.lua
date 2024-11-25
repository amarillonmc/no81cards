--暴龙剑
function c16369113.initial_effect(c)
	c:SetUniqueOnField(1,0,16369113)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c16369113.tgcon)
	e1:SetTarget(c16369113.tgtg)
	e1:SetValue(c16369113.tgval)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,16369113)
	e2:SetTarget(c16369113.target)
	e2:SetOperation(c16369113.activate)
	c:RegisterEffect(e2)
end
function c16369113.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3cb1)
end
function c16369113.tgcon(e)
	Duel.IsExistingMatchingCard(c16369113.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c16369113.tgtg(e,c)
	return c==e:GetHandler() or (c:IsFaceup() and c:IsSetCard(0x3cb1))
end
function c16369113.tgval(e,re,rp)
	return aux.tgoval(e,re,rp) and re:IsActiveType(TYPE_MONSTER)
end
function c16369113.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):FilterCount(c16369113.cfilter,nil)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) and ct>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c16369113.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetsRelateToChain()
	if #tg>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end