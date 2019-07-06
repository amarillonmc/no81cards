--虚拟YouTuber 藤崎由愛
local m=33700360
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1) 
	local f1=aux.FilterBoolFunction(Card.IsLevel,3)
	local f4=aux.FilterBoolFunction(Card.IsLevel,3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.SynMixCondition(f1,nil,nil,f4,1,1))
	e1:SetTarget(Auxiliary.SynMixTarget(f1,nil,nil,f4,1,1))
	e1:SetOperation(Auxiliary.SynMixOperation(f1,nil,nil,f4,1,1))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
end
