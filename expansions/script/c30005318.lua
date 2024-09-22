--魔傀行军
local m=30005318
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1
	local e51=Effect.CreateEffect(c)
	e51:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_SZONE)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCountLimit(1)
	e51:SetTarget(cm.tg)
	e51:SetOperation(cm.op)
	c:RegisterEffect(e51) 
	--Effect 2  
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCountLimit(1,m)
	e5:SetCost(aux.bfgcost)
	e5:SetTarget(cm.rdtg)
	e5:SetOperation(cm.rdop)
	c:RegisterEffect(e5) 
end
--Effect 1
function cm.suf(c,ec)
	if not c:IsRace(RACE_FIEND) or not c:IsLevel(6) then return false end
	local e1=Effect.CreateEffect(ec)
	e1:SetDescription(aux.Stringid(30005304,3))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.ntcon)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local res=c:IsSummonable(true,nil)
	e1:Reset()
	return res
end
function cm.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.spf(c,e,tp)
	if not c:IsType(TYPE_TRAP) or not c:IsType(TYPE_CONTINUOUS) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local b1=Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,TYPES_NORMAL_TRAP_MONSTER,500,0,6,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,tp) 
	return ft>0 and b1 
end
function cm.nf(c)
	return c:IsFaceup() and c:IsCode(30005317)
end
function cm.xpf(c,e,tp)
	return c:IsFaceupEx() and cm.spf(c,e,tp)
end
function cm.zef(c,e,tp) 
	return not c:IsForbidden() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsFaceupEx() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:CheckUniqueOnField(tp) 
end 
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED 
	local hg=Duel.GetMatchingGroup(cm.suf,tp,LOCATION_HAND,0,nil,e:GetHandler())
	local pg=Duel.GetMatchingGroup(cm.spf,tp,LOCATION_HAND+LOCATION_SZONE,0,nil,e,tp)
	local ng=Duel.GetMatchingGroup(cm.nf,tp,LOCATION_ONFIELD,0,nil,e,tp)
	local xg=Duel.GetMatchingGroup(cm.zef,tp,loc,0,nil,e,tp)
	if chk==0 then return #hg>0 or #pg>0 or (#ng>0 and #xg>0) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED 
	local hg=Duel.GetMatchingGroup(cm.suf,tp,LOCATION_HAND,0,nil,e:GetHandler())
	local pg=Duel.GetMatchingGroup(cm.spf,tp,LOCATION_HAND+LOCATION_SZONE,0,nil,e,tp)
	local ng=Duel.GetMatchingGroup(cm.nf,tp,LOCATION_ONFIELD,0,nil,e,tp)
	local xg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.zef),tp,loc,0,nil,e,tp)
	if #hg==0 and #pg==0 and (#xg==0 and #ng==0) then return end
	local ek=#ng>0 and #xg>0
	local op=aux.SelectFromOptions(tp,{#hg>0,aux.Stringid(m,0)},{#pg>0,aux.Stringid(m,1)},{ek,aux.Stringid(m,2)})
	if op==1 then
		cm.pop(e,tp,eg,ep,ev,re,r,rp)
	elseif op==2 then
		local tc=pg:FilterSelect(tp,cm.spf,1,1,nil,e,tp):GetFirst()
		if tc:IsOnField() and tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end
		cm.spp(e,tp,tc,tp)
		Duel.SpecialSummonComplete()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local zc=xg:Select(tp,1,1,nil):GetFirst()
		if not zc or zc==nil then return false end
		Duel.MoveToField(zc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	local kg=Duel.GetMatchingGroup(cm.suf,tp,LOCATION_HAND,0,nil,ec)
	if #kg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.suf,tp,LOCATION_HAND,0,1,1,nil,ec):GetFirst()
		if not tc or tc==nil then return false end
		local e1=Effect.CreateEffect(ec)
		e1:SetDescription(aux.Stringid(30005304,3))
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SUMMON_PROC)
		e1:SetCondition(cm.ntcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(ec)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SUMMON_NEGATED)
		e2:SetOperation(cm.rstop)
		e2:SetLabelObject(e1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		Duel.Summon(tp,tc,true,nil)
	end
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	if e1 then e1:Reset() end
	e:Reset()
end
function cm.spp(e,tp,tc,sp)
	tc:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP,ATTRIBUTE_DARK,RACE_FIEND,6,500,0)
	Duel.SpecialSummonStep(tc,0,tp,sp,true,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(0)
	tc:RegisterEffect(e2,true)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(6)
	tc:RegisterEffect(e3,true)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e4:SetValue(ATTRIBUTE_DARK)
	tc:RegisterEffect(e4,true)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_RACE)
	e5:SetValue(RACE_FIEND)
	tc:RegisterEffect(e5,true)
end
--Effect 2
function cm.ddf(c)
	local b1=c:IsRace(RACE_FIEND)
	local b2=c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS 
	return b1 or b2
end
function cm.of(c)
	return c:IsOnField() and c:IsFacedown()
end
function cm.rdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.ddf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if chk==0 then return #g>=2 and Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function cm.rdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.ddf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if #g<2 then return end
	local dg=g:Select(tp,2,#g,nil)
	local kg=dg:Filter(cm.of,nil)
	if #kg>0 then Duel.ConfirmCards(1-tp,kg) end
	local ct=Duel.Destroy(dg,REASON_EFFECT)
	if ct==0 then return false end
	Duel.BreakEffect()
	Duel.Draw(tp,ct+1,REASON_EFFECT)
end 