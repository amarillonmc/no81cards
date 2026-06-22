-- 柜上的淑女
local cm,m,o=GetID()
function cm.initial_effect(c)
  -- 添加绝代的智械 桑多涅的卡名记述，方便其他卡识别
  aux.AddCodeList(c,60013025)
  
  -- 这个卡名的卡1回合只能发动1张
  -- ①：对方墓地·除外的卡全部回到卡组。自己场上有「绝代的智械 桑多涅」存在的场合，发动后这张卡不送去墓地，直接盖放。
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetCategory(CATEGORY_TODECK)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetRange(LOCATION_SZONE)
  e1:SetCountLimit(1,m)
  e1:SetTarget(cm.destg)
  e1:SetOperation(cm.desop)
  c:RegisterEffect(e1)
  
  -- ②：这张卡送去墓地的场合发动。自己墓地「绝代的智械 桑多涅」以外有那个卡名记述的卡全部回到卡组，回复那个回到卡组数量×100基本分。
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(m,1))
  e2:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetCode(EVENT_TO_GRAVE)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetTarget(cm.tg)
  e2:SetOperation(cm.op)
  c:RegisterEffect(e2)
end

-- 筛选自己场上的表侧的桑多涅
function cm.sandfilter(c)
  return c:IsCode(60013025) and c:IsFaceup()
end
-- ①的target：选对方墓地和除外的所有卡
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
  local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
-- ①的operation：把对方的卡回卡组，然后如果有表侧的桑多涅就盖放这张卡
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil)
  if g:GetCount()>0 then
    Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
  end
  -- 检查自己场上有没有表侧表示的「绝代的智械 桑多涅」
  if Duel.IsExistingMatchingCard(cm.sandfilter,tp,LOCATION_MZONE,0,1,nil) then
    if c:IsRelateToEffect(e) and c:IsCanTurnSet() and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
      Duel.BreakEffect()
      c:CancelToGrave()
      Duel.ChangePosition(c,POS_FACEDOWN)
      Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
    end
  end
end

-- ②的filter：筛选自己墓地的，除了桑多涅本身之外的，有桑多涅卡名记述的卡
function cm.tgfilter(c)
  return aux.IsCodeListed(c,60013025) and c:IsAbleToDeck() and c:GetOriginalCode()~=60013025
end
-- ②的target
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
  local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_GRAVE,0,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetCount()*100)
end
-- ②的operation：把卡回卡组，然后回复
function cm.op(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_GRAVE,0,nil)
  if g:GetCount()>0 then
    local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    if ct>0 then
      Duel.Recover(tp,ct*100,REASON_EFFECT)
    end
  end
end
