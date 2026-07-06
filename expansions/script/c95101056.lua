--察觉到了"黑"的气息
--卡号：95101056
--类型：通常魔法（TYPE_SPELL = 2）
--效果概述：
--  ①：从卡组把1张「黑之裁判」卡送去墓地。那之后，自己场地区域有「黑之裁判」存在的场合，可以再给那张卡放置3个罪孽指示物。

function c95101056.initial_effect(c)
    -- 效果①：从卡组把1张「黑之裁判」卡送去墓地，然后给场地放置3个罪孽指示物
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c95101056.tg)
    e1:SetOperation(c95101056.op)
    c:RegisterEffect(e1)
end

function c95101056.tgfilter(c)
    return c:IsSetCard(0xbbb) and c:IsAbleToGrave()
end

function c95101056.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c95101056.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

function c95101056.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c95101056.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        if Duel.SendtoGrave(tc,REASON_EFFECT)>0 then
            -- 那之后，自己场地区域有「黑之裁判」存在的场合，给那张卡放置3个罪孽指示物
            local fc=Duel.GetFieldGroup(tp,LOCATION_FZONE,0):GetFirst()
            if fc and fc:IsSetCard(0xbbb) and fc:IsFaceup() then
                if Duel.SelectYesNo(tp,aux.Stringid(95101056,0)) then
                    fc:AddCounter(0xbbb,3)
                end
            end
        end
    end
end
