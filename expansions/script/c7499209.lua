--艺形虫 波普P-58
local s,id,o=GetID()
--string
s.named_with_ArtlienWorm=1
--string check
function s.ArtlienWorm(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ArtlienWorm
end
--
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--select
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.slcon)
	e2:SetTarget(s.sltg)
	e2:SetOperation(s.slop)
	c:RegisterEffect(e2)
end
function s.pubfilter(c,e,tp)
	if not s.ArtlienWorm(c) or not c:IsType(TYPE_MONSTER) or c:IsPublic() then return false end
	local g=Group.FromCards(c,e:GetHandler())
	return g:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,false,false)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.pubfilter,tp,LOCATION_HAND,0,1,c,e,tp) and not c:IsPublic() end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local pc=Duel.SelectMatchingCard(tp,s.pubfilter,tp,LOCATION_HAND,0,1,1,c,e,tp):GetFirst()
	Duel.ConfirmCards(1-tp,pc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	pc:RegisterEffect(e1)
	local e2=e1:Clone()
	c:RegisterEffect(e2)
	Duel.SetTargetCard(Group.FromCards(pc,c))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if g:GetCount()~=2 or Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=g:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,false,false):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		g:RemoveCard(sc)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(id,5))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e2:SetValue(LOCATION_REMOVED)
		g:GetFirst():RegisterEffect(e2)
	end
end
function s.chkfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function s.slcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.chkfilter,1,nil)
end
function s.cfilter(c,e,tp)
	return s.ArtlienWorm(c) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 or c:IsAbleToGrave() and c:IsType(TYPE_MONSTER))
end
function s.sltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
end
function s.cfilter(c,e,tp)
	return s.ArtlienWorm(c) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsAbleToGrave())
end
function s.spfilter(c,e,tp)
	return s.ArtlienWorm(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.slop(e,tp,eg,ep,ev,re,r,rp)
	local check=false
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc then
		if Duel.GetMZoneCount(tp)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and ((not tc:IsAbleToGrave()) or Duel.SelectOption(tp,aux.Stringid(id,0),1191)==0) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
			if not tc:IsLocation(LOCATION_HAND) then check=true end
		end
	else check=true end
	if check and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
