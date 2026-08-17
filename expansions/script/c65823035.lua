-- 天上天下 唯我独尊！
local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,65823000,65823020,65823015)
    if not s.global_check then
        s.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_LEAVE_FIELD)
        ge1:SetOperation(s.leaveop)
        Duel.RegisterEffect(ge1,0)
    end
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.leavefilter(c,tp)
    return c:IsCode(65823000) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end
function s.leaveop(e,tp,eg,ep,ev,re,r,rp)
    for p=0,1 do
        if eg:IsExists(s.leavefilter,1,nil,p) then
            Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1)
        end
    end
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,id)>0
end

-- 反转术式-修复过滤器
function s.repairfilter(c)
    return c:IsCode(65823020) and c:IsAbleToHand()
end

-- 虚式-茈过滤器
function s.murasakifilter(c)
    return c:IsCode(65823015) and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local b1=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.repairfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
        local b2=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.murasakifilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
        return b1 and b2
    end
		Duel.Hint(24,0,aux.Stringid(id,0))
		Duel.Hint(24,0,aux.Stringid(id,1))
		Duel.Hint(24,0,aux.Stringid(id,2))
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.repairfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.murasakifilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g1>0 and #g2>0 then
				Duel.Hint(24,0,aux.Stringid(id,3))
        g1:Merge(g2)
        Duel.SendtoHand(g1,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g1)
    end
end