--以新生的烈阳 撕裂长空
local s,id,o=GetID()
function s.initial_effect(c)
    -- ①效果：从卡组/墓地检索并失去LP
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
    
    -- ②效果：从额外/墓地叠放素材
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_LEAVE_GRAVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id+o)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.mattg)
    e2:SetOperation(s.matop)
    c:RegisterEffect(e2)
end

-- ①效果过滤函数
function s.thfilter(c)
    return c:IsSetCard(0x893) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

-- ①效果目标函数
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end

-- ①效果操作函数
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        local tc=g:GetFirst()
        if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
            Duel.ConfirmCards(1-tp,tc)
            Duel.Damage(tp,tc:GetBaseAttack(),REASON_EFFECT)
        end
    end
end

-- ②效果超量怪兽过滤
function s.xyzfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_XYZ)
end

-- ②效果素材过滤
function s.matfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end

-- ②效果目标函数
function s.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.xyzfilter(chkc) end
    if chk==0 then 
        return Duel.IsExistingTarget(s.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
            and Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local tg=Duel.SelectTarget(tp,s.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end

-- ②效果操作函数
function s.matop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) then return end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.matfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.Overlay(tc,g)
    end
end