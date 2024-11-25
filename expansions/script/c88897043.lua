--青眼混沌黑魔术师
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,89631139,23995346)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xdd or 0xcf),s.matfilter,true)
 --
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetValue(46986414)
	c:RegisterEffect(e0)
	 --
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(TYPE_RITUAL)
	c:RegisterEffect(e1)
end
function s.matfilter(c)
	return c:IsRace(RACE_SPELLCASTER)
end