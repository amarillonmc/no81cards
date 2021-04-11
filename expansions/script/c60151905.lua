--魔铳 急速之魔枪
local m=60151905
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,60151905+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c60151905.e1con)
    e1:SetOperation(c60151905.e1op)
    c:RegisterEffect(e1)
	--special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c60151905.e2tg)
    e2:SetOperation(c60151905.e2op)
    c:RegisterEffect(e2)
end
function c60151905.e1con(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return Duel.GetTurnPlayer()==tp and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and not Duel.CheckPhaseActivity()
end
function c60151905.e1op(e,tp,eg,ep,ev,re,r,rp)
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetDescription(aux.Stringid(60151905,0))
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_ATTACK_ALL)
    e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e3:SetTargetRange(LOCATION_ONFIELD,0)
    e3:SetTarget(aux.TargetBoolFunction(c60151905.filter2))
    e3:SetValue(1)
    e3:SetReset(RESET_PHASE+PHASE_END)
    e3:SetCondition(c60151905.con)
    Duel.RegisterEffect(e3,tp)
    local e4=Effect.CreateEffect(e:GetHandler())
    e4:SetDescription(aux.Stringid(60151905,1))
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_PIERCE)
    e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e4:SetTargetRange(LOCATION_ONFIELD,0)
    e4:SetTarget(aux.TargetBoolFunction(c60151905.filter2))
    e4:SetReset(RESET_PHASE+PHASE_END)
    e4:SetCondition(c60151905.con)
    Duel.RegisterEffect(e4,tp)
end
function c60151905.filter2(c)
    return c:IsFaceup() and c:IsCode(60151902)
end
function c60151905.filter(c)
    return c:IsFaceup() and c:IsSetCard(0xab26)
end
function c60151905.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c60151905.filter,tp,LOCATION_PZONE,0,1,nil)
end
function c60151905.e2tgfilter(c)
    return c:IsSetCard(0xab26) and c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and not c:IsForbidden()
end
function c60151905.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151905.e2tgfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil)
        and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c60151905.e2op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c60151905.e2tgfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end