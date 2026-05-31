-- 炎之法则·威尔纳斯
local cm,m,o=GetID()
function cm.initial_effect(c)
  -- 添加炎之法则系列的卡名记述
  --aux.AddCodeList(c,60012044)
  -- 注册进化指示物的许可
  c:EnableCounterPermit(0x624)
  -- 连接怪兽的复活限制
  c:EnableReviveLimit()
  
  -- 连接素材：可以放置进化指示物的怪兽2只以上，最多5只
  aux.AddLinkProcedure(c,cm.matfilter,2,5)
  
  -- ①：特殊召唤成功的时候，给自己加进化指示物
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetCategory(CATEGORY_COUNTER)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetOperation(cm.spop)
  c:RegisterEffect(e1)
  
  -- ②的子效果：有进化指示物的时候，攻击力上升400
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetCondition(cm.atkcon)
  e2:SetValue(800)
  c:RegisterEffect(e2)
  
  -- ②的子效果：有进化指示物的时候，得到无效效果，1回合1次
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(m,1))
  e3:SetCategory(CATEGORY_NEGATE)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetCode(EVENT_CHAINING)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCondition(cm.discon)
  e3:SetCost(cm.discost)
  e3:SetTarget(cm.distg)
  e3:SetOperation(cm.disop)
  c:RegisterEffect(e3)
end

-- 素材过滤：可以放置进化指示物的怪兽
function cm.matfilter(c,lc,sumtype,tp)
  return c:IsCanHaveCounter(0x624)
end

-- ①的操作：加进化指示物
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and c:IsCanHaveCounter(0x624) then
    c:AddCounter(0x624,1)
    Duel.RegisterFlagEffect(tp,60002148,0,0,1)
  end
end

-- 攻击力上升的条件：有进化指示物
function cm.atkcon(e)
  local c=e:GetHandler()
  return c:IsFaceup() and c:GetCounter(0x624)>=1
end

-- 无效效果的条件：对方发动效果，且自己有进化指示物
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return rp==1-tp and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
    and c:IsFaceup() and c:GetCounter(0x624)>=1
end

-- 无效效果的cost：取除1个进化指示物
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x624,1,REASON_COST) end
  e:GetHandler():RemoveCounter(tp,0x624,1,REASON_COST)
end

-- 无效效果的目标
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

-- 无效效果的操作
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
  Duel.NegateActivation(ev)
end
