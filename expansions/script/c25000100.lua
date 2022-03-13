--千星之心
function c25000100.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25000100,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,25000100)
	e1:SetTarget(c25000100.target)
	e1:SetOperation(c25000100.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25000100,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,25000100)
	e2:SetTarget(c25000100.sptg)
	e2:SetOperation(c25000100.spop)
	c:RegisterEffect(e2)
	
end
function c25000100.filter(c,e,sp)
	return not c:IsSummonableCard() and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c25000100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25000100.filter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c25000100.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c25000100.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		c:SetCardTarget(g:GetFirst())
		--indes
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(c25000100.indct)
		g:GetFirst():RegisterEffect(e2)
	end
end
function c25000100.indct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0 or (bit.band(r,REASON_EFFECT)~=0 and rp~=e:GetOwnerPlayer())
end
function c25000100.same_check(c,mc)
	local flag=0
	if c:GetRace()==mc:GetRace() then flag=flag+1 end
	if c:GetAttribute()==mc:GetAttribute() then flag=flag+1 end
	if c:GetLevel()==mc:GetLevel() then flag=flag+1 end
	if c:GetTextAttack()==mc:GetTextAttack() then flag=flag+1 end
	if c:GetTextDefense()==mc:GetTextDefense() then flag=flag+1 end
	return flag==1
end
function c25000100.spfilter(c,e,tp,ec)
	return c:IsFaceup() and ec:IsHasCardTarget(c)
		and Duel.IsExistingMatchingCard(c25000100.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c25000100.spfilter2(c,e,tp,ec)
	return c:IsSummonableCard() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		   and c25000100.same_check(c,ec)
end
function c25000100.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c25000100.spfilter(chkc,e,tp,e:GetHandler()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c25000100.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c25000100.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c25000100.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c25000100.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		e:GetHandler():SetCardTarget(g:GetFirst())
	end
end
