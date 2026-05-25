-- 丽金花的挥霍
local cm,m,o=GetID()
function cm.initial_effect(c)
  -- 添加丽金花系列的卡名记述
  aux.AddCodeList(c,60012036)
  
  -- 激活效果
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetCategory(CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCost(cm.cost)
  e1:SetTarget(cm.target)
  e1:SetOperation(cm.activate)
  c:RegisterEffect(e1)
end

-- cost：丢弃手卡，初始5，每发动过闪耀的金币减1，最少1
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  -- 统计发动过闪耀的金币的次数
  local ct=Duel.GetFlagEffect(tp,60012038)
  local dc=5-ct
  if dc<1 then dc=1 end
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,dc,c) end
  local g=Duel.DiscardHand(tp,Card.IsDiscardable,dc,dc,REASON_COST+REASON_DISCARD)
  return #g==dc
end

-- 目标
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,5) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(5)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5)
end

-- 操作
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
end
