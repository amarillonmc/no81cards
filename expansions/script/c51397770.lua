local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,id)
    --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.tfilter(c)
	return true
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then
        local g1=Duel.GetMatchingGroup(s.setfi1ter,tp,0x01,0,nil)
        local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0x04,0x04,nil)
        local b1=#g1>0
        local b2=#g2>0 and Duel.GetLocationCount(tp,0x08)>0
        return (b1 or b2) and Duel.IsExistingTarget(aux.TRUE,tp,0x0c,0x0c,1,nil)
    end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.tfilter,tp,0x0c,0x0c,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,LOCATION_HAND)
end
function s.setfi1ter(c)
    return c:IsCode(51397780) and c:IsSSetable()
end
function s.eqfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
    local tc=Duel.GetFirstTarget()
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT,aux.ExceptThisCard(e))>0 then
        local g1=Duel.GetMatchingGroup(s.setfi1ter,tp,0x01,0,nil)
        local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0x04,0x04,nil)
        local op=2
        local b1=tc:IsCanChangePosition() and #g1>0 and not (tc:IsLocation(LOCATION_SZONE) and tc:GetOriginalType()&TYPE_MONSTER>0)
        local b2=e:GetHandler():IsRelateToEffect(e) and #g2>0 and Duel.GetLocationCount(tp,0x08)>0
        if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
        elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(id,1))
        elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
        else return end
        if op==0 then
            if Duel.ChangePosition(tc,POS_FACEDOWN)>0 and #g1>0 then
                Duel.Hint(3,tp,510)
                local sg=g1:Select(tp,1,1,nil)
                Duel.BreakEffect()
                Duel.SSet(tp,sg)
            end
        elseif op==1 then
            Duel.Hint(3,tp,518)
            local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
            local tc=g:GetFirst()
            if tc then
            	Duel.Equip(tp,c,tc)
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_EQUIP_LIMIT)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                e1:SetValue(s.eqlimit)
                e1:SetLabelObject(tc)
                c:RegisterEffect(e1)
            end
        end
    end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end