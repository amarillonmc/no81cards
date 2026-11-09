--Connecting the Stars
function c33741109.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c33741109.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33741109,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c33741109.spcon)
	e2:SetTarget(c33741109.sptg)
	e2:SetOperation(c33741109.spop)
	c:RegisterEffect(e2)
end
function c33741109.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c33741109.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=1-tp
	local loc=LOCATION_HAND+LOCATION_MZONE
	if Duel.IsExistingMatchingCard(c33741109.rmfilter,p,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(p,aux.Stringid(33741109,3)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
		local tc=Duel.SelectMatchingCard(p,c33741109.rmfilter,p,LOCATION_DECK,0,1,1,nil):GetFirst()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		loc=LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK
		e:GetHandler():SetCardTarget(tc)
	end
	if Duel.IsExistingMatchingCard(c33741109.rmfilter,tp,loc,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33741109,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Duel.SelectMatchingCard(tp,c33741109.rmfilter,tp,loc,0,1,1,nil):GetFirst()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		e:GetHandler():SetCardTarget(tc)
	end
	e:GetHandler():RegisterFlagEffect(33741109,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c33741109.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(33741109)==0
end
function c33741109.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(c:GetControler())>0
end
function c33741109.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetCardTarget():Filter(c33741109.spfilter,nil,e,tp)
	if chk==0 then return #g>0 and (not Duel.IsPlayerAffectedByEffect(tp,59822133) or #g==1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,tp,LOCATION_REMOVED)
end
function c33741109.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCardTarget():Filter(c33741109.spfilter,nil,e,tp)
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)==0 or #g==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and #g==2 then return end
	for tc in aux.Next(g) do
		Duel.SpecialSummonStep(tc,0,tp,tc:GetControler(),false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
