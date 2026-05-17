--星忆导刃
local s,id,o=GetID()
function s.initial_effect(c)
	if not (yume and yume.stellar_memories) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71404000,0)
		yume.import_flag=false
	end
	--banish from deck or return to extra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(yume.stellar_memories.LimitCost)
	e1:SetTarget(yume.stellar_memories.HighSpellActivationTg(71404009,71404010))
	e1:SetOperation(yume.stellar_memories.HighSpellActivationOp(71404009,71404010,aux.Stringid(id,1),aux.Stringid(id,2)))
	c:RegisterEffect(e1)
	--banished by 星导之凝忆: draw, then link summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+100000)
	e2:SetCondition(yume.stellar_memories.BanishedSpellCon(71404009))
	e2:SetCost(yume.stellar_memories.LimitCost)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	--banished by 凝刃之星意: ritual summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,4))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+110000)
	e3:SetCondition(yume.stellar_memories.BanishedSpellCon(71404010))
	e3:SetCost(yume.stellar_memories.LimitCost)
	e3:SetTarget(yume.stellar_memories.RitualUltimateTarget("Greater",LOCATION_HAND,LOCATION_ONFIELD+LOCATION_DECK,nil))
	e3:SetOperation(yume.stellar_memories.RitualUltimateOperation("Greater",LOCATION_HAND,LOCATION_ONFIELD+LOCATION_DECK,nil))
	c:RegisterEffect(e3)
	yume.stellar_memories.GlobalCheck(c)
end
function s.linkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsRace(RACE_SPELLCASTER) and c:IsLinkState()
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(s.linkfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then
		return ct>0 and Duel.IsPlayerCanDraw(tp,ct)
			and Duel.IsExistingMatchingCard(yume.stellar_memories.LinkSummonFilter,tp,LOCATION_EXTRA,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(s.linkfilter,tp,LOCATION_MZONE,0,nil)
	if ct>0 and Duel.Draw(tp,ct,REASON_EFFECT)==ct then
		Duel.BreakEffect()
		yume.stellar_memories.LinkSummonOp(e,tp,eg,ep,ev,re,r,rp)
	end
end
