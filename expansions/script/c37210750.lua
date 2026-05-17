--究极体 翔鹏兽
local s,id,o=GetID()
function s.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,6,2)
    c:EnableReviveLimit()
	--overlay
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
    e2:SetCondition(aux.TRUE)
    e2:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
    c:RegisterEffect(e2)
end
--

--
function s.thfilter(c,tp)
    return c:IsCanOverlay(tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,e:GetHandler())
    end

end
function s.thsubgroup(sg)
    return sg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD):GetCount()<2
end
function s.thop(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_MZONE+LOCATION_GRAVE,0,e:GetHandler())
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
        local sg=g:SelectSubGroup(tp,s.thsubgroup,false,1,3)
        local draw=sg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD)
        Duel.Overlay(e:GetHandler(),sg)
        if draw then
            Duel.Draw(tp,1,REASON_EFFECT)
        end
        Duel.BreakEffect()
        local g2=Duel.GetMatchingGroup(Card.IsLevelBelow,tp,LOCATION_MZONE,LOCATION_MZONE,nil,5)
        Duel.SendtoHand(g2,nil,REASON_EFFECT)
    end
end
--
