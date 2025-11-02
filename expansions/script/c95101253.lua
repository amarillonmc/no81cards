--猎狼之红姬
function c95101253.initial_effect(c)
	--spsummon-self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95101253,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,95101253)
	e1:SetCondition(c95101253.spscon)
	e1:SetTarget(c95101253.spstg)
	e1:SetOperation(c95101253.spsop)
	c:RegisterEffect(e1)
	--spsummon-other
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95101253,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,95101253+1)
	e2:SetTarget(c95101253.sptg)
	e2:SetOperation(c95101253.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c95101253.spscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c95101253.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c95101253.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c95101253.spfilter(c,e,tp,chk)
	return c:IsCode(95101253) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))
end
function c95101253.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c95101253.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c95101253.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c95101253.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,1):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c95101253.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c95101253.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return (not c:IsType(TYPE_XYZ) or c:IsNonAttribute(ATTRIBUTE_DARK)) and c:IsLocation(LOCATION_EXTRA)
end
