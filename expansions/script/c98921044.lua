--升华化栗子
function c98921044.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,2)
	c:EnableReviveLimit()	
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921044,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,98921044)
	e1:SetCondition(c98921044.spcon)
	e1:SetTarget(c98921044.sptg)
	e1:SetOperation(c98921044.spop)
	c:RegisterEffect(e1)	
	--Level change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98921044,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DETACH_MATERIAL)
	e2:SetCountLimit(1,98922044)
	e2:SetCondition(c98921044.damcon)
	e2:SetTarget(c98921044.damtg)
	e2:SetOperation(c98921044.damop)
	c:RegisterEffect(e2)
end
function c98921044.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c98921044.spfilter(c,e,tp)
	return c:IsLevel(1) and c:IsRace(RACE_THUNDER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c98921044.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98921044.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98921044.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98921044.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	end
	Duel.SpecialSummonComplete()
end
function c98921044.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():GetCount()==0
end
function c98921044.fselect(g)
	return g:GetClassCount(Card.GetCode)==1
end
function c98921044.lvfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c98921044.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921044.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
	e:SetLabel(Duel.AnnounceLevel(tp,1,3))
end
function c98921044.tgfilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c98921044.damop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c98921044.lvfilter,tp,LOCATION_MZONE,0,nil)
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
end