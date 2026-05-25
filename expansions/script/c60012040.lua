-- 荣耀的丽金花
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

-- cost：丢弃1张闪耀的金币
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,60012038) end
  Duel.DiscardHand(tp,Card.IsCode,1,1,REASON_COST+REASON_DISCARD,nil,60012038)
end

-- 目标
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
  local draw=2
  if Duel.IsExistingMatchingCard(aux.IsCodeListed,tp,LOCATION_MZONE,0,1,nil,60012036) then
    draw=3
  end
  if chk==0 then return Duel.IsPlayerCanDraw(tp,draw) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(draw)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,draw)
end

-- 操作
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Draw(p,d,REASON_EFFECT)
    Duel.ResetFlagEffect(p,m+10000000)
    Duel.ResetFlagEffect(p,m+20000000)
    Duel.ResetFlagEffect(p,m+30000000)
  
end
