--悲剧处刑舞台装置
function c95101249.initial_effect(c)
	c:SetSPSummonOnce(95101249)
	--fusion material
	aux.AddFusionProcFunFun(c,c95101249.mfilter,aux.FilterBoolFunction(Card.IsFusionType,TYPE_FUSION),1,true)
	aux.AddContactFusionProcedure(c,Card.IsFaceup,LOCATION_REMOVED,0,Duel.SendtoGrave,REASON_RETURN+REASON_MATERIAL)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c95101249.splimit)
	c:RegisterEffect(e0)
	--fusion substitute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e1:SetCondition(c95101249.subcon)
	c:RegisterEffect(e1)
end
function c95101249.mfilter(c)
	return c:IsRace(RACE_ILLUSION) and c:IsFusionAttribute(ATTRIBUTE_DARK)
end
function c95101249.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c95101249.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
end
