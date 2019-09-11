--不死组·事后的延续
function c9950005.initial_effect(c)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950005,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c9950005.spcon2)
	e3:SetTarget(c9950005.sptg2)
	e3:SetOperation(c9950005.spop2)
	c:RegisterEffect(e3)
   --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950005,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c9950005.spcon)
	e1:SetTarget(c9950005.sptg)
	e1:SetOperation(c9950005.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
end
function c9950005.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xba1) 
end
function c9950005.spcon2(e,tp,eg,ep,ev,re,r,rp)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950005.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c9950005.spfilter2(c,e,tp,mc)
	return c:IsSetCard(0xba2) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9950005.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c9950005.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9950005.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9950005.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.Overlay(tc,Group.FromCards(c))
		end
	end
end
function c9950005.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and rp==1-tp and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c9950005.spfilter(c,e,tp)
	return c:IsSetCard(0xba1) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local loc=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_DECK end
		if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
		return loc~=0 and Duel.IsExistingMatchingCard(c9950005.spfilter,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c9950005.spop(e,tp,eg,ep,ev,re,r,rp)
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_DECK end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9950005.spfilter,tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
