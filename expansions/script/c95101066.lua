--黑之裁判长 巴风特
--卡号：95101066
--类型：超量效果怪兽（TYPE_XYZ + TYPE_EFFECT + TYPE_MONSTER = 8388641）
--属性：暗（ATTRIBUTE_DARK = 32）
--种族：恶魔族（RACE_FIEND = 8）
--ATK/DEF：4000/4000
--阶级：8
--召唤条件：暗属性8星怪兽×2
--效果概述：
--  这个卡名的①②的效果1回合各能使用1次。
--  ①：这张卡超量召唤的场合才能发动。从自己卡组上面把5张卡翻开。可以从那之中选1张魔法·陷阱卡加入手卡。剩下的卡送去墓地。
--  ②：把这张卡1个超量素材取除才能发动。从自己的墓地把1只「黑之裁判」怪兽当作永续陷阱卡使用在自己的魔法与陷阱区域表侧表示放置。

function c95101066.initial_effect(c)
    -- 超量召唤：暗属性8星怪兽×2
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),8,2)
    c:EnableReviveLimit()
    
    -- 效果①：超量召唤的场合，从卡组上面翻5张，选1张魔陷加入手卡，其余送墓
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(95101066,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,95101066)
    e1:SetCondition(c95101066.con1)
    e1:SetTarget(c95101066.tg1)
    e1:SetOperation(c95101066.op1)
    c:RegisterEffect(e1)
    
    -- 效果②：取除1个素材，从墓地把1只「黑之裁判」怪兽当作永续陷阱放置
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(95101066,1))
    e2:SetCategory(CATEGORY_GRAVE_ACTION)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,95101066+1)
    e2:SetCost(c95101066.cost2)
    e2:SetTarget(c95101066.tg2)
    e2:SetOperation(c95101066.op2)
    c:RegisterEffect(e2)
end

function c95101066.con1(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function c95101066.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,4,tp,LOCATION_DECK)
end

function c95101066.op1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
    local g=Duel.GetDecktopGroup(tp,5)
    Duel.ConfirmCards(tp,g)
    -- 选1张魔陷加入手卡
    local sg=g:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
    if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95101066,2)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local tc=sg:Select(tp,1,1,nil):GetFirst()
        if tc then
            g:RemoveCard(tc)
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        end
    end
    -- 剩下的卡送去墓地
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end

function c95101066.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c95101066.gravefilter(c)
    return c:IsSetCard(0xbbb) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE)
end

function c95101066.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c95101066.gravefilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end

function c95101066.op2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c95101066.gravefilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        -- 当作永续陷阱卡使用在魔陷区域表侧表示放置
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(tc)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
    end
end
