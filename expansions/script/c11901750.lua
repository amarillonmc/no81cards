--炎魔的火钵 布雷盖特
local s,id,o=GetID()
function s.initial_effect(c)
    --SpSummon To SZone
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,id)
	e1:SetCost(s.htgcost)
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
function s.htgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.defi1ter(c,e)
	return c:IsSetCard(0x408) and c:IsDestructable(e) and c:GetOriginalType()&TYPE_MONSTER>0 
end
function s.htgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        local g=Duel.GetMatchingGroup(s.defi1ter,tp,0x0c,0,c,e)
        return #g>0
    end
end
function s.htgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.defi1ter,tp,0x0c,0,c,e)
    if c:IsRelateToEffect(e) and #g>0 then
        Duel.Hint(3,tp,502)
        local sg=g:Select(tp,1,1,nil)
        sg:AddCard(c)
        Duel.Destroy(sg,0x40)
	end
end
function s.spfilter(c,e,tp,tid)
	return c:IsSetCard(0x408) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
        and c:IsReason(REASON_DESTROY) and c:GetTurnID()==tid
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,0x04)>=1 
		and Duel.IsExistingMatchingCard(s.spfilter,tp,0x30,0,1,nil,e,tp,Duel.GetTurnCount()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x30)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,0x04)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,0x30,0,1,1,nil,e,tp,Duel.GetTurnCount())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end