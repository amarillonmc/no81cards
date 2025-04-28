--星忆祈羽
if not c71404000 then dofile("expansions/script/c71404000.lua") end
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCountLimit(1,id)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(yume.stellar_memories.LowSpellActivationTg(71404001,71404002))
	e1:SetCost(yume.stellar_memories.LimitCost)
	e1:SetOperation(yume.stellar_memories.LowSpellActivationOp(
		71404001,71404002,aux.Stringid(id,1),aux.Stringid(id,2)
	))
	c:RegisterEffect(e1)
	--extra link material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCountLimit(1,id+100000)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(yume.stellar_memories.BanishedSpellCon(71404001))
	e2:SetCost(yume.stellar_memories.LimitCost)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	--ritual summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,4))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,id+110000)
	e3:SetCondition(yume.stellar_memories.BanishedSpellCon(71404002))
	e3:SetCost(yume.stellar_memories.LimitCost)
	e3:SetTarget(yume.stellar_memories.MultiRitualTarget("Greater",LOCATION_SZONE,LOCATION_EXTRA,nil))
	e3:SetOperation(yume.stellar_memories.MultiRitualOperation("Greater",LOCATION_SZONE,LOCATION_EXTRA,nil))
	c:RegisterEffect(e3)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(s.mattg)
	e1:SetValue(s.matval)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function s.mattg(e,c)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER~=0
end
function s.matval(e,lc,mg,c,tp)
	if not (lc:IsRace(RACE_SPELLCASTER) and e:GetHandlerPlayer()==tp) then return false,nil end
	return true,true
end