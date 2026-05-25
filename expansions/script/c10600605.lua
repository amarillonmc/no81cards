--困难重重仍要勇往直前
local s,id=GetID()
local AVAIL_FLAG = id+100         -- 可使用次数标记
local USED_FLAG = id+200          -- 已使用次数标记
local REMAINDER_FLAG = id+300     -- 送墓余数

function s.initial_effect(c)
  c:EnableReviveLimit()
  aux.AddFusionProcFunRep(c,s.ffilter,2,true)
  aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST)

  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCondition(s.con2)
  e2:SetOperation(s.op2)
  c:RegisterEffect(e2)

  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_REMOVE)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(TIMING_MAIN_END)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(1, EFFECT_COUNT_CODE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCondition(s.con1)
  e1:SetTarget(s.target1)
  e1:SetOperation(s.operation1)
  c:RegisterEffect(e1)

  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e3:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(s.resetcon)
  e3:SetOperation(s.resetop)
  c:RegisterEffect(e3)
end
function s.ffilter(c,fc,sub,mg,sg)
	return (not sg or sg:FilterCount(aux.TRUE,c)==0 or (sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()) and sg:IsExists(Card.IsRace,1,c,c:GetRace())))
end

function s.con2(e,tp,eg,ep,ev,re,r,rp)
		local ph=Duel.GetCurrentPhase()
    return Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end

function s.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=eg:FilterCount(Card.IsControler,nil,tp)
    if ct==0 then return end
    local rem=c:GetFlagEffect(REMAINDER_FLAG)
    local total=rem+ct
    local new_avail=math.floor(total/2)
    local new_rem=total%2
    c:ResetFlagEffect(REMAINDER_FLAG)
    for i=1,new_rem do
        c:RegisterFlagEffect(REMAINDER_FLAG,0,0,1)
    end
    for i=1,new_avail do
        c:RegisterFlagEffect(AVAIL_FLAG,0,0,1)
    end
end

function s.con1(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    if not (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) then return false end
    local c=e:GetHandler()
    return c:GetFlagEffect(AVAIL_FLAG) > c:GetFlagEffect(USED_FLAG)
end

function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    local used=c:GetFlagEffect(USED_FLAG)
    local x=math.max(1, used)
    if chk==0 then
        return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,x,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end

function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not g or #g==0 then return end
    local rg=g:Filter(Card.IsRelateToEffect,nil,e)
    if #rg>0 then
        Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
    end
    c:RegisterFlagEffect(USED_FLAG,0,0,1)
end

function s.resetcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY
end

function s.resetop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    c:ResetFlagEffect(AVAIL_FLAG)
    c:ResetFlagEffect(USED_FLAG)
    c:ResetFlagEffect(REMAINDER_FLAG)
end