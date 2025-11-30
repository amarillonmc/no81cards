--颶風海劫“隱世”維達號
local s,id,o=GetID()
function s.initial_effect(c)
    --SpSum(0x01)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(0x06)
    e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
    e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    --TdOrSum(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.toscon)
	e2:SetTarget(s.tostg)
	e2:SetOperation(s.tosop)
    c:RegisterEffect(e2)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x540b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and not c:IsAttribute(ATTRIBUTE_DARK)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        local c=e:GetHandler()
        return Duel.IsExistingMatchingCard(s.spfilter,tp,0x01,0,1,nil,e,tp)
            and Duel.GetLocationCount(tp,0x04)>0
            or (c:IsLocation(0x04) and Duel.GetMZoneCount(tp,c)>0)
    end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x04)>0 then
        Duel.Hint(3,tp,509)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,0x01,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
            local fg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0x04,0,nil)
            if #fg>0 then
                Duel.Hint(3,tp,506)
                local sg=fg:Select(tp,1,1,nil)
                Duel.HintSelection(sg)
                Duel.SendtoHand(sg,nil,0x40)
            end
		end
    end
end
function s.thfi2ter(c,tp)
	return c:IsPreviousLocation(0x04) and c:IsPreviousControler(tp)
end
function s.toscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.thfi2ter,1,nil,tp)
end
function s.tostg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() or c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    if c:IsAbleToDeck() then
        Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
    end
    if c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
	    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    end
end
function s.spfi2ter(c,e,tp)
    return c:IsSetCard(0x540b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tosop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
        local b1=c:IsAbleToDeck()
        local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        local op=0
        if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
        elseif b1 then op=0
        elseif b2 then op=1
        else return end
        if op==0 then
            local g=Duel.GetMatchingGroup(s.spfi2ter,tp,0x02,0,nil,e,tp)
            if Duel.SendtoDeck(c,nil,1,0x40)>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
                Duel.Hint(3,tp,509)
                local tc=g:Select(tp,1,1,nil)
                if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
            end
        else Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
    end
end