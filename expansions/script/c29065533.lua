--源石生命·Mon3tr
function c29065533.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,29065501)
	c:SetUniqueOnField(1,0,29065633)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,29065533+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c29065533.spcon)
	e1:SetOperation(c29065533.spop)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c29065533.sdcon)
	c:RegisterEffect(e2)
end
function c29065533.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,29065501) and Duel.IsCanRemoveCounter(c:GetControler(),1,1,0x10ae,1,REASON_COST)
end
function c29065533.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,1,0x10ae,1,REASON_RULE)
end
function c29065533.sdfilter(c)
	return c:IsFaceup() and c:IsCode(29065501)
end
function c29065533.sdcon(e)
	return not Duel.IsExistingMatchingCard(c29065533.sdfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end