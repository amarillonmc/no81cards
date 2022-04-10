function c60000238.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60000238)
	e1:SetTarget(c60000238.target)
	e1:SetOperation(c60000238.activate)
	c:RegisterEffect(e1)
end
function c60000238.filter(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function c60000238.spfilter(c,e,tp,tc)
	return c:IsRace(tc:GetRace()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60000238.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()==tp and c60000238.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60000238.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c60000238.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c60000238.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetControl(tc,1-tp)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	 local g=Duel.SelectMatchingCard(tp,c60000238.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
		if g:GetCount()~=0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
