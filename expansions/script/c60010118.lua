--飞彩凝辉
local cm,m,o=GetID()
function cm.initial_effect(c)
    aux.AddCodeList(c,60010111)
    --act in hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    e2:SetCondition(cm.con)
    c:RegisterEffect(e2)
    --activated
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,2))
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCondition(cm.con1)
    --e1:SetCost(cm.cos1)
    e1:SetTarget(cm.tg1)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,3))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCost(cm.thcost)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
end
function cm.confil(c)
    return c:IsCode(60010111) and c:IsFaceup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.confil,tp,LOCATION_MZONE,0,1,nil)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end

function cm.rmfil(c)
    return c:IsFaceup() and c:IsType(TYPE_QUICKPLAY) and c:IsType(TYPE_SPELL) 
    and c:CheckActivateEffect(false,false,false)~=nil
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,60010111)>=4
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x628,1,REASON_COST) end
    Duel.RemoveCounter(tp,1,0,0x628,1,REASON_COST)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfil,tp,LOCATION_REMOVED,0,1,nil) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.RegisterFlagEffect(tp,60010111,0,0,1)
    if not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_REMOVED,0,12,nil) then
        local num=12-Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)
        local rg=Duel.GetDecktopGroup(tp,num)
        Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
    end
    local gc=Duel.GetMatchingGroup(cm.rmfil,tp,LOCATION_REMOVED,0,nil):Select(tp,1,1,nil):GetFirst()
    local te=gc:GetActivateEffect()
    Duel.MoveToField(gc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    local cos,tg,op=te:GetCost(),te:GetTarget(),te:GetOperation()
    if te and (not cos or cos(te,tp,eg,ep,ev,re,r,rp,0)) and (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0)) then
        e:SetProperty(te:GetProperty())
        local code=gc:GetOriginalCode()
        Duel.Hint(HINT_CARD,tp,code)
        Duel.Hint(HINT_CARD,1-tp,code)
        te:UseCountLimit(tp,1,true)
        gc:CreateEffectRelation(te)
        if cos then cos(te,tp,eg,ep,ev,re,r,rp,1) end
        if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
        local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
        if g and #g~=0 then
            local tg=g:GetFirst()
            while tg do
                tg:CreateEffectRelation(te)
                tg=g:GetNext()
            end
        end
        if op then op(te,tp,eg,ep,ev,re,r,rp) end
        gc:ReleaseEffectRelation(te)
        if g then
            tg=g:GetFirst()
            while tg do
                tg:ReleaseEffectRelation(te)
                tg=g:GetNext()
            end
        end
    end
    Duel.SendtoDeck(gc,nil,2,REASON_RULE)
    Duel.RaiseEvent(c,EVENT_CUSTOM+60010111,e,0,tp,tp,0)
end

function cm.thfilter(c)
    return c:IsCode(60010111) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
            Duel.ConfirmCards(1-tp,g)
            if g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false) 
            and Duel.IsCanRemoveCounter(tp,1,0,0x628,1,REASON_EFFECT) then
                Duel.RemoveCounter(tp,1,0,0x628,1,REASON_EFFECT)
                Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
            end
        end
    end
end