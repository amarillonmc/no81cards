-- 你才是挑战者！
local s,id,o=GetID()
local HISTORY_GOJO = 65823000 -- 现代最强-五条悟
local KYOSHIKI_MURASAKI = 65823015 -- 虚式-茈

function s.initial_effect(c)
    aux.AddCodeList(c,65823000,65823015)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.filter(c,code)
    return c:IsCode(code) and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local b1=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,HISTORY_GOJO)
        local b2=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,KYOSHIKI_MURASAKI)
        return b1 and b2
    end
    Duel.Hint(24,0,aux.Stringid(id,0))
	Duel.Hint(24,0,aux.Stringid(id,1))
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    -- 选择「史上最强-五条悟」
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,HISTORY_GOJO)
    -- 选择「虚式-茈」
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,KYOSHIKI_MURASAKI)
    
    if #g1>0 and #g2>0 then
        g1:Merge(g2)
        Duel.SendtoHand(g1,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g1)
    end
end