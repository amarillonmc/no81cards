-- 忧虑缩小
Duel.LoadScript("c60001511.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
  -- 添加安纳提玛系列的卡名记述
  
  -- ①：发动的效果，回复1000，连击4的话破坏对方怪兽区的卡
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetCategory(CATEGORY_RECOVER)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(cm.sptg1)
  e1:SetOperation(cm.spop1)
  c:RegisterEffect(e1)
  
  -- ②：结束阶段，除外自己，盖放恶意扩大
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(m,1))
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_PHASE+PHASE_END)
  e2:SetRange(LOCATION_GRAVE)
  e2:SetCountLimit(1,m)
  e2:SetCost(cm.spcost2)
  e2:SetTarget(cm.sptg2)
  e2:SetOperation(cm.spop2)
  c:RegisterEffect(e2)
end

-- ①的target
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
  -- 如果连击4的话，添加破坏的操作信息
  if byd.link(e:GetHandler(),4) then
    local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
  end
end
-- ①的operation
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
  -- 先回复1000基本分
  Duel.Recover(tp,1000,REASON_EFFECT)
  -- 判断连击4的条件
  local c=e:GetHandler()
  if byd.link(c,4) then
    -- 破坏对方怪兽区域的所有卡
    local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
      Duel.Destroy(g,REASON_EFFECT)
    end
  end
end

-- ②的cost：除外这张卡
function cm.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToRemoveAsCost() end
  Duel.Remove(c,POS_FACEUP,REASON_COST)
end
-- ②的过滤：恶意扩大，可盖放
function cm.setfilter(c)
  return c:IsCode(60012058) and c:IsSSetable()
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
-- ②的operation：盖放恶意扩大
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SSet(tp,g:GetFirst())
  end
end
