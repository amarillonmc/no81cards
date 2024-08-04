--神树精灵 牛鬼
function c9910332.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910332+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9910332.spcon)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,9910333)
	e2:SetTarget(c9910332.sptg)
	e2:SetOperation(c9910332.spop)
	c:RegisterEffect(e2)
end
function c9910332.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3956)
end
function c9910332.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910332.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c9910332.spfilter(c,e,tp)
	return c:IsSetCard(0x3956) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLevelBelow(4) or c:IsLocation(LOCATION_DECK))
end
function c9910332.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local res=c:IsReason(REASON_MATERIAL+REASON_SYNCHRO) and rc and rc:IsAttribute(ATTRIBUTE_LIGHT)
	local loc=LOCATION_HAND+LOCATION_GRAVE
	if res then loc=loc+LOCATION_DECK end
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		return Duel.IsExistingMatchingCard(c9910332.spfilter,tp,loc,0,1,nil,e,tp)
	end
	if res then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c9910332.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local loc=LOCATION_HAND+LOCATION_GRAVE
	if e:GetLabel()==1 then loc=loc+LOCATION_DECK end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910332.spfilter),tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
