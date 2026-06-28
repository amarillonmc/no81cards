-- 伟大的调停者·佐伊
Duel.LoadScript("c60001511.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
  c:EnableCounterPermit(0x624)
  
  -- ③：这张卡上是已有进化指示物的场合，这张卡获得下述效果。这张卡的攻击力·守备力上升800。
  local ee1=Effect.CreateEffect(c)
  ee1:SetType(EFFECT_TYPE_SINGLE)
  ee1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  ee1:SetRange(LOCATION_MZONE)
  ee1:SetCode(EFFECT_UPDATE_ATTACK)
  ee1:SetCondition(cm.incon)
  ee1:SetValue(800)
  c:RegisterEffect(ee1)
  local ee2=ee1:Clone()
  ee2:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(ee2)
  
  -- ①：把手卡的这张卡给对方观看才能发动。自己抽1张，这张卡回到自己卡组的最上面。这次决斗中，自己把「伟大的调停者·佐伊」召唤时，需要的解放变为不需要。
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,m)
  e1:SetCost(cm.cost)
  e1:SetOperation(cm.op1)
  c:RegisterEffect(e1)
  
  -- ②：这张卡召唤成功的场合才能发动。自己的基本分变为1。直到下个回合的结束阶段，自己基本分变为0的场合，把自己的基本分变为1。
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(m,1))
  e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetCode(EVENT_SUMMON_SUCCESS)
  e2:SetOperation(cm.op2)
  c:RegisterEffect(e2)
end

-- 进化指示物的condition
function cm.incon(e)
  return Card.GetCounter(e:GetHandler(),0x624)>=1
end

-- ①的cost：把手卡的这张卡给对方观看
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToDeckAsCost() end
  Duel.ConfirmCards(1-tp,c)
end

-- ①的operation
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  -- 自己抽1张
  Duel.Draw(tp,1,REASON_EFFECT)
  -- 这张卡回到自己卡组的最上面
  if c:IsRelateToEffect(e) then
    Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
  end
  -- 这次决斗中，自己把这张卡召唤时，需要的解放变为不需要
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SUMMON_PROC)
  e1:SetTargetRange(LOCATION_HAND,0)
  e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,m))
  e1:SetValue(SUMMON_TYPE_NORMAL)
  e1:SetReset(0) -- 永久生效，这次决斗都有效
  Duel.RegisterEffect(e1,tp)
end

-- ②的operation
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  -- 自己的基本分变为1
  Duel.SetLP(tp,1)
  -- 加召唤计数
  byd.AddSummonCount(e,tp)
  -- 直到下个回合的结束阶段，自己基本分变为0的场合，把自己的基本分变为1
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_ADJUST)
  e1:SetReset(RESET_PHASE+PHASE_END,2) -- 持续到下个回合结束
  e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLP(tp)<=0 then
      Duel.SetLP(tp,1)
    end
  end)
  Duel.RegisterEffect(e1,tp)
end
