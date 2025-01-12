-- 废铁鬣蜥
function c49811456.initial_effect(c)
    -- Effect: Reveal, destroy self, then destroy target cards
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(49811456,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,49811456)
    e1:SetCondition(c49811456.rlcon1)
    e1:SetCost(c49811456.cost)
    e1:SetTarget(c49811456.target)
    e1:SetOperation(c49811456.operation)
    c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c49811456.rlcon2)
	c:RegisterEffect(e2)

    -- Effect 2: Place "Scrap" Continuous Spell/Trap
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(49811456,1))
    e3:SetCategory(CATEGORY_TOFIELD)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCountLimit(1,49811457)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCondition(c49811456.tfcon)
    e3:SetTarget(c49811456.tftg)
    e3:SetOperation(c49811456.tfop)
    c:RegisterEffect(e3)
end

-- Condition: If a "Scrap" card exists on the field, can activate during opponent's turn

function c49811456.rlcon1(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c49811456.filter,tp,LOCATION_ONFIELD,0,1,nil)
end

function c49811456.rlcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c49811456.filter,tp,LOCATION_ONFIELD,0,1,nil)
end

-- Filter: Check for face-up "Scrap" cards
function c49811456.filter(c)
    return c:IsSetCard(0x24) and c:IsFaceup()
end

-- Cost: Reveal this card to the opponent
function c49811456.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsPublic() end
    Duel.ConfirmCards(1-tp,e:GetHandler())
end

-- Target: Confirm availability of itself for destruction
function c49811456.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return e:GetHandler():IsDestructable(e)
    end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end

-- Filter: "Scrap" monsters excluding "Scrap Lizard"
function c49811456.scrapfilter(c,e)
    return c:IsSetCard(0x24) and not c:IsCode(49811456) and c:IsDestructable(e) and c:IsType(TYPE_MONSTER)
end

-- Operation: Destroy self, then optionally destroy target cards
function c49811456.operation(e,tp,eg,ep,ev,re,r,rp)
    -- Destroy the card itself (self-destruction)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_HAND) then       
        -- Ask player if they want to proceed with additional destruction
        if Duel.Destroy(c,REASON_EFFECT)>0 and Duel.SelectYesNo(tp,aux.Stringid(49811456,2)) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,e) and Duel.IsExistingMatchingCard(c49811456.scrapfilter,tp,LOCATION_DECK,0,1,nil,e) then
            Duel.BreakEffect()
            -- Select 1 card from hand or field
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local g1=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,e)
            if #g1>0 then
                -- Select 1 "Scrap" monster from Deck
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
                local g2=Duel.SelectMatchingCard(tp,c49811456.scrapfilter,tp,LOCATION_DECK,0,1,1,nil,e)
                if #g2>0 then
                    g1:Merge(g2)
                    Duel.Destroy(g1,REASON_EFFECT)
                end
            end
        end
    end 
end

-- Effect 2: Place "Scrap" Continuous Spell/Trap
function c49811456.tfcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT) and re and re:GetHandler():IsSetCard(0x24)
end
function c49811456.pfilter(c)
    return c:IsSetCard(0x24) and c:IsType(TYPE_CONTINUOUS) and c:IsSSetable() and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c49811456.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c49811456.pfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c49811456.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c49811456.pfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
