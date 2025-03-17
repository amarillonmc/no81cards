--凝锋之星意
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
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_REMOVE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(yume.stellar_memories.LimitCost)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--equipped
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+TYPE_EQUIP)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.con2)
	e2:SetValue(DOUBLE_DAMAGE)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	--ritual summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,id+100000)
	e3:SetCost(yume.stellar_memories.LimitCost)
	e3:SetTarget(yume.stellar_memories.RitualUltimateTarget("Greater",LOCATION_HAND,LOCATION_ONFIELD+LOCATION_EXTRA,nil))
	e3:SetOperation(yume.stellar_memories.RitualUltimateOperation("Greater",LOCATION_HAND,LOCATION_ONFIELD+LOCATION_EXTRA,nil))
	c:RegisterEffect(e3)
	yume.stellar_memories.GlobalCheck(c)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
end
function s.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_RITUAL)
end
function s.con1(e)
	return Duel.GetFlagEffect(0,id)>0
end
function s.filter1(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and not c:IsForbidden()
end
function s.filter1a(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:GetOriginalType()&(TYPE_RITUAL+TYPE_MONSTER)~=0
end
function s.getcolumns(g)
	local cols={}
	for c in aux.Next(g) do
		local col=aux.GetColumn(c)
		if col then cols[col]=true end
	end
	return cols
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 or not Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then return false end
		local g1=Duel.GetMatchingGroup(s.filter1a,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil,tp)
		local cols1=s.getcolumns(g1)
		local cols2=s.getcolumns(g2)
		for i = 0,4 do
			if cols1[i] and cols2[i] then return true end
		end
		return false
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
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
			end
		end
	end
	local g1=Duel.GetMatchingGroup(s.filter1a,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local g2=Group.CreateGroup()
	local cols={}
	for c in aux.Next(g1) do
		local col=aux.GetColumn(c)
		if col and not cols[col] then
			cols[col]=true
			local new_g=c:GetColumnGroup()
			new_g:AddCard(c)
			new_g=new_g:Filter(Card.IsControler,nil,1-tp)
			g2:Merge(new_g)
		end
	end
	Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.con2(e)
	local qc=e:GetHandler():GetEquipTarget()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return qc and qc:IsType(TYPE_RITUAL) and (a:IsRace(RACE_SPELLCASTER)
		or d and d:IsRace(RACE_SPELLCASTER))
end