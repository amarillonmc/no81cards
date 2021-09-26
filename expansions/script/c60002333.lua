--如果我写了这个lua，那么我写了这个lua，如果他没bug，那么他没bug
function c60002333.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetTargetRange(POS_FACEUP_ATTACK,0)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c60002333.sprcon)
	c:RegisterEffect(e3)
end
function c60002333.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return  Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end