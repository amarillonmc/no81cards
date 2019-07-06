--霓虹之间
function c33700735.initial_effect(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700735,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(c33700735.spcon)
	e2:SetTarget(c33700735.sptg)
	e2:SetOperation(c33700735.spop)
	c:RegisterEffect(e2)
end
function c33700735.cfilter(c,tp)
	return c:IsType(TYPE_TUNER) and c:IsPreviousLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp 
end
function c33700735.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33700735.cfilter,1,nil,tp)
end
function c33700735.filter(c,e,tp)
	return c:IsCode(33700736) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700735.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33700735.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c33700735.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33700735.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		g:GetFirst():RegisterFlagEffect(33700736,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33700735,1))
	end
end
