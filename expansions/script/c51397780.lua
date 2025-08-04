local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,51397770)
    local e1=Effect.CreateEffect(c)
   	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.spfi1ter(c,e,tp) 
	return aux.IsCodeListed(c,51397770) and c:IsType(TYPE_FUSION)
        and c:IsCanBeSpecialSummoned(e,nil,tp,true,false)
        and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0  
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        local g=Duel.GetMatchingGroup(Card.IsCode,tp,0x3e,0,nil,51397770)
        return #g>0 and Duel.IsExistingMatchingCard(s.spfi1ter,tp,0x40,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x40)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0x3e,0,nil,51397770):Filter(Card.IsFaceupEx,nil)
	if #g>0 then
		Duel.Hint(3,tp,526)
	    local tc=g:Select(tp,1,1,nil):GetFirst()
        Duel.ConfirmCards(1-tp,tc)
        local g2=Duel.GetMatchingGroup(s.spfi1ter,tp,0x40,0,nil,e,tp)
        if #g2>0 then
            Duel.Hint(3,tp,509)
            local sc=g2:Select(tp,1,1,nil):GetFirst()
            if Duel.SpecialSummon(sc,nil,tp,tp,true,false,POS_FACEUP)>0 then
                Duel.BreakEffect()
                Duel.Equip(tp,tc,sc)
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_EQUIP_LIMIT)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                e1:SetValue(s.eqlimit)
                e1:SetLabelObject(sc)
                tc:RegisterEffect(e1)
            end
        end
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end