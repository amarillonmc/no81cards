--罗星 飞鱼座
local s,id,o=GetID()
function s.initial_effect(c)
    --SetSZone
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(0x06)  
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.htgtg)
	e1:SetOperation(s.htgop) 
	c:RegisterEffect(e1)
    --negate
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.cicon)
	e2:SetTarget(s.citg)
	e2:SetOperation(s.ciop)
	c:RegisterEffect(e2)
end
function s.htgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x08)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,0x30)
end
function s.thfi1ter(c)
	return c:IsFaceup() and c:IsSetCard(0x409)
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
        local g=Duel.GetMatchingGroup(s.thfi1ter,tp,0x0c,0,c)
        if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            Duel.Hint(3,tp,505)
            local sg=g:Select(tp,1,1,nil)
            Duel.HintSelection(sg)
            Duel.SendtoHand(sg,nil,0x40)
        end
	end
end
function s.fi1ter(c,tp)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToRemove(tp,POS_FACEDOWN) and c:IsLocation(0x1c)
end
function s.fi2ter(c,e,tp)
	return c:IsRelateToEffect(e) and s.fi1ter(c,tp)
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
	local tg=g:Filter(s.fi1ter,e:GetHandler(),tp)
	local tc=tg:GetFirst()
    while tc do
	    tc:CreateEffectRelation(e)
        tc=tg:GetNext()
    end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,tg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.ciop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local c=e:GetHandler() 
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(s.fi2ter,c,e,tp)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and #tg>0 then 
		Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
	end 
end