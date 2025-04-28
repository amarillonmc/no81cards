--星涉之凝忆
if not c71404000 then dofile("expansions/script/c71404000.lua") end
---@param c Card
function c71404003.initial_effect(c)
	c:EnableReviveLimit()
	--banish from extra deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71404003,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_MOVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,71404003)
	e1:SetCondition(c71404003.con1)
	e1:SetCost(c71404003.cost1)
	e1:SetTarget(c71404003.tg1)
	e1:SetOperation(c71404003.op1)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71404003,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCategory(CATEGORY_EQUIP+CATEGORY_TODECK+CATEGORY_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,71504003)
	e2:SetCost(yume.stellar_memories.LimitCost)
	e2:SetTarget(c71404003.tg2)
	e2:SetOperation(c71404003.op2)
	c:RegisterEffect(e2)
	--equipped
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c71404003.con3)
	e3:SetTarget(c71404003.tg3)
	e3:SetValue(aux.tgoval)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	c:RegisterEffect(e3)
	yume.stellar_memories.GlobalCheck(c)
end
function c71404003.filter1con(c)
	return c:IsLocation(LOCATION_ONFIELD) and not c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c71404003.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71404003.filter1con,1,nil)
end
function c71404003.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,71404000,tp)==0
		and c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	yume.stellar_memories.RegCostLimit(e,tp)
end
function c71404003.filter1(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemove(tp)
end
function c71404003.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71404003.filter1,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end
function c71404003.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c71404003.filter1,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c71404003.filter2(c)
	return c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and not c:IsForbidden()
end
function c71404003.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c71404003.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and yume.stellar_memories.BanishorSendSpellCheck(71404014,tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c71404003.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		if ft>2 then ft=2 end
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71404003.filter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil)
		for tc in aux.Next(g) do
			if Duel.Equip(tp,tc,c) then
				local e1=Effect.CreateEffect(c)
				e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(c71404003.eqlimit)
				tc:RegisterEffect(e1)
			end
		end
	end
	yume.stellar_memories.BanishorSendSpell(71404014,tp,aux.Stringid(71404003,2),aux.Stringid(71404003,3))
end
function c71404003.eqlimit(e,c)
	return e:GetOwner()==c
end
function c71404003.con3(e)
	local qc=e:GetHandler():GetEquipTarget()
	return qc and qc:IsType(TYPE_LINK)
end
function c71404003.tg3(e,c)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsRace(RACE_SPELLCASTER)
end