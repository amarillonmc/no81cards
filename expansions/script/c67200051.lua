--创刻-仙崎秀哉『浴血之时』
function c67200051.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,67200050,aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),1,true,true)   
	--fusion success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200051,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(67200051,1)
	e1:SetTarget(c67200051.addct)
	e1:SetOperation(c67200051.addc)
	c:RegisterEffect(e1)
	--atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c67200051.atktg)
	e2:SetValue(c67200051.atkval)
	c:RegisterEffect(e2)
end
--
function c67200051.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x1673)
end
function c67200051.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1673,3)
	end
end
--
function c67200051.atktg(e,c)
	return not c:IsSetCard(0x673)
end
function c67200051.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x1673)*-300
end
