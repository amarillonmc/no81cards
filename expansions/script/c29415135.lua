--隐匿之徒于阴影中
local s,id,o=GetID()
function c29415135.initial_effect(c)
	--sp 
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_SINGLE) 
	e0:SetCode(29415126)  
	e0:SetRange(LOCATION_DECK)  
	e0:SetOperation(s.spop) 
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
--special
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x980,TYPE_NORMAL+TYPE_MONSTER,0,0,3,RACE_FIEND,ATTRIBUTE_DARK) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,1)) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP) 
	end
end
--todeck
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.special(c,e,tp)
    return c:IsSetCard(0x980) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.deck(c)
    return c:IsSetCard(0x980) and c:IsLocation(LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
        local g=Duel.GetMatchingGroup(s.special,tp,LOCATION_DECK,0,nil,e,tp)
        local sg=Duel.GetOperatedGroup():Filter(s.deck,nil)
        if #sg>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
            local ag=g:Select(tp,1,1,nil)
            Duel.SpecialSummon(ag,0,tp,tp,false,false,POS_FACEUP)
        end
	end
end