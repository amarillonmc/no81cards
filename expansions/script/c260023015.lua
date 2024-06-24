--地獄から連れし者 ヘルテイカー
function c260023015.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,nil,2,4,c260023015.lcheck)
    c:EnableReviveLimit()
    
    --indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_ONFIELD,0)
    e1:SetTarget(c260023015.indtg)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e2)
    
    --todeck
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_BATTLE_START)
    e3:SetCountLimit(1,260023015)
    e3:SetCondition(c260023015.tdcon)
    e3:SetTarget(c260023015.tdtg)
    e3:SetOperation(c260023015.tdop)
    c:RegisterEffect(e3)
    
    --search
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_REMOVE)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,260024015)
    e4:SetTarget(c260023015.thtg)
    e4:SetOperation(c260023015.thop)
    c:RegisterEffect(e4)
    
end
    

--【召喚条件】
function c260023015.lcheck(g)
    return g:IsExists(Card.IsLinkSetCard,1,nil,0x2045)
end


--【破壊無効】
function c260023015.indtg(e,c)
    return c:IsRace(RACE_FIEND)
end


--【バウンス】
function c260023015.tdcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c260023015.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    if chk==0 then return bc and bc:IsRelateToBattle() and bc:IsAbleToDeck() end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,bc,1,0,0)
end
function c260023015.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    if not bc:IsRelateToBattle() then return false end
    Duel.SendtoDeck(bc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end


--【サーチ】
function c260023015.thfilter(c)
    return c:IsRace(RACE_FIEND) and c:IsAbleToHand()
end
function c260023015.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c260023015.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c260023015.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c260023015.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
