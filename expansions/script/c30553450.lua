--烽火骑士 旗兵
local s,id,o=GetID()
function c30553450.initial_effect(c)
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(s.sfilter),nil,nil,aux.Tuner(s.sfilter2),1,99)
	c:EnableReviveLimit()
end
function s.sfilter(c)
	return c:IsRace(RACE_WARRIOR) and not c:IsFusionType(TYPE_EFFECT)
end
function s.sfilter2(c)
	return not c:IsFusionType(TYPE_EFFECT)
end