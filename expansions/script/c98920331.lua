--魔女术·召唤小组
function c98920331.initial_effect(c)
	c:SetSPSummonOnce(98920331)
--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_SPELLCASTER),2,2,c98920331.lcheck)
--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(83289866)
	e2:SetRange(LOCATION_DECK)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_DECK,0)
	e3:SetTarget(c98920331.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c98920331.lcheck(g)
	return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end
function c98920331.eftg(e,c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x128)
end