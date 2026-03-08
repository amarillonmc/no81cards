--简式同调
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_SYNCHRO)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_SYNCHRO)
end
function s.filter(c,e,ec)
	if not s.mattg(e,c) then return end
	local e1=Effect.CreateEffect(ec)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.SynMixCondition(aux.Tuner(nil),nil,nil,aux.NonTuner(nil),1,99,s.syncheck))
	e1:SetTarget(Auxiliary.SynMixTarget(aux.Tuner(nil),nil,nil,aux.NonTuner(nil),1,99,s.syncheck))
	e1:SetOperation(s.SynMixOperation)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	local res=c:IsSynchroSummonable(nil)
	e1:Reset()
	return res
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_EXTRA,0,nil,e,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		s.summon(e,tp,tc)
	end
end
function s.summon(e,tp,tc)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.SynMixCondition(aux.Tuner(nil),nil,nil,aux.NonTuner(nil),1,99,s.syncheck))
	e1:SetTarget(Auxiliary.SynMixTarget(aux.Tuner(nil),nil,nil,aux.NonTuner(nil),1,99,s.syncheck))
	e1:SetOperation(s.SynMixOperation)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	Duel.SynchroSummon(tp,tc,nil)
end
function s.syncheck(g)
	return g:IsExists(aux.TRUE,1,nil)
end
function s.SynMixOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
	checkflag=true
	local g=e:GetLabelObject()
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
	checkflag=false
end
function s.matcon(e,tp,eg,ep,ev,re,r,rp)
	return checkflag
end
function s.mattg(e,c)
	if not c:IsType(TYPE_SYNCHRO) or c:IsSpecialSummonable(TYPE_SYNCHRO) then return false end
	--[[local tab={14000248,14010109,33730071,79029117,90700065,90700066,90700067,90700068,90700069,92361302,92361306,98731001}
	for _,code in pairs(tab) do
		if c:GetOriginalCode()==code then return false end
	end]]
	local eset={c:IsHasEffect(EFFECT_SPSUMMON_CONDITION)}
	for _,te in pairs(eset) do
		if te:GetOwner()==c and (te:GetValue()==0 or te:GetValue()==aux.FALSE) then return false end
	end
	return true
end