--黑之裁判<追猎者>琳达梅尔
--卡号：95101187
--类型：超量怪兽（TYPE_XYZ + TYPE_MONSTER）
--属性：暗（ATTRIBUTE_DARK）
--种族：不死族（RACE_ZOMBIE）
--ATK/DEF：3450/0
--阶级：8
--效果概述：
--  8星暗属性怪兽×2
--  这个卡名的①②的效果1回合各能使用1次。
--  ①：把这张卡1个超量素材取除才能发动。从卡组把1张「黑之裁判」卡加入手卡。场上的罪孽指示物有5个以上的场合，可以再选从卡组加入手卡的1张卡盖放。
--  ②：自己场上的「黑之裁判」卡不会被对方的效果破坏，对方不能把自己场上的「黑之裁判」卡作为效果的对象。

function c95101187.initial_effect(c)
    -- 超量召唤条件：8星暗属性怪兽×2
    c:EnableReviveLimit()
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),8,2)
    
    -- 效果①：取除1个超量素材，从卡组把1张「黑之裁判」卡加入手卡，罪孽指示物≥5时可以再盖放1张
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(95101187,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SSET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,95101187)
    e1:SetCost(c95101187.cost1)
    e1:SetTarget(c95101187.tg1)
    e1:SetOperation(c95101187.op1)
    c:RegisterEffect(e1)
    
    -- 效果②：自己场上的「黑之裁判」卡不会被对方的效果破坏
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_ONFIELD,0)
    e2:SetTarget(c95101187.target2)
    e2:SetValue(aux.indoval)
    c:RegisterEffect(e2)
    
    -- 效果②：对方不能把自己场上的「黑之裁判」卡作为效果的对象
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_ONFIELD,0)
    e3:SetTarget(c95101187.target2)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
end

function c95101187.target2(e,c)
    return c:IsSetCard(0xbbb)
end

function c95101187.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c95101187.thfilter(c)
    return c:IsSetCard(0xbbb) and c:IsAbleToHand()
end

function c95101187.get_counter_count(tp)
    local ct=0
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
    for tc in aux.Next(g) do
        ct=ct+tc:GetCounter(0xbbb)
    end
    return ct
end

function c95101187.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c95101187.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c95101187.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c95101187.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
            Duel.ConfirmCards(1-tp,tc)
            -- 场上的罪孽指示物有5个以上的场合，可以再选从卡组加入手卡的1张卡盖放
            if c95101187.get_counter_count(tp)>=5 and tc:IsSSetable() then
                if Duel.SelectYesNo(tp,aux.Stringid(95101187,2)) then
                    Duel.SSet(tp,tc)
                end
            end
        end
    end
end
