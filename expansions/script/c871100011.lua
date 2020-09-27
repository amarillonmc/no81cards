--青铜幼龙
function c871100011.initial_effect(c)
	c:SetSPSummonOnce(871100011)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c871100011.spcon)
	c:RegisterEffect(e1)
------
function c871100011.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfec1)
end
function c871100011.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c871100011.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
------
