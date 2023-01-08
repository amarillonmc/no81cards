--原生种·阿露菲米
local m=89390004
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,m)
    e2:SetTarget(cm.target)
    e2:SetOperation(cm.operation)
    c:RegisterEffect(e2)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_REMOVE)
    e1:SetTarget(cm.srettg)
    e1:SetOperation(cm.sretop)
    c:RegisterEffect(e1)
    if not cm.global_check then
        cm.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_CHAINING)
        ge1:SetOperation(cm.check)
        Duel.RegisterEffect(ge1,0)
        local ge2=Effect.CreateEffect(c)
        ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge2:SetCode(EVENT_CHAIN_SOLVED)
        ge2:SetCondition(cm.clearcon)
        ge2:SetOperation(cm.clear)
        Duel.RegisterEffect(ge2,0)
        local ge3=ge2:Clone()
        ge3:SetCode(EVENT_CHAIN_NEGATED)
        Duel.RegisterEffect(ge3,0)
        local ge4=ge1:Clone()
        ge4:SetCode(EVENT_CHAIN_NEGATED)
        ge4:SetCondition(cm.rscon)
        ge4:SetOperation(cm.reset)
        --when the trigger=true, if the activation of the last effect "c4" was negated, this card effect's applying or not will depend on "c3". when the trigger=false, it will depend on "c4".
        local trigger=true
        if trigger then Duel.RegisterEffect(ge4,0) end
    end
end
function cm.check(e,tp,eg,ep,ev,re,r,rp)
    cm[ev]={re,rp}
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentChain()>1
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
    cm[ev]={re,2}
end
function cm.clearcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentChain()==1
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
    local i=1
    while cm[i] do
        cm[i]=nil
        i=i+1
    end
end
function cm.filter(c)
    return c:IsRace(RACE_PSYCHO) and not c:IsCode(m) and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local res=true
    local i=1
    while type(cm[i])=="table" do
        local re,rp=table.unpack(cm[i])
        if rp==tp then res=true end
        if rp==1-tp then res=false end
        i=i+1
    end
    if not res then return end
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if not g or g:GetCount()<=0 then return end
    local tc=g:GetFirst()
    if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)<1 then return end
    if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(tc:GetBaseAttack())
    e1:SetReset(RESET_EVENT+0x1fe0000)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetValue(tc:GetBaseDefense())
    c:RegisterEffect(e2)
    c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000)
end

function cm.srettg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToDeck() end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,PLAYER_ALL,LOCATION_DECK)
end
function cm.sretop(e,tp,eg,ep,ev,re,r,rp)
    local res=true
    local i=1
    while type(cm[i])=="table" do
        local re,rp=table.unpack(cm[i])
        if rp==tp then res=true end
        if rp==1-tp then res=false end
        i=i+1
    end
    if not res then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>0 then
        Duel.BreakEffect()
        local g1=Duel.GetDecktopGroup(tp,2)
        local g2=Duel.GetDecktopGroup(1-tp,2)
        g1:Merge(g2)
        Duel.DisableShuffleCheck()
        if Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)>0 then
            local ct=Duel.GetCurrentChain()
            if type(cm[ct+1])=="table" then
                local re,rp=table.unpack(cm[ct+1])
                if rp==tp then
                    Duel.BreakEffect()
                    Duel.Draw(tp,1,REASON_EFFECT)
                end
            end
        end
    end
end
