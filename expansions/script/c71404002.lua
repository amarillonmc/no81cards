--凝羽之星意
if not c71404000 then dofile("expansions/script/c71404000.lua") end
---@param c Card
function c71404002.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c71404002.lcheck)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71404002,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,71404002)
	e1:SetCost(yume.stellar_memories.LimitCost)
	e1:SetTarget(c71404002.tg1)
	e1:SetOperation(c71404002.op1)
	c:RegisterEffect(e1)
	--equipped
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+TYPE_EQUIP)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c71404002.con2)
	e2:SetTarget(c71404002.tg2)
	e2:SetValue(1)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	c:RegisterEffect(e2)
	--banish from deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71404002,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,71504002)
	e3:SetCondition(c71404002.con3)
	e3:SetCost(c71404002.cost3)
	e3:SetTarget(c71404002.tg3)
	e3:SetOperation(c71404002.op3)
	c:RegisterEffect(e3)
	yume.stellar_memories.GlobalCheck(c)
end
function c71404002.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_RITUAL)
end
function c71404002.filter1(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER) and c:IsFaceupEx() and not c:IsForbidden()
end
function c71404002.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c71404002.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and yume.stellar_memories.BanishorSendSpellCheck(71404013,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c71404002.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		if ft>2 then ft=2 end
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71404002.filter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil)
		for tc in aux.Next(g) do
			if Duel.Equip(tp,tc,c) then
				local e1=Effect.CreateEffect(c)
				e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(c71404002.eqlimit)
				tc:RegisterEffect(e1)
			end
		end
	end
	yume.stellar_memories.BanishorSendSpell(71404013,tp,aux.Stringid(71404001,2),aux.Stringid(71404001,3))
	--Optional Multi Ritual
	--yume.stellar_memories.OptionalMultiRitualSummon(e,tp,aux.Stringid(71404002,1),"Greater",LOCATION_SZONE,LOCATION_EXTRA)
end
function c71404002.eqlimit(e,c)
	return e:GetOwner()==c
end
function c71404002.con2(e)
	local qc=e:GetHandler():GetEquipTarget()
	return qc and qc:IsType(TYPE_RITUAL)
end
function c71404002.tg2(e,c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c71404002.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c71404002.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,71404000,tp)==0
		and c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_COST)
	yume.stellar_memories.RegCostLimit(e,tp)
end
function c71404002.filter3(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemove(tp)
end
function c71404002.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71404002.filter3,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c71404002.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c71404002.filter3,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end