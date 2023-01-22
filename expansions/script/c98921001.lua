--入魔邪灵
function c98921001.initial_effect(c)  
	c:SetSPSummonOnce(98921001)
		--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98921001+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c98921001.spcon)
	c:RegisterEffect(e1)  
  --get effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c98921001.xmatcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c98921001.filter(c)
	return c:IsSetCard(0xa) and c:IsFaceup()
end
function c98921001.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98921001.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c98921001.xmatcon(e)
	return e:GetHandler():GetOriginalAttribute()==ATTRIBUTE_DARK
end