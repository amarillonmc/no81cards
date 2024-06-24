if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MONSTER_SSET)
	e0:SetValue(0x20002)
	c:RegisterEffect(e0)
	local e1,e1_1=SNNM.ActivatedAsSpellorTrap(c,0x20002,LOCATION_HAND+LOCATION_SZONE,true)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCondition(s.accon)
	e1_1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetRange(0xff)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCondition(s.scon)
	e3:SetTarget(s.stg)
	e3:SetOperation(s.sop)
	c:RegisterEffect(e3)
	SNNM.ActivatedAsSpellorTrapCheck(c)
	SNNM.SetAsSpellorTrapCheck(c,0x20002)
end
function s.accon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFacedown() or not c:IsLocation(LOCATION_SZONE)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function s.spfilter(c,e,tp)
	return c:IsLevelAbove(2) and c:IsLevelBelow(5) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_WATER) and not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsPreviousLocation(LOCATION_MZONE) and c:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=c:IsPreviousLocation(LOCATION_SZONE) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil,e,tp)
	if chk==0 then return (b1 or b2) and #g>0 end
	if b1 then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0) Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0) elseif b2 then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,Group.__add(g,c),2,0,0) end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsPreviousLocation(LOCATION_MZONE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and  Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then Duel.SSet(tp,c) end
	elseif c:IsPreviousLocation(LOCATION_SZONE) then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) then Duel.ConfirmCards(1-tp,c) end
		Duel.SpecialSummonComplete()
	end
end
function s.cfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsType(TYPE_SYNCHRO)
end
function s.scon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil) and rp==tp
end
function s.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.sop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end
