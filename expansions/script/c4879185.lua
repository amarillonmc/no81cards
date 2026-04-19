--尘时隙间
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,2))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,id+o)
    e2:SetCondition(s.sscon)
    e2:SetTarget(s.sstg)
    e2:SetOperation(s.ssop)
    c:RegisterEffect(e2)
end
function s.cfilter(c,tp)
    return c:IsSetCard(0xae5d) and c:IsLevelAbove(5) and c:GetSummonPlayer()==tp
end
function s.sscon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.cfilter,1,c,tp)
end
function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() and not e:GetHandler():IsStatus(STATUS_CHAINING) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.ssop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end
function s.filter1(c)
    return  c:GetFlagEffect(4879171)~=0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,0x3f,0x3f,1,nil) end
end
function s.nfilter1(c)
    return c:IsFaceup() and c:IsCode(4879171)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
    local g=Duel.SelectMatchingCard(tp,s.filter1,tp,0x3f,0x3f,1,1,nil)
    if #g==0 then return end
    local tc=g:GetFirst()
    local turne=tc[tc]
    local op=turne:GetOperation()
    op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
    local ct=Duel.GetCurrentChain()
    if ct<2 then return end
    local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
    if tep==1-tp  and Duel.IsExistingMatchingCard(s.nfilter1,tp,LOCATION_ONFIELD,0,1,nil)  then
        Duel.NegateEffect(ct-1)
    end
end