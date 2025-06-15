--魔法气泡连锁！
local s,id,o=GetID()
if not c71403001 then dofile("expansions/script/c71403001.lua") end
---@param c Card
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.con1)
	e1:SetCost(yume.PPTLimitCost)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	e1:SetValue(yume.PPTActivateZonesLimitForPlacingPend)
	c:RegisterEffect(e1)
	yume.RegPPTSTGraveEffect(c,id)
	Duel.AddCustomActivityCounter(71503001,ACTIVITY_SPSUMMON,s.counterfilter)
	yume.PPTCounter()
end
function s.counterfilter(c)
	return not c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(71503001,tp,ACTIVITY_SPSUMMON)==0
end
function s.filter1lnk(c)
	return c:IsType(TYPE_LINK) and c:IsAttack(1300) and not (c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() or c:IsForbidden())
end
function s.filter1sp(c,e,tp)
	return c:IsSetCard(0x715) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function s.getcodes(g)
	return codes
end
function s.is_any_code_different(g1,g2)
	local codes={}
	for tc in aux.Next(g1) do
		codes[tc:GetCode()]=true
	end
	for tc in aux.Next(g2) do
		if not codes[tc:GetCode()] then
			return true
		end
	end
	return false
end
function s.filter1p(c,g)
	return g:IsExists(s.diff_code_loc_filter,1,nil,c:GetCode(),c:GetLocation())
end
function s.diff_code_loc_filter(c,id,loc)
	return not (c:IsCode(id) or c:IsLocation(loc))
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(s.filter1sp,tp,LOCATION_HAND,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(yume.PPTPlacePendExceptFromFieldFilter,tp,LOCATION_HAND,0,nil)
	local g3=Duel.GetMatchingGroup(s.filter1sp,tp,LOCATION_DECK,0,nil,e,tp)
	local g4=Duel.GetMatchingGroup(yume.PPTPlacePendExceptFromFieldFilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then
		local fct=0
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then fct=1 end
		return (#g1>0 and #g4>0 and s.is_any_code_different(g1,g4)
		or #g2>0 and #g3>0 and s.is_any_code_different(g2,g3))
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>1+fct and Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(s.filter1lnk,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	g1:Merge(g3)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local zone=0x1f00
	local pflag1=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local pflag2=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if pflag1~=pflag2 then 
		zone=0xe00
	end
	if Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD,zone)==0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local lnk=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1lnk),tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if not lnk then return end
	if Duel.MoveToField(lnk,tp,lnk:GetOwner(),LOCATION_SZONE,POS_FACEUP,true,zone) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		lnk:RegisterEffect(e1)
	else
		return
	end
	if not (pflag1 or pflag2) then return end
	local g1=Duel.GetMatchingGroup(s.filter1sp,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(yume.PPTPlacePendExceptFromFieldFilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg1=g1:Select(tp,s.filter1p,1,1,nil,g2)
	if sg1:GetCount()>0 then
		Duel.BreakEffect()
		local sc1=sg1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg2=g2:FilterSelect(tp,s.diff_code_loc_filter,1,1,nil,sc1:GetCode(),sc1:GetLocation())
		if Duel.MoveToField(sc1,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
			local ct=Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			sc1:SetStatus(STATUS_EFFECT_ENABLED,true)
			local fg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
			if ct>0 and fg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg3=fg:Select(tp,1,1,nil)
				Duel.Destroy(sg3,REASON_EFFECT)
			end
		end
	end
end