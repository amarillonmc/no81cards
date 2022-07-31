--破碎世界的战车
function c6160009.initial_effect(c)
   --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6160009,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,6160009)
	e1:SetCondition(c6160009.condition)
	e1:SetTarget(c6160009.sptg)
	e1:SetOperation(c6160009.spop)
	c:RegisterEffect(e1) 
end
function c6160009.cfilter(c)  
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end  
function c6160009.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(c6160009.cfilter,tp,LOCATION_ONFIELD,0,1,nil)  
end   
function c6160009.spfilter(c,e,tp)
	return c:IsSetCard(0x616) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c6160009.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c6160009.spfilter(chkc,e,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c6160009.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c6160009.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c6160009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		local g=Group.FromCards(c,tc)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end