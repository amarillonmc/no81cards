--凝域之星意
if not c71404000 then dofile("expansions/script/c71404000.lua") end
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,99,s.lcheck)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCost(yume.stellar_memories.LimitCost)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--equipped
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.con2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2a:SetRange(LOCATION_SZONE)
	e2a:SetCode(EVENT_CHAIN_END)
	e2a:SetCondition(s.con2a)
	e2a:SetOperation(s.op2a)
	c:RegisterEffect(e2a)
	--banish from deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,id+100000)
	e3:SetCost(s.cost3)
	e3:SetTarget(s.tg3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
	yume.stellar_memories.GlobalCheck(c)
end
function s.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_RITUAL)
end
function s.filter1(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and not c:IsForbidden()
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op_flag=false
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		if ft>2 then ft=2 end
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil)
		for tc in aux.Next(g) do
			if Duel.Equip(tp,tc,c) then
				local e1=Effect.CreateEffect(c)
				e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(s.eqlimit)
				tc:RegisterEffect(e1)
				op_flag=true
			end
		end
	end
	if op_flag then
		yume.stellar_memories.OptionalMultiRitualSummon(e,tp,aux.Stringid(id,1),"Greater",LOCATION_DECK,LOCATION_ONFIELD,2)
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.limfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local qc=e:GetHandler():GetEquipTarget()
	return qc and qc:IsType(TYPE_RITUAL) and eg:IsExists(s.limfilter,1,nil)
end
function s.con2a(e,tp,eg,ep,ev,re,r,rp)
	local qc=e:GetHandler():GetEquipTarget()
	return qc and qc:IsType(TYPE_RITUAL)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(s.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(s.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(id)
	e:Reset()
end
function s.op2a(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(id)~=0 then
		Duel.SetChainLimitTillChainEnd(s.chainlm)
	end
	c:ResetFlagEffect(id)
end
function s.chainlm(e,rp,tp)
	return tp==rp
end

function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,71404000,tp)==0
		and c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_COST)
	yume.stellar_memories.RegCostLimit(e,tp)
end
function s.filter3(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemove(tp)
end
function s.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end