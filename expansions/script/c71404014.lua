--星忆涉宿
if not c71404000 then dofile("expansions/script/c71404000.lua") end
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCountLimit(1,id)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(yume.stellar_memories.LowSpellActivationTg(71404003,71404004))
	e1:SetCost(yume.stellar_memories.LimitCost)
	e1:SetOperation(yume.stellar_memories.LowSpellActivationOp(
		71404003,71404004,aux.Stringid(id,1),aux.Stringid(id,2)
	))
	c:RegisterEffect(e1)
	--extra link material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCountLimit(1,id+100000)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(yume.stellar_memories.BanishedSpellCon(71404003))
	e2:SetCost(yume.stellar_memories.LimitCost)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	--ritual summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,4))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA+CATEGORY_GRAVE_SPSUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,id+110000)
	e3:SetCondition(yume.stellar_memories.BanishedSpellCon(71404004))
	e3:SetCost(yume.stellar_memories.LimitCost)
	e3:SetTarget(s.tg3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_ONFIELD,0)
	e1:SetTarget(s.mattg)
	e1:SetValue(s.matval)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function s.mattg(e,c)
	return c:IsFaceupEx() and c:IsType(TYPE_SPELL)
end
function s.matval(e,lc,mg,c,tp)
	if not (lc:IsRace(RACE_SPELLCASTER) and e:GetHandlerPlayer()==tp) then return false,nil end
	return true,true
end
function s.MultiRitualToDeckFilter(c)
	return yume.stellar_memories.RitualIncludeCheck(c)
		and c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsAbleToDeck()
		and c:IsFaceupEx()
end
function s.MultiRitualTargetCheck(e,tp,greater_or_equal,summon_location,mat_location)
	local mg=Duel.GetMatchingGroup(s.MultiRitualToDeckFilter,tp,mat_location,0,nil,tp)
	local res=Duel.IsExistingMatchingCard(yume.stellar_memories.MultiRitualMonsterFilter,tp,summon_location,0,1,nil,e,tp,mg,Card.GetLink,greater_or_equal)
	return res
end
function s.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local mat_location=LOCATION_GRAVE+LOCATION_REMOVED
	local summon_location=LOCATION_GRAVE+LOCATION_REMOVED
	local greater_or_equal="Greater"
	if chk==0 then
		return s.MultiRitualTargetCheck(e,tp,greater_or_equal,summon_location,mat_location)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,summon_location)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,0,tp,mat_location)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<0 then return end
	::cancel::
	local mat_location=LOCATION_GRAVE+LOCATION_REMOVED
	local summon_location=LOCATION_GRAVE+LOCATION_REMOVED
	local greater_or_equal="Greater"
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.MultiRitualToDeckFilter),tp,mat_location,0,nil,tp)
	if ft==0 then
		mg=mg:Filter(yume.stellar_memories.MainZoneFilter,nil,tp)
	end
	mg=mg:Filter(yume.stellar_memories.MultiRitualSelectToUseFilter,nil,e,tp,summon_location,Card.GetLink,greater_or_equal)
	if mg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local mat=mg:Select(tp,1,1,nil)
	local mc=mat:GetFirst()
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(yume.stellar_memories.MultiRitualSelectToSummonFilter),tp,summon_location,0,mc,e,tp,mc,Card.GetLink,greater_or_equal)
	if sg:GetCount()==0 then return end
	if mc:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	if ct and ct<ft then ft=ct end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	--Ritual Summon 1 monster with ritual Level
	local b1=sg:IsExists(yume.stellar_memories.MultiRitualRitualLevelCheck,1,nil,mc,Card.GetLink,greater_or_equal)
	--Ritual Summon 1+ monsters with Link Rating
	local b2=sg:IsExists(yume.stellar_memories.MultiRitualLevelCheck,1,nil,mc,Card.GetLink,greater_or_equal)
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(71404000,4))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Filter(yume.stellar_memories.MultiRitualRitualLevelCheck,nil,mc,Card.GetLink,greater_or_equal):SelectUnselect(nil,tp,false,true,1,1)
		if not tc then goto cancel end
		tc:SetMaterial(mat)
		Duel.SendtoDeck(mc,nil,SEQ_DECKTOP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	else
		local lv=mc:GetLink()*2
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)aux.GCheckAdditional=yume.stellar_memories.MultiRitualCheckAdditional(lv)
		local tg=mg:SelectSubGroup(tp,yume.stellar_memories.MultiRitualFSelect,true,1,ft,tp,lv)
		aux.GCheckAdditional=nil
		if not tg then goto cancel end
		local tc=tg:GetFirst()
		while tc do
			tc:SetMaterial(mat)
			tc=tg:GetNext()
		end
		Duel.SendtoDeck(mat,nil,SEQ_DECKTOP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		tc=tg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
			tc=tg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end