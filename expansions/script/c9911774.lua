--星幽使 在原晓
function c9911774.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9911774)
	e1:SetTarget(c9911774.target)
	e1:SetOperation(c9911774.operation)
	c:RegisterEffect(e1)
	--spsummon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911774,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911775)
	e1:SetCost(c9911774.spcost)
	e1:SetTarget(c9911774.sptg)
	e1:SetOperation(c9911774.spop)
	c:RegisterEffect(e1)
end
function c9911774.spfilter(c,e,tp)
	return c:IsSetCard(0x3957) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911774.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9911774.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9911774.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0):Select(tp,1,1,nil)
	if #g==0 then return end
	Duel.HintSelection(g)
	if Duel.Destroy(g,REASON_EFFECT)==0 then return end
	Duel.AdjustAll()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c9911774.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9911774.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c9911774.spfilter2(c,e,tp)
	return c:IsSetCard(0x3957) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911774.fselect(g,tp,mc)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>=#g and aux.dncheck(g) and g:IsContains(mc)
		and (not Duel.IsPlayerAffectedByEffect(tp,59822133) or #g==1)
end
function c9911774.filter(c,tg,tp,mc)
	return c:IsFaceupEx() and c:IsType(TYPE_LINK) and tg:CheckSubGroup(c9911774.fselect,c:GetLink(),c:GetLink(),tp,mc)
end
function c9911774.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(c9911774.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c9911774.filter(chkc,tg,tp,c) end
	if chk==0 then return Duel.IsExistingTarget(c9911774.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil,tg,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c9911774.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,tg,tp,c):GetFirst()
	if tc:IsLocation(LOCATION_GRAVE) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA+CATEGORY_GRAVE_ACTION)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,tc:GetLink(),tp,LOCATION_HAND+LOCATION_DECK)
end
function c9911774.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToChain() or not tc:IsRelateToChain() then return end
	local ct=tc:GetLink()
	local tg=Duel.GetMatchingGroup(c9911774.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=tg:SelectSubGroup(tp,c9911774.fselect,false,ct,ct,tp,c)
	if sg:GetCount()>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0
		and tc:IsRelateToChain() and tc:IsAbleToExtra() and Duel.SelectYesNo(tp,aux.Stringid(9911774,1)) then
		Duel.BreakEffect()
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
