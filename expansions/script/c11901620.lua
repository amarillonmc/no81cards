--炎魔的走牛 阿耆尼
local s,id,o=GetID()
function s.initial_effect(c)
    --Equip
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.htgtg) 
	e1:SetOperation(s.htgop) 
	c:RegisterEffect(e1)
    --Desed
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
    e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.eqfi1ter(c)
	return c:IsSetCard(0x408) and c:IsFaceup()
end
function s.htgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        local g=Duel.GetMatchingGroup(s.eqfi1ter,tp,0x04,0,nil)
        return #g>0 and Duel.GetLocationCount(tp,0x08)>0
    end
end
function s.htgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.eqfi1ter,tp,0x04,0,nil)
    if c:IsRelateToEffect(e) and #g>0 and Duel.GetLocationCount(tp,0x08)>0 then
        Duel.Hint(3,tp,518)
        local sg=g:Select(tp,1,1,nil)
        Duel.HintSelection(sg)
        local tc=sg:GetFirst()
        if Duel.Equip(tp,c,tc) then
            local e1=Effect.CreateEffect(c)
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetCode(EFFECT_EQUIP_LIMIT)
		    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetLabelObject(tc)
		    e1:SetValue(s.eqlimit)
		    c:RegisterEffect(e1)
        end
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x408) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end