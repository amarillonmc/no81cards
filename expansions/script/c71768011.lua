--六花精 报春
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_RELEASE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_HAND)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(s.xyzcon)
	e3:SetCost(s.xyzcost)
	e3:SetTarget(s.xyztg)
	e3:SetOperation(s.xyzop)
	c:RegisterEffect(e3)
end
function s.cfilter(c,tp)
	return c:GetOriginalType()&TYPE_MONSTER~=0 
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not c:IsCode(id)
end
function s.matfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x141) and c:IsCanOverlay()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and c:IsSummonLocation(LOCATION_GRAVE) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			c:RegisterEffect(e1) 
		end
		if Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp) 
			if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 and sg:GetFirst():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.matfilter),tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local og=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.matfilter),tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
				Duel.Overlay(sg:GetFirst(),og)
			end
		end
	end
end
function s.cefilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function s.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp or Duel.IsExistingMatchingCard(s.cefilter,tp,0,LOCATION_MZONE,1,nil)
end
function s.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function s.mfilter(c)
	return c:IsFaceupEx() and c:IsRace(RACE_PLANT) and not c:IsType(TYPE_TOKEN)
end
function s.exgfilter(c,mg,mc)
	return mg:CheckSubGroup(s.exgselect,2,2,c,mc)
end
function s.exgselect(g,exc,mc)
	return exc:IsSetCard(0x141) and exc:IsXyzSummonable(g,2,2)
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.GetMatchingGroupCount(s.exgfilter,tp,LOCATION_EXTRA,0,nil,mg,c)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local exg=Duel.GetMatchingGroup(s.exgfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if #exg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=exg:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local msg=mg:SelectSubGroup(tp,s.exgselect,false,2,2,sc)
	local cg=msg:Filter(Card.IsFacedown,nil)
	Duel.ConfirmCards(1-tp,cg)
	Duel.XyzSummon(tp,sc,msg,#msg,#msg)
	Duel.ShuffleHand(tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_PLANT)
end