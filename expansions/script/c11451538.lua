--辉影翩跹
--21.06.13
local cm,m=GetID()
function cm.initial_effect(c)
	--act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(cm.actcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_ATTACK)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--twice bp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11451537,4))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.con)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.actcon(e)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsLevel(10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.fselect(g,tp)
	return Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g,tp) and g:GetClassCount(Card.GetAttribute)==#g
end
function cm.xyzfilter(c,g,tp)
	return c:IsRace(RACE_MACHINE) and c:IsXyzSummonable(g,#g,#g) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.IsPlayerAffectedByEffect(tp,63060238) or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<6 or not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return false end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if #g==0 then return false end
		ft=math.min(g:GetClassCount(Card.GetAttribute),ft)
		return g:CheckSubGroup(cm.fselect,1,ft,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,63060238) or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<6 or not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.ConfirmDecktop(tp,6)
	local g=Duel.GetDecktopGroup(tp,6):Filter(cm.spfilter,nil,e,tp)
	if #g==0 then return false end
	ft=math.min(g:GetClassCount(Card.GetAttribute),ft)
	if g:CheckSubGroup(cm.fselect,1,ft,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,cm.fselect,false,1,ft,tp)
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
			tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
		local og=Duel.GetOperatedGroup()
		Duel.ShuffleDeck(tp)
		Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
		if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<#sg then return end
		local tg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,og,tp)
		if #og==#sg and #tg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rg=tg:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,rg:GetFirst(),og)
		end
	else
		Duel.ShuffleDeck(tp)
	end
end
function cm.filter(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil) and aux.bpcon() and not eg:IsContains(e:GetHandler())
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHandAsCost() end
	Duel.SendtoHand(c,1-tp,REASON_COST)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_BP_TWICE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end