-- 暴食的安纳提玛·拉拉安瑟姆
Duel.LoadScript("c60001511.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
  aux.AddCodeList(c,60012048)
  -- 注册进化指示物的许可
  c:EnableCounterPermit(0x624)
  
  
  -- 手卡特殊召唤：自己魔陷区有卡的时候，可以从手卡特殊召唤
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_FIELD)
  e0:SetCode(EFFECT_SPSUMMON_PROC)
  e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e0:SetRange(LOCATION_HAND)
  e0:SetCondition(cm.spcon0)
  c:RegisterEffect(e0)
  
  -- ①：魔陷区的卡被效果破坏的时候，抽1加进化指示物，1回合最多3次
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetCategory(CATEGORY_DRAW+CATEGORY_COUNTER)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_DESTROYED)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCountLimit(3)
  e1:SetCondition(cm.spcon1)
  e1:SetTarget(cm.sptg1)
  e1:SetOperation(cm.spop1)
  c:RegisterEffect(e1)
  
  -- ②的子效果：有进化指示物的时候，攻防上升指示物*400
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetCondition(cm.incon)
  e2:SetValue(cm.atkval)
  c:RegisterEffect(e2)
  local e3=e2:Clone()
  e3:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e3)
  -- ②的子效果：3个以上指示物的时候，双方回合1次，从卡组加安纳提玛卡到手
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(m,2))
  e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e4:SetType(EFFECT_TYPE_QUICK_O)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCode(EVENT_FREE_CHAIN)
  e4:SetCountLimit(1)
  e4:SetCondition(cm.incon3)
  e4:SetTarget(cm.sptg3)
  e4:SetOperation(cm.spop3)
  c:RegisterEffect(e4)
  
  -- ③：离开怪兽区的时候，代替去墓地，变成永续魔法
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCode(EFFECT_SEND_REPLACE)
  e4:SetTarget(cm.reptg)
  e4:SetValue(cm.repval)
  c:RegisterEffect(e4)
end

-- 手卡特殊召唤的条件：自己魔陷区有卡
function cm.spcon0(e,c)
  local tp=e:GetHandlerPlayer()
  return Duel.GetMatchingGroupCount(Card.IsOnField,tp,LOCATION_SZONE,0,nil)>0
end

-- ①的过滤：自己魔陷区的卡被效果破坏
function cm.cfilter1(c,tp)
  return c:IsPreviousLocation(LOCATION_SZONE) and c:IsControler(tp) and bit.band(c:GetReason(),REASON_EFFECT)~=0
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(cm.cfilter1,1,nil,tp)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,1)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.Draw(tp,1,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsCanHaveCounter(0x624) then
    c:AddCounter(0x624,1)
    Duel.RegisterFlagEffect(tp,60002148,0,0,1)
  end
end

-- ②的条件：有进化指示物
function cm.incon(e)
  local c=e:GetHandler()
  return c:IsFaceup() and c:GetCounter(0x624)>=1
end
-- ②的数值：指示物数量*400
function cm.atkval(e,c)
  return c:GetCounter(0x624)*400
end

-- ③的代替去墓地的过滤
function cm.repfilter(c,tp,card)
  local ge=c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT)
  return not ge and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:GetDestination()&LOCATION_GRAVE>0 and c==card
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp,c) end
  if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
    c:CancelToGrave()
    -- 变成永续魔法
    local e1=Effect.CreateEffect(c)
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    c:RegisterEffect(e1)
    
    -- 魔陷状态的效果：自己·对方回合可以发动，破坏2张大地之魔片，特殊召唤自己
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
    e2:SetLabel(2)
    e2:SetCost(byd.EarthRite)
    e2:SetTarget(cm.sptg2)
    e2:SetOperation(cm.spop2)
    e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
    c:RegisterEffect(e2)
  end
  return true
end
function cm.repval(e,c)
  return true
end

-- 大地之魔片的过滤
function cm.dfilter(c)
  return c:IsCode(60012048) and c:IsAbleToGrave()
end
-- 魔陷效果的cost：破坏2张大地之魔片
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) then
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
  end
end

-- ②的3个以上的条件
function cm.incon3(e)
  local c=e:GetHandler()
  return c:IsFaceup() and c:GetCounter(0x624)>=3
end
-- 安纳提玛卡的过滤：筛选issetcode为0x6624的卡
function cm.afilter(c)
  return c:IsAbleToHand() and c:IsCode(0x6624) and not c:IsCode(m)
end
function cm.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(cm.afilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.spop3(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.SelectMatchingCard(tp,cm.afilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end
