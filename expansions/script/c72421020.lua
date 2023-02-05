--阿里乌斯特殊小队・日和
function c72421020.initial_effect(c)	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72421020,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,72421020)
	e1:SetCondition(c72421020.con)
	e1:SetTarget(c72421020.tg1)
	e1:SetOperation(c72421020.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72421020,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,72421020)
	e2:SetCondition(c72421020.con)
	e2:SetTarget(c72421020.tg2)
	e2:SetOperation(c72421020.op2)
	c:RegisterEffect(e2)
end
function c72421020.con(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c72421020.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() end
end
function c72421020.setfilter(c)
	return c:IsCode(72421510) and not c:IsForbidden()
end
function c72421020.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.SendtoGrave(c,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c72421020.setfilter,tp,LOCATION_DECK,0,nil)
		if not Duel.IsExistingMatchingCard(c72421020.setfilter,tp,LOCATION_SZONE,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g:GetCount()>0
			and Duel.SelectYesNo(tp,aux.Stringid(72421020,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg=g:Select(tp,1,1,nil)
			Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c72421020.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72421020.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(c72421020.thfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c72421020.thfilter(c)
	return (c:IsCode(72421510) or c:IsSetCard(0x9725)) and c:IsAbleToHand()
end
function c72421020.spfilter(c,e,tp)
	return c==e:GetHandler() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72421020.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local g=Duel.SelectMatchingCard(tp,c72421020.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0  then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c72421020.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(72421020,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:GetFirst(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end