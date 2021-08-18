--里克·多拉
function c60000121.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60000121,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,60000121)
	e1:SetCondition(c60000121.spcon)
	e1:SetTarget(c60000121.sptg)
	e1:SetOperation(c60000121.spop)
	c:RegisterEffect(e1)	
	--...
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60000121,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10000121)
	e2:SetTarget(c60000121.tetg)
	e2:SetOperation(c60000121.teop)
	c:RegisterEffect(e2)
end
function c60000121.cfilter(c)
	return c:IsCode(60000102) or (c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevel(1))
end
function c60000121.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60000121.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60000121.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c60000121.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c60000121.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE) end
end
function c60000121.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.CreateToken(tp,60000124)
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end








