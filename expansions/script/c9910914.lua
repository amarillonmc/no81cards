--神械残骸 监听者
function c9910914.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910914)
	e1:SetTarget(c9910914.sptg)
	e1:SetOperation(c9910914.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c9910914.spcon)
	e2:SetCost(c9910914.spcost)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c9910914.setcost)
	e3:SetTarget(c9910914.settg)
	e3:SetOperation(c9910914.setop)
	c:RegisterEffect(e3)
end
function c9910914.rmfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function c9910914.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c9910914.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910914.rmfilter,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c9910914.rmfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9910914.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9910914.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c9910914.cfilter(c)
	return c:IsSetCard(0xc954) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9910914.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910914.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910914.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9910914.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9910914.setfilter(c,e,tp)
	if c:IsCode(9910914) and not c:IsSetCard(0xc954) then return false end
	return (c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)) or c:IsSSetable()
end
function c9910914.fselect(g,tp)
	local ct1=g:FilterCount(Card.IsType,nil,TYPE_MONSTER)
	local ct2=g:FilterCount(Card.IsType,nil,TYPE_FIELD)
	return aux.gffcheck(g,Card.IsCode,9910914,Card.IsSetCard,0xc954) and ct1<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and ct2<=1 and #g-ct1-ct2<=Duel.GetLocationCount(tp,LOCATION_SZONE)
end
function c9910914.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910914.setfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return g:CheckSubGroup(c9910914.fselect,2,2,tp) end
end
function c9910914.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910914.setfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if not g:CheckSubGroup(c9910914.fselect,2,2,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:SelectSubGroup(tp,c9910914.fselect,false,2,2,tp)
	if #sg==0 then return end
	local mg=sg:Filter(Card.IsType,nil,TYPE_MONSTER)
	if #mg>0 then
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,mg)
		sg:Sub(mg)
	end
	if #sg>0 then
		Duel.SSet(tp,sg)
	end
end
