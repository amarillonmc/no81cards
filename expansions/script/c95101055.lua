--黑之裁判
--卡号：95101055
--类型：场地魔法（TYPE_FIELD + TYPE_SPELL = 524290）
--效果概述：
--  这张卡不能发动。
--  这个卡名的③的效果1回合只能使用1次。
--  ①：每次有怪兽被送去对方墓地，给这张卡放置那个数量的罪孽指示物。
--  ②：这张卡不受对方的卡的效果影响，自己不能把场地魔法卡发动或盖放。
--  ③：把手卡的这张卡给对方观看才能发动。从卡组把1只「黑之裁判」怪兽送去墓地，这张卡回到持有者卡组。

function c95101055.initial_effect(c)
    -- 允许在场地放置罪孽指示物
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e0:SetRange(LOCATION_FZONE)
    e0:SetCode(EFFECT_COUNTER_PERMIT+0xbbb)
    c:RegisterEffect(e0)
    
    -- 这张卡不能发动（不注册EFFECT_TYPE_ACTIVATE）
    
    -- ①：每次有怪兽被送去对方墓地，给这张卡放置那个数量的罪孽指示物
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetRange(LOCATION_FZONE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetOperation(c95101055.ctop)
    c:RegisterEffect(e1)
    
    -- ②：不受对方的卡的效果影响
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetValue(c95101055.immval)
    c:RegisterEffect(e2)
    
    -- ②：自己不能把场地魔法卡发动
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,0)
    e3:SetValue(c95101055.actlimit)
    c:RegisterEffect(e3)
    
    -- ②：自己不能把场地魔法卡盖放
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_SSET)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(1,0)
    e4:SetTarget(c95101055.setlimit)
    c:RegisterEffect(e4)
    
    -- ③：把手卡的这张卡给对方观看才能发动
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(95101055,0))
    e5:SetCategory(CATEGORY_TOGRAVE)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_HAND)
    e5:SetCountLimit(1,95101055)
    e5:SetCost(c95101055.cost3)
    e5:SetTarget(c95101055.tg3)
    e5:SetOperation(c95101055.op3)
    c:RegisterEffect(e5)
end

function c95101055.immval(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function c95101055.actlimit(e,re,tp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_FIELD)
end

function c95101055.setlimit(e,c,tp)
    return c:IsType(TYPE_FIELD)
end

function c95101055.ctop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsFaceup() or not c:IsLocation(LOCATION_FZONE) then return end
    local ct=eg:FilterCount(function(c) return c:IsType(TYPE_MONSTER) and c:IsControler(1-tp) end,nil)
    if ct>0 then
        c:AddCounter(0xbbb,ct)
    end
end

function c95101055.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsPublic() end
    Duel.ConfirmCards(1-tp,c)
end

function c95101055.tgfilter(c)
    return c:IsSetCard(0xbbb) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end

function c95101055.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c95101055.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

function c95101055.op3(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c95101055.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    end
end
