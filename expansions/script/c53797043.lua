local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),2,2,nil,nil,99)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(id)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCondition(s.atcon)
	e2:SetCost(s.atcost)
	e2:SetTarget(s.attg)
	e2:SetOperation(s.atop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetProperty(EFFECT_FLAG_DELAY)
		ge1:SetCondition(s.con1)
		ge1:SetOperation(s.op1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetCondition(s.regcon)
		ge2:SetOperation(s.regop)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAIN_SOLVED)
		ge3:SetCondition(s.con2)
		ge3:SetOperation(s.op2)
		Duel.RegisterEffect(ge3,0)
		local f=Card.GetReasonCard
		Card.GetReasonCard=function(c)
			local eset={c:IsHasEffect(EFFECT_FLAG_EFFECT+id)}
			if #eset>0 then return (eset[1]):GetLabelObject() else return f(c) end
		end
	end
end
function s.cfilter(c)
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsRace(RACE_DRAGON) and c:IsFaceup()
end
function s.xyzfilter(c)
	return c:IsHasEffect(id) and c:IsXyzSummonable(nil)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsChainSolving()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.cfilter,nil)
	local t={}
	for tc in aux.Next(g) do table.insert(t,tc:GetSummonPlayer()) end
	s.removeDuplicates(t)
	for _,v in ipairs(t) do
		local sc=Duel.GetFirstMatchingCard(s.xyzfilter,v,LOCATION_EXTRA,0,nil)
		if sc and Duel.SelectYesNo(v,aux.Stringid(id,0)) then Duel.SpecialSummonRule(v,sc,SUMMON_TYPE_XYZ) end
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainSolving()
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.cfilter,nil)
	for tc in aux.Next(g) do Duel.RegisterFlagEffect(0,id,RESET_CHAIN,0,1,tc:GetSummonPlayer()) end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,id)>0
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local t={Duel.GetFlagEffect(0,id)}
	s.removeDuplicates(t)
	for _,v in ipairs(t) do
		local sc=Duel.GetFirstMatchingCard(s.xyzfilter,v,LOCATION_EXTRA,0,nil)
		if sc and Duel.SelectYesNo(v,aux.Stringid(id,0)) then Duel.SpecialSummonRule(v,sc,SUMMON_TYPE_XYZ) end
	end
	Duel.ResetFlagEffect(0,id)
end
function s.removeDuplicates(t)
	local seen = {}
	local result = {}
	for _, value in ipairs(t) do
		if not seen[value] then
			table.insert(result, value)
			seen[value] = true
		end
	end
	return result
end
function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2)
end
function s.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.filter1(c,ac)
	local le={c:IsHasEffect(EFFECT_IGNORE_BATTLE_TARGET)}
	for _,v in pairs(le) do
		local val=v:GetValue() or aux.FALSE
		if (aux.GetValueType(val)=="number" and val==1) or val(v,ac) then return true end
	end
	return false
end
function s.atfilter(c,tp,tid)
	local ct1=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local ct2=Duel.GetMatchingGroupCount(s.filter1,tp,0,LOCATION_MZONE,nil,c)
	local da=not c:IsHasEffect(EFFECT_CANNOT_DIRECT_ATTACK) and ((ct1==ct2) or c:IsHasEffect(EFFECT_DIRECT_ATTACK))
	local g=Duel.GetMatchingGroup(Card.IsCanBeBattleTarget,tp,0,LOCATION_MZONE,nil,c)
	return c:IsLevelBelow(2) and c:IsRace(RACE_DRAGON) and c:IsSummonLocation(LOCATION_DECK) and c:GetTurnID()==tid and c:IsAttackable() and (da or #g>0)
end
function s.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.atfilter(chkc,tp,tid) end
	if chk==0 then return Duel.IsExistingTarget(s.atfilter,tp,LOCATION_MZONE,0,1,nil,tp,tid) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.atfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,tid)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsAttackable() then return end
	local ct1=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local ct2=Duel.GetMatchingGroupCount(s.filter1,tp,0,LOCATION_MZONE,nil,tc)
	local da=not tc:IsHasEffect(EFFECT_CANNOT_DIRECT_ATTACK) and ((ct1==ct2) or tc:IsHasEffect(EFFECT_DIRECT_ATTACK))
	local g=Duel.GetMatchingGroup(Card.IsCanBeBattleTarget,tp,0,LOCATION_MZONE,nil,tc)
	if not da and #g==0 then return end
	local op2=aux.SelectFromOptions(tp,{da,1117},{#g>0,aux.Stringid(id-8,5)})
	if op2==1 then Duel.CalculateDamage(tc,nil,true) elseif op2==2 then
		local bc=g:Select(tp,1,1,nil):GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLED)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetOperation(s.desop)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e2,tp)
		Duel.CalculateDamage(tc,bc,true)
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.GetAttackTarget() then return end
	local g=Group.FromCards(Duel.GetAttacker(),Duel.GetAttackTarget())
	local dg=g:Filter(aux.NOT(Card.IsStatus),nil,STATUS_BATTLE_DESTROYED)
	if #g==#dg or #dg==0 then return end
	local dc1,dc2=dg:GetFirst(),Group.__sub(g,dg):GetFirst()
	local res=false
	local le={dc1:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE)}
	for _,v in pairs(le) do
		local val=v:GetValue() or aux.FALSE
		if (aux.GetValueType(val)=="number" and val==1) or val(v,dc2) then res=true end
	end
	if res then return end
	if Duel.Destroy(dc1,REASON_BATTLE)==0 then return end
	Duel.RaiseEvent(dc2,EVENT_BATTLE_DESTROYING,e,REASON_BATTLE,dc2:GetControler(),dc2:GetControler(),0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FLAG_EFFECT+id)
	e1:SetLabelObject(dc2)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	dc1:RegisterEffect(e1,true)
end
