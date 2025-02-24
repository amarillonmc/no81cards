--Alstroemeria 鹿乃
function c75646419.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c75646419.lcheck)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646419,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,5646419)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c75646419.cost)
	e1:SetTarget(c75646419.cptg)
	e1:SetOperation(c75646419.cpop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,75646419)
	e2:SetCondition(c75646419.tdcon)
	e2:SetTarget(c75646419.tdtg)
	e2:SetCost(c75646419.tdcost)
	e2:SetOperation(c75646419.tdop)
	c:RegisterEffect(e2)   
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c75646419.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0x32c4)
end
function c75646419.thcfilter(c)
	return c:IsSetCard(0x32c4) and c:IsAbleToGraveAsCost()
end
function c75646419.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646419.thcfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75646419.thcfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c75646419.cpfilter(c)
	return c:IsSetCard(0x32c4) and c:IsType(TYPE_MONSTER)
end
function c75646419.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.IsExistingTarget(c75646419.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c75646419.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c75646419.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and (not tc:IsLocation(LOCATION_MZONE) or tc:IsFaceup()) then
		local code=tc:GetCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
	end
end
function c75646419.cfilter2(c,g)
	return c:IsFaceup() and g:IsContains(c) and c:IsSetCard(0x32c4)
end
function c75646419.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg and eg:IsExists(c75646419.cfilter2,1,nil,lg)
end
function c75646419.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return g:FilterCount(Card.IsAbleToGraveAsCost,nil)==1 end
	if g:GetFirst():IsSetCard(0x32c4) then e:SetLabel(1) else e:SetLabel(0) end
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g,REASON_COST)
end
function c75646419.setfilter(c)
	return c:IsSetCard(0x32c4) and c:IsAbleToDeck()
end
function c75646419.filter(c,e,tp)
	return c:IsSetCard(0x32c4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646419.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646419.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(c75646419.filter,tp,LOCATION_DECK,0,1,nil,e,tp) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function c75646419.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c75646419.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		Duel.ShuffleDeck(tp)
		end
	end
	if e:GetLabel()==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75646419.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(75646419,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75646419.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end