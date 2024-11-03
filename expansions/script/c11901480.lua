--罗星 船底座
local s,id,o=GetID()
function s.initial_effect(c)
    --Set Card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
    e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    --negate
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.cicon)
	e2:SetTarget(s.citg)
	e2:SetOperation(s.ciop)
	c:RegisterEffect(e2)
end
function s.stfilter(c)
    return c:IsSetCard(0x409) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x409) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tdfilter(c,e,tp)
	return c:IsAbleToDeck() and (c:IsLocation(0x02) or (c:IsSetCard(0x409) and c:IsFaceup()))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
    if tg:GetFirst():IsLocation(0x0c) then Duel.HintSelection(tg) end
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)==0 or not tc:IsLocation(0x41) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.fi1ter(c)
	return c:IsAbleToGrave() and c:IsLocation(0x0c)
end
function s.cicon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
        or not re:GetHandler():IsSetCard(0x409) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(s.fi1ter,1,e:GetHandler(),tp)
        and e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function s.citg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(s.fi1ter,e:GetHandler())
	local tc=tg:GetFirst()
    while tc do
	    tc:CreateEffectRelation(e)
        tc=tg:GetNext()
    end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tg,tg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.ciop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local c=e:GetHandler()
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,c,e)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and #tg>0 then 
		Duel.SendtoGrave(tg,nil,REASON_EFFECT)
	end 
end