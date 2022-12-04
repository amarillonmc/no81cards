--人理之基 坂田金时
function c22022310.initial_effect(c)
	c:SetSPSummonOnce(22022310)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,22022310)
	e1:SetCondition(c22022310.spcon)
	c:RegisterEffect(e1)
	--xyzlv
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c22022310.xyzlv)
	c:RegisterEffect(e2)
end
function c22022310.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xff1) and (c:IsLevel(5) or c:IsRank(5))
end
function c22022310.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c22022310.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c22022310.xyzlv(e,c,rc)
	return 0x50000+e:GetHandler():GetLevel()
end