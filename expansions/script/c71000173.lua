--默然然
function c71000173.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71000173,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(3,71000173)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCondition(c71000173.spcon)
	c:RegisterEffect(e1)
end
function c71000173.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe73) and c:IsType(TYPE_MONSTER)
end
function c71000173.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71000173.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
