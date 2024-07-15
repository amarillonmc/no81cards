--占星术-星瀚神谕
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--tofield
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCondition(s.scon)
	e2:SetTarget(s.stg)
	e2:SetOperation(s.sop)
	c:RegisterEffect(e2)
end

function s.filter1(c)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER~=0
end

------------------------------type check------------------------------------------
function s.lf(c)
	return c:GetOriginalAttribute()&ATTRIBUTE_LIGHT~=0
end
function s.wdf(c)
	return c:GetOriginalAttribute()&ATTRIBUTE_WIND~=0
end
function s.gf(c)
	return c:GetOriginalAttribute()&ATTRIBUTE_EARTH~=0
end
function s.wf(c)
	return c:GetOriginalAttribute()&ATTRIBUTE_WATER~=0
end
function s.ff(c)
	return c:GetOriginalAttribute()&ATTRIBUTE_FIRE~=0
end
------------------------------type effect----------------------------------------
function s.thfilter(c)
	return c.VHisc_Astrologist and c:IsAbleToHand()
end
function s.spfilter(c,e,tp)
	return c.VHisc_Astrologist and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sfilter(c)
	return c.VHisc_Astrologist and c:IsFaceup()
end
---------------------------------end----------------------------------------

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_SZONE,0,nil)
	local rec=og:GetCount()*300
	if chk==0 then return rec>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
	if og:IsExists(s.lf,1,nil) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	if og:IsExists(s.wdf,1,nil) then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
	end
	if og:IsExists(s.gf,1,nil) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	end
	if og:IsExists(s.wf,1,nil) then
		e:SetCategory(CATEGORY_DISABLE)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,tp,LOCATION_ONFIELD)
	end
	if og:IsExists(s.ff,1,nil) then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local og=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_SZONE,0,nil)
	local rec=og:GetCount()*300
	local c=e:GetHandler()
	Duel.Recover(tp,rec,REASON_EFFECT)
	Duel.BreakEffect()
	---light
	if og:IsExists(s.lf,1,nil) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local thg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if thg:GetCount()>0 and Duel.SendtoHand(thg,nil,REASON_EFFECT)~=0 and thg:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,thg)
			Duel.ShuffleHand(tp)
			Duel.ShuffleDeck(tp)
		end
	end
	---wind
	if og:IsExists(s.wdf,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local rtg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
		Duel.HintSelection(rtg)
		if rtg:GetCount()>0 then Duel.SendtoHand(rtg,nil,REASON_EFFECT) end
	end
	---earth
	if og:IsExists(s.gf,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,3)) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local spg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local spc=spg:GetFirst()
		if spc then Duel.SpecialSummon(spc,0,tp,tp,false,false,POS_FACEUP) end	
	end
	---water
	if og:IsExists(s.wf,1,nil) and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local ng=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
		Duel.HintSelection(ng)
		local nc=ng:GetFirst()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		nc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		nc:RegisterEffect(e3)
	end
	---fire
	if og:IsExists(s.ff,1,nil) and Duel.IsExistingMatchingCard(aux.TURE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
		if dg:GetCount()>0 then
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end

--e2
function s.scon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function s.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_ONFIELD,0,1,nil) and e:GetHandler():IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.SSet(tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT-RESET_TURN_SET)
		e1:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e1,true)
	end
end