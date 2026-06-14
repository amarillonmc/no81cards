--凝寂之星意
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	if not (yume and yume.stellar_memories) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71404000,0)
		yume.import_flag=false
	end
	--link summon
	aux.AddLinkProcedure(c,nil,3,99,s.lcheck)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_DISABLE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--equipped
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.con2)
	e2:SetValue(s.disval)
	c:RegisterEffect(e2)
	--ritual activation
	local e3a=Effect.CreateEffect(c)
	e3a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3a:SetCode(EVENT_REMOVE)
	e3a:SetOperation(s.regop)
	c:RegisterEffect(e3a)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetCountLimit(1,id+100000)
	e3:SetCondition(s.con3)
	e3:SetTarget(s.tg3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_DECK)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_RITUAL)
end
function s.filter1(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER) and c:IsFaceupEx() and not c:IsForbidden()
end
function s.filter1a(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:GetOriginalType()&(TYPE_RITUAL+TYPE_MONSTER)==TYPE_RITUAL+TYPE_MONSTER
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
		local g1=Duel.GetMatchingGroup(s.filter1a,tp,0,LOCATION_ONFIELD,nil)
		local g2=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
		local cols1=s.getcolumns(g1)
		local cols2=s.getcolumns(g2)
		for i = 0,4 do
			if cols1[i] and cols2[i] then return true end
		end
		return false
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,tp,LOCATION_ONFIELD)
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
	Duel.BreakEffect()
	local g1=Duel.GetMatchingGroup(s.filter1a,tp,0,LOCATION_ONFIELD,nil)
	local g2=Group.CreateGroup()
	local cols={}
	for tc in aux.Next(g1) do
		local col=aux.GetColumn(tc)
		if col and not cols[col] then
			cols[col]=true
			local new_g=tc:GetColumnGroup()
			new_g:AddCard(tc)
			new_g=new_g:Filter(Card.IsControler,nil,1-tp)
			g2:Merge(new_g)
		end
	end
	local tg=g2:Filter(aux.disfilter1,nil)
	Duel.NegateRelatedChain(tg,RESET_TURN_SET)
	for tc in aux.Next(tg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.con2(e)
	local qc=e:GetHandler():GetEquipTarget()
	return qc and qc:IsType(TYPE_RITUAL) and qc:IsRace(RACE_SPELLCASTER) and qc:IsLinkState()
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_EXTRA) then
		Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.disval(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	if ph==PHASE_BATTLE_START then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e2:SetRange(LOCATION_REMOVED)
		e2:SetOperation(s.regop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e2)
		return
	end
	local ct=1
	if ph>PHASE_BATTLE_START and ph<=PHASE_BATTLE then ct=2 end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,ct)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return yume.stellar_memories.TempBanishSpellCheck(71404018,tp)	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	yume.stellar_memories.TempBanishSpell(e:GetHandler(),71404018,tp)
end
