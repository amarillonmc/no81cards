--究极骑士秘技 阿瓦隆之门
function c16349067.initial_effect(c)
	c:SetUniqueOnField(1,0,16349067)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3dc2))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Change race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(RACE_DRAGON)
	c:RegisterEffect(e2)
	--atk/def down
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_FIELD)
	e22:SetCode(EFFECT_UPDATE_ATTACK)
	e22:SetRange(LOCATION_SZONE)
	e22:SetTargetRange(0,LOCATION_MZONE)
	e22:SetTarget(c16349067.adtg)
	e22:SetValue(-500)
	c:RegisterEffect(e22)
end
function c16349067.adtg(e,c)
	return c:IsRace(RACE_DRAGON)
end