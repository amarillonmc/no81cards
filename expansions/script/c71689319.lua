--"总感觉~也没什么奇怪的~♡"
local s,id,o=GetID()
function s.initial_effect(c)
    c:SetSPSummonOnce(id)
    c:EnableReviveLimit()
    aux.AddFusionProcFunFun(c,s.ffilter1,s.ffilter2,1,true)
    aux.AddContactFusionProcedure(c,Card.IsReleasableByEffect,LOCATION_ONFIELD+LOCATION_HAND,0,Duel.Release,REASON_COST)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetValue(s.splimit)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,id)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e3:SetTarget(s.indtg)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
end
function s.splimit(e,se,sp,st)
    return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function s.ffilter1(c,fc,sub,mg,sg)
    return c:GetOwner()~=fc:GetOwner()
end
function s.ffilter2(c,fc,sub,mg,sg)
    return c:GetOriginalType()&TYPE_MONSTER~=0 and c:GetOriginalRace()&RACE_ILLUSION~=0
end
function s.filter(c)
	return c:IsSetCard(0x593) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToChain() or c:IsFacedown() then return end
    local g=c:GetMaterial()
    local sa=0
    local tc=g:GetFirst()
    while tc do
        local a=tc:GetBaseAttack()
        sa=sa+a
        tc=g:GetNext()
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetValue(sa)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_DISABLE)
    c:RegisterEffect(e1)
    local d=math.floor(c:GetAttack()/1000)
    if d>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,d,nil)then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,d,d,nil)
	if sg:GetCount()<=0 then return end
	local sc=sg:GetFirst()
    while sc do
    Duel.Hint(HINT_CARD,tp,sc:GetOriginalCode())
	if sc:IsAbleToHand() and (not sc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(sc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sc)
	else
		Duel.SendtoGrave(sc,REASON_EFFECT)
	end
    sc=sg:GetNext()
    end
    end
end
function s.indtg(e,c)
    local tc=e:GetHandler()
    return c==tc or c==tc:GetBattleTarget()
end