--百眼兽
function c40009276.initial_effect(c)
	--spsummon1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009276,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40009276)
	e1:SetCondition(c40009276.spcon1)
	e1:SetTarget(c40009276.sptg)
	e1:SetOperation(c40009276.spop)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009276,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,40009276)
	e2:SetCondition(c40009276.spcon2)
	e2:SetTarget(c40009276.sptg)
	e2:SetOperation(c40009276.spop)
	c:RegisterEffect(e2)  
   --special summon (hand)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009276,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,40009277)
	e3:SetTarget(c40009276.sptg1)
	e3:SetOperation(c40009276.spop1)
	c:RegisterEffect(e3)  
end
function c40009276.spcon1(e,tp,eg,ep,ev,re,r,rp)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)==1
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c40009276.hsfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb) 
end
function c40009276.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c40009276.hsfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c40009276.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c40009276.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c40009276.spfilter(c,e,tp)
	return c:IsSetCard(0xb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009276.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local loc=LOCATION_HAND 
		if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then
			loc=loc+LOCATION_DECK
		end
		return Duel.IsExistingMatchingCard(c40009276.spfilter,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c40009276.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local loc=LOCATION_HAND 
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then
		loc=loc+LOCATION_DECK
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009276.spfilter,tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

