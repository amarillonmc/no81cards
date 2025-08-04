local s,id,o=GetID()
function s.initial_effect(c)
    --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa14),2,2)
	c:EnableReviveLimit()
    --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    --GetEffect
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.cost)
    e3:SetOperation(s.geop)
	c:RegisterEffect(e3)
end
function s.spfilter(c,e,sp)
	return c:IsSetCard(0xa14) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,0x32,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x32)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,0x40)>0 then
        local mz=Duel.GetMZoneCount(tp)
        if mz>0 then
	        Duel.Hint(3,tp,509)
	        local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,0x32,0,1,mz,nil,e,tp)
	        if g:GetCount()>0 then
		        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
            end
        end
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
	    e1:SetDescription(aux.Stringid(id,2))
	    e1:SetCategory(CATEGORY_DISABLE)
	    e1:SetType(EFFECT_TYPE_QUICK_O)
	    e1:SetCode(EVENT_CHAINING)
	    e1:SetRange(LOCATION_MZONE)
	    e1:SetTarget(s.distg)
	    e1:SetOperation(s.disop)
	    c:RegisterEffect(e1)
    end
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0x04,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0x04,0,nil)
    if g:GetCount()>=2 then
        Duel.Hint(3,tp,504)
        local sg=g:Select(tp,2,2,nil)
        if Duel.SendtoGrave(sg,0x40)>0 and sg:Filter(Card.IsLocation,nil,0x10)>0 then
	        Duel.NegateEffect(ev)
        end
    end
end