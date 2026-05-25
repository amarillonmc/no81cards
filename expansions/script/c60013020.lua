-- 速射弹
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,60013012)
    -- ①：发动时的效果
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.acttg)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end
-- 检索维若妮卡的过滤：找卡组里的维若妮卡，能加入手卡的
function s.thfilter(c)
    return c:GetCode()==60013012 and c:IsAbleToHand()
end
-- 检查自己灵摆区有没有投射机卡（id在60013014~60013019之间）
function s.has_pz_proj(tp)
    local pz_cards=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
    for tc in aux.Next(pz_cards) do
        local cid=tc:GetCode()
        if cid>=60013014 and cid<=60013019 then
            return true
        end
    end
    return false
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    -- 设置检索的操作信息
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    -- 如果有投射机在灵摆区，额外添加抽卡的操作信息
    if s.has_pz_proj(tp) then
        Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    -- 检索维若妮卡
    Duel.Hint(HINT_SELECTMSG,tp,HINT_SEARCH)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
    -- 如果有投射机在灵摆区，抽1张卡
    if s.has_pz_proj(tp) then
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end