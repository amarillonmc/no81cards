local m=53764013
local cm=_G["c"..m]
cm.name="土之终极"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=Duel.CheckTribute
		Duel.CheckTribute=function(sc,min,...)
			if Duel.GetFlagEffect(0,m)>0 then min=min-1 end
			return cm[0](sc,min,...)
		end
	end
end
cm.has_text_type=TYPE_SPIRIT
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.spfilter(c,e,tp,res)
	if not (c:IsType(TYPE_SPIRIT) and c:IsLevelBelow(9) and (not c:IsLocation(LOCATION_DECK) or (res and c:IsLevelAbove(5))) and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_HAND,0,1,c,c)) then return false end
	local le={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON)}
	local lex={Duel.IsPlayerAffectedByEffect(tp,EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)}
	for _,v in pairs(lex) do table.insert(le,v) end
	local ret1,ret2={},{}
	for _,v in pairs(le) do
		local tg=v:GetTarget()
		if not tg then tg=aux.TRUE end
		table.insert(ret1,v)
		table.insert(ret2,tg)
		v:SetTarget(cm.chtg(tg,e))
	end
	local res2=c:IsCanBeSpecialSummoned(e,0,tp,true,false)
	for i=1,#ret1 do ret1[i]:SetTarget(ret2[i]) end
	return res2
end
function cm.chtg(_tg,re)
	return function(e,c,sump,sumtype,sumpos,targetp,se)
			   if se==re then return false end
			   return _tg(e,c,sump,sumtype,sumpos,targetp,se)
		   end
end
function cm.filter1(c,tc)
	if not c:IsType(TYPE_SPIRIT) then return false end
	if c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1) then return true end
	if c:IsSummonable(true,nil) or c:IsMSetable(true,nil) then return false end
	local le1={Duel.IsPlayerAffectedByEffect(c:GetControler(),EFFECT_CANNOT_RELEASE)}
	for _,v in pairs(le1) do
		local val1=v:GetTarget()
		if not val1 or val1(v,tc,c:GetControler(),c:GetControler()) then return false end
	end
	local le2={c:IsHasEffect(EFFECT_TRIBUTE_LIMIT)}
	for _,v in pairs(le2) do
		local val2=v:GetValue()
		if not val2 or val2(v,tc) then return false end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DECREASE_TRIBUTE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(0x1)
	c:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DECREASE_TRIBUTE_SET)
	c:RegisterEffect(e2,true)
	Duel.RegisterFlagEffect(0,m,0,0,0)
	local res=c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
	e1:Reset()
	e2:Reset()
	Duel.ResetFlagEffect(0,m)
	return res
end
function cm.filter2(c)
	return c:IsType(TYPE_SPIRIT) and (c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=(Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp,res) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local res=(Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp,res):GetFirst()
	if not sc then return end
	local le={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON)}
	local lex={Duel.IsPlayerAffectedByEffect(tp,EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)}
	for _,v in pairs(lex) do table.insert(le,v) end
	local ret1,ret2={},{}
	for _,v in pairs(le) do
		local tg=v:GetTarget()
		if not tg then tg=aux.TRUE end
		table.insert(ret1,v)
		table.insert(ret2,tg)
		v:SetTarget(cm.chtg(tg,e))
	end
	local sp=Duel.SpecialSummonStep(sc,0,tp,tp,true,false,POS_FACEUP)
	for i=1,#ret1 do ret1[i]:SetTarget(ret2[i]) end
	if not sp then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(e2)
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
	end
end
