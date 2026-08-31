--幸运满贯 !Jack-Pot!
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(nil),4,4)
	c:EnableReviveLimit()
	--alternative summon: banish 5 different lucky slam synchro from field/grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.altcon)
	e1:SetTarget(s.alttg)
	e1:SetOperation(s.altop)
	c:RegisterEffect(e1)
	--change level to 5 when summoned by alternative method
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.lvcon)
	e2:SetOperation(s.lvop)
	c:RegisterEffect(e2)
	--①: opponent cannot summon monster with level <= this card's level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetTarget(s.sumlimit)
	c:RegisterEffect(e3)
	--②: cannot be targeted by opponent's effects
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--③: discard 1 card, special summon lucky slam from grave/banished
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e5:SetCountLimit(1,id)
	e5:SetCost(s.e5cost)
	e5:SetTarget(s.e5tg)
	e5:SetOperation(s.e5op)
	c:RegisterEffect(e5)
end
--alternative summon condition
function s.altfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x892) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
end
function s.altcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(s.altfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	--need 5 different names
	local codes={}
	local count=0
	for tc in aux.Next(mg) do
		local code=tc:GetCode()
		if not codes[code] then
			codes[code]=true
			count=count+1
		end
	end
	return count>=5 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
--alternative summon target
function s.alttg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(s.altfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local g=Group.CreateGroup()
	local codes={}
	for tc in aux.Next(mg) do
		local code=tc:GetCode()
		if not codes[code] then
			codes[code]=tc
		end
	end
	for _,tc in pairs(codes) do
		g:AddCard(tc)
	end
	if g:GetCount()<5 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,5,5,nil)
	if sg:GetCount()==5 then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	end
	return false
end
--alternative summon operation
function s.altop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
	g:DeleteGroup()
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
end
--level change condition
function s.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0 and e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
--level change operation
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(5)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
--①: summon limit
function s.sumlimit(e,c)
	return c:IsLevelBelow(e:GetHandler():GetLevel())
end
--③: cost
function s.e5cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
--③: target
function s.e5filter(c,e,tp)
	return c:IsSetCard(0x892) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function s.e5tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.e5filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
--③: operation
function s.e5op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.e5filter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end