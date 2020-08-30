function c82228505.initial_effect(c)  
	--link summon  
	aux.AddLinkProcedure(c,nil,2,2,c82228505.lcheck)  
	c:EnableReviveLimit()
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228505,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCountLimit(1,82228505)  
	e1:SetCondition(c82228505.spcon)  
	e1:SetTarget(c82228505.sptg)  
	e1:SetOperation(c82228505.spop)  
	c:RegisterEffect(e1)  
	--extra summon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228505,1))  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)  
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x291))  
	c:RegisterEffect(e2) 
end
function c82228505.lcheck(g,lc)  
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x291)  
end  
function c82228505.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function c82228505.spfilter(c,e,tp)  
	return c:IsSetCard(0x291) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)  
end  
function c82228505.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(c82228505.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)  
end  
function c82228505.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,c82228505.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)  
	local tc=g:GetFirst()  
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1)  
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetCode(EFFECT_DISABLE_EFFECT)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e2)  
		local e3=Effect.CreateEffect(c)  
		e3:SetType(EFFECT_TYPE_SINGLE)  
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e3:SetReset(RESET_EVENT+RESETS_REDIRECT)  
		e3:SetValue(LOCATION_REMOVED)  
		tc:RegisterEffect(e3,true)  
	end  
	Duel.SpecialSummonComplete()  
end  