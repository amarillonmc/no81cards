--罗星 鹿豹座
local s,id,o=GetID()
function s.initial_effect(c)
    --SearchCard
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,id)
	e1:SetCost(s.htgcost)
	e1:SetTarget(s.htgtg) 
	e1:SetOperation(s.htgop) 
	c:RegisterEffect(e1)
    --negate
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.cicon)
	e2:SetTarget(s.citg)
	e2:SetOperation(s.ciop)
	c:RegisterEffect(e2)
end
function s.htgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.cfi2ter(c)
	return c:IsFaceup() and c:IsSetCard(0x409)
end
function s.htgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x08)>0
        and Duel.IsExistingMatchingCard(s.cfi2ter,tp,0x08,0,1,nil) end
end
function s.thfi1ter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x409) and c:IsType(TYPE_MONSTER)
        and c:IsLevelAbove(5)
end
function s.htgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,0x08)>0 and c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
        local g=Duel.GetMatchingGroup(s.thfi1ter,tp,0x01,0,nil)
        if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local sg=g:Select(tp,1,1,nil)
            if Duel.SendtoHand(sg,tp,REASON_EFFECT)>0 then
                Duel.ConfirmCards(1-tp,sg)
            end
        end
	end
end
function s.fi1ter(c)
	return c:IsAbleToDeck()
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
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end
end