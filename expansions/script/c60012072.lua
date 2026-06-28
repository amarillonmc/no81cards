-- 龙人前锋
local cm,m,o=GetID()
function cm.initial_effect(c)
  c:EnableCounterPermit(0x624)
  
  -- ②：这张卡上是已有进化指示物的场合，这张卡获得下述效果
  -- 守备力上升1600
  local ee1=Effect.CreateEffect(c)
  ee1:SetType(EFFECT_TYPE_SINGLE)
  ee1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  ee1:SetRange(LOCATION_MZONE)
  ee1:SetCode(EFFECT_UPDATE_DEFENSE)
  ee1:SetCondition(cm.incon)
  ee1:SetValue(1600)
  c:RegisterEffect(ee1)
  
  -- 可以用表侧守备表示的状态作出攻击，用守备力当作攻击力使用进行伤害计算
  local ee2=Effect.CreateEffect(c)
  ee2:SetType(EFFECT_TYPE_SINGLE)
  ee2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  ee2:SetRange(LOCATION_MZONE)
  ee2:SetCode(EFFECT_DEFENSE_ATTACK)
  ee2:SetCondition(cm.incon)
  ee2:SetValue(1) -- value=1代表使用守备力作为攻击伤害计算
  c:RegisterEffect(ee2)
  
  -- ①：这张卡召唤成功的场合才能发动。这张卡的守备力是1500以上的场合，给这张卡放置1个进化指示物，自己抽1张。
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetOperation(cm.op1)
  c:RegisterEffect(e1)
end

-- 进化指示物的condition
function cm.incon(e)
  return Card.GetCounter(e:GetHandler(),0x624)>=1
end

-- ①的operation
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and c:IsFaceup() and c:GetDefense()>=1500 then
    -- 放置进化指示物，按照规则添加固定的flag
    c:AddCounter(0x624,1)
    Duel.RegisterFlagEffect(tp,60002148,0,0,1)
    -- 自己抽1张
    Duel.Draw(tp,1,REASON_EFFECT)
  end
end
