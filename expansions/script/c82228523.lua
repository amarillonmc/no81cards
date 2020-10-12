function c82228523.initial_effect(c)
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,82228523)
	e1:SetCondition(c82228523.spcon)  
	c:RegisterEffect(e1) 
	--spsummon2  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228523,0))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetCondition(c82228523.spcon2)  
	e2:SetTarget(c82228523.sptg2)  
	e2:SetOperation(c82228523.spop2)  
	c:RegisterEffect(e2)  
end  
c82228523.card_code_list={82228521}
function c82228523.spfilter(c)  
	return c:IsFaceup() and c:GetMutualLinkedGroupCount()>0
end  
function c82228523.spcon(e,c)  
	if c==nil then return true end  
	local tp=c:GetControler()  
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(c82228523.spfilter,tp,LOCATION_MZONE,0,1,nil)  
end  
function c82228523.spcon2(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)  
end  
function c82228523.spfilter2(c,e,tp)  
	return c:IsCode(82228521) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function c82228523.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(c82228523.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)  
end  
function c82228523.spop2(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,c82228523.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  