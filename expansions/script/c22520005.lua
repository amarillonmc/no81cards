--辺獄の賢聖　サバル
local m=22520005
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(cm.ntcon)
    e1:SetOperation(cm.ntop)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCountLimit(1,m)
    e3:SetTarget(cm.thtg)
    e3:SetOperation(cm.thop)
    c:RegisterEffect(e3)
end
function cm.ntcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function cm.ntop(e,tp,eg,ep,ev,re,r,rp,c)
    --to grave
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetTarget(cm.tgtg)
    e1:SetOperation(cm.tgop)
    e1:SetReset(RESET_EVENT+0xc6e0000)
    c:RegisterEffect(e1)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        Duel.SendtoGrave(c,REASON_EFFECT)
    end
end
function cm.filter(c)
    return c:IsSetCard(0xec1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

