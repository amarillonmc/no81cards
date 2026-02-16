--Card Name: (未提供，暂定)
--Scripted by Gemini
local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro Summon procedure
	c:EnableReviveLimit()
	--Mat: Tuner OR Link Monster (treated as Tuner) + 1+ Non-Tuner
	aux.AddSynchroMixProcedure(c,s.matfilter1,nil,nil,s.matfilter2,1,99)
	
	--Treat Link Monster as Tuner with Level = Link Rating
	for i=1,8 do
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(EFFECT_SYNCHRO_LEVEL_EX)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e0:SetRange(LOCATION_EXTRA)
		e0:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e0:SetLabel(i)
		e0:SetTarget(s.syntg)
		e0:SetValue(s.synval)
		c:RegisterEffect(e0)
	end

	--Effect 1: Quick Effect (Standby/Main)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.sccon)
	e1:SetTarget(s.sctg)
	e1:SetOperation(s.scop)
	c:RegisterEffect(e1)
end

--Logic for Link Monster as Tuner
function s.matfilter1(c,syncard)
	--Can be a normal Tuner OR a Link Monster
	return c:IsTuner(syncard) or c:IsType(TYPE_LINK)
end
function s.matfilter2(c,syncard)
	--Must be Non-Tuner and have a Level (Links cannot be the non-tuner unless they gain a level elsewhere, but usually standard non-tuners)
	return c:IsNotTuner(syncard) and c:IsLevelAbove(1)
end
function s.syntg(e,c)
	return c:IsType(TYPE_LINK) and c:IsLink(e:GetLabel())
end
function s.synval(e,syncard)
	if e:GetHandler()==syncard then
		return e:GetLabel()
	else
		return 0
	end
end

--Effect 1 Logic
function s.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_STANDBY or Duel.IsMainPhase()
end

function s.cfilter(c,e,tp,rc,opchk)
	if not (c:IsType(TYPE_LINK) and c:IsAbleToRemoveAsCost()) then return false end
	local link=c:GetLink()
	if link<1 then return false end
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),link)
	if ft<1 then return false end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(s.scfilter1,tp,LOCATION_GRAVE,0,c,e,tp)
	return g:CheckSubGroup(s.scfilter2,1,ft,e,tp,rc,opchk)
end
function s.scfilter1(c,e,tp)
	return c:GetLevel()>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.scfilter2(g,e,tp,rc,opchk)
	local et={}
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(rc)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
		e1:SetCode(EFFECT_MUST_BE_SMATERIAL)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		tc:RegisterEffect(e1)
		table.insert(et,e1)
	end
	local mg=Duel.GetSynchroMaterial(tp):Filter(Card.IsOnField,nil)
	local res=Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,nil,Group.__add(g,mg))
	for _,v in pairs(et) do v:Reset() end
	return res
end
function s.synfilter(c,g)
	return c:IsSynchroSummonable(nil,g,1,99)
end
function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,c):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	e:SetLabel(tc:GetLink())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local max_s=math.min(ct,ft)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.scfilter1),tp,LOCATION_GRAVE,0,nil,e,tp)
	if #g<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,s.scfilter2,false,1,ft,e,tp,c,true)
	if not sg then return end
	for tc in aux.Next(sg) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
	local og=Duel.GetOperatedGroup()
	Duel.AdjustAll()
	if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<#g then return end
	local et={}
	for tc in aux.Next(og) do
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_MUST_BE_SMATERIAL)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,0)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		table.insert(et,e3)
	end
	local mg=Duel.GetSynchroMaterial(tp):Filter(Card.IsOnField,nil)
	local tg=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if tg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=tg:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,rg:GetFirst(),nil,mg,1,99)
	end
	for _,v in pairs(et) do v:Reset() end
end