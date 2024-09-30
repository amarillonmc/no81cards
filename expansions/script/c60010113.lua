--携月
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
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCost(cm.cos1)
    e1:SetTarget(cm.tg1)
    e1:SetOperation(cm.op1)
    c:RegisterEffect(e1)
end
function cm.confil(c)
    return c:IsCode(60010111) and c:IsFaceup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.confil,tp,LOCATION_MZONE,0,1,nil)
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x628,1,REASON_COST) end
    Duel.RemoveCounter(tp,1,0,0x628,1,REASON_COST)
end
function cm.adfil(c)
    return aux.IsCodeListed(c,60010111) and not c:IsCode(m)
end
function cm.rmfil2(c)
    return c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToRemove()
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.adfil,tp,LOCATION_DECK,0,1,nil) 
    and Duel.IsExistingMatchingCard(cm.rmfil,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.rmfil(c)
    return c:IsFaceup() and c:IsType(TYPE_QUICKPLAY) and c:IsType(TYPE_SPELL) 
    and c:CheckActivateEffect(false,false,false)~=nil
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.RegisterFlagEffect(tp,60010111,0,0,1)
    local ag=Duel.GetMatchingGroup(cm.adfil,tp,LOCATION_DECK,0,nil)
    local num=math.min(3,#ag)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local rg=Duel.GetMatchingGroup(cm.rmfil2,tp,LOCATION_HAND,0,nil):Select(tp,1,num,nil)
    if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 then
        local adnum=#Duel.GetOperatedGroup()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local a2g=ag:Select(tp,1,adnum,nil)
        if a2g:GetCount()>0 then
            Duel.SendtoHand(a2g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,a2g)
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
        end
    end
    Duel.RaiseEvent(c,EVENT_CUSTOM+60010111,e,0,tp,tp,0)
end