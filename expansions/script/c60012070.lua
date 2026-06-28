-- 无尽焰龙
local cm,m,o=GetID()
function cm.initial_effect(c)
  c:EnableReviveLimit()
  c:EnableCounterPermit(0x624)
  
  -- 同调召唤条件：调整+调整以外的怪兽1只
  aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
  
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
  
  -- ①：这张卡特殊召唤成功的场合发动。双方场上其他攻击力2000以上的怪兽全部破坏。
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetOperation(cm.op1)
  c:RegisterEffect(e1)
  
  -- ②：这张卡攻击宣言时，给与对方4000伤害。
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(m,1))
  e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
  e2:SetCode(EVENT_ATTACK_ANNOUNCE)
  e2:SetOperation(cm.op2)
  c:RegisterEffect(e2)
end

-- 进化指示物的condition
function cm.incon(e)
  return Card.GetCounter(e:GetHandler(),0x624)>=1
end

-- ①的operation
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  -- 筛选双方场上，除了这张卡之外，攻击力2000以上的怪兽
  local g=Duel.GetMatchingGroup(function(c)
    return c:IsAttackAbove(2000) and c~=e:GetHandler()
  end,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
  if g:GetCount()>0 then
    Duel.Destroy(g,REASON_EFFECT)
  end
end

-- ②的operation
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
  Duel.Damage(1-tp,4000,REASON_EFFECT)
end

