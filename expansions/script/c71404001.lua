--星祈之凝忆
if not c71404000 then dofile("expansions/script/c71404000.lua") end
---@param c Card
function c71404001.initial_effect(c)
	c:EnableReviveLimit()
	--banish from extra deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71404001,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,71404001)
	e1:SetCost(c71404001.cost1)
	e1:SetTarget(c71404001.tg1)
	e1:SetOperation(c71404001.op1)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71404001,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_EQUIP+CATEGORY_REMOVE+CATEGORY_TODECK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,71504001)
	e2:SetCost(yume.stellar_memories.LimitCost)
	e2:SetTarget(c71404001.tg2)
	e2:SetOperation(c71404001.op2)
	c:RegisterEffect(e2)
	--equipped
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c71404001.con3)
	e3:SetTarget(c71404001.tg3)
	e3:SetValue(1)
	e3:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e3)
	yume.stellar_memories.GlobalCheck(c)
end
function c71404001.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,71404000,tp)==0
		and c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	yume.stellar_memories.RegCostLimit(e,tp)
end
function c71404001.filter1(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemove(tp)
end
function c71404001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71404001.filter1,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end
function c71404001.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c71404001.filter1,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c71404001.filter2(c)
	return c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and not c:IsForbidden()
end
function c71404001.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c71404001.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and yume.stellar_memories.BanishorSendSpellCheck(71404013,tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c71404001.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		if ft>2 then ft=2 end
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71404001.filter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil)
		for tc in aux.Next(g) do
			if Duel.Equip(tp,tc,c) then
				local e1=Effect.CreateEffect(c)
				e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(c71404001.eqlimit)
				tc:RegisterEffect(e1)
			end
		end
	end
	yume.stellar_memories.BanishorSendSpell(71404013,tp,aux.Stringid(71404001,2),aux.Stringid(71404001,3))
end
function c71404001.eqlimit(e,c)
	return e:GetOwner()==c
end
function c71404001.con3(e)
	local qc=e:GetHandler():GetEquipTarget()
	return qc and qc:IsType(TYPE_LINK)
end
function c71404001.tg3(e,c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end