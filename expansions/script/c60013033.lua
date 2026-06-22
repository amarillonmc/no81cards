-- 新月的摇篮曲
local cm,m,o=GetID()
function cm.initial_effect(c)
  -- 添加月下的少女 哥伦比娅的卡名记述，方便其他卡识别
  aux.AddCodeList(c,60013027)
  
  -- 这个卡名的卡1回合只能发动1张
  -- ①：丢弃1张手卡，以场上1张卡为对象才能发动。那张卡破坏。自己场上有「月下的少女 哥伦比娅」存在的场合，发动后这张卡不送去墓地，直接盖放。
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,m)
  e1:SetCost(cm.descost)
  e1:SetTarget(cm.destg)
  e1:SetOperation(cm.desop)
  c:RegisterEffect(e1)
  
  -- ②：这张卡送去墓地的场合发动。自己墓地「月下的少女 哥伦比娅」以外有那个卡名记述的卡全部回到卡组，回复那个回到卡组数量×100基本分。
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

-- ①的cost：丢弃1张手卡
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
  Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
-- ①的target：选场上1张卡
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsOnField() end
  if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
-- 筛选自己场上的表侧的哥伦比娅
function cm.colfilter(c)
  return c:IsCode(60013027) and c:IsFaceup()
end
-- ①的operation：破坏对象，然后如果有表侧的哥伦比娅就盖放这张卡
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc and tc:IsRelateToEffect(e) then
    Duel.Destroy(tc,REASON_EFFECT)
  end
  -- 检查自己场上有没有表侧表示的「月下的少女 哥伦比娅」
  if Duel.IsExistingMatchingCard(cm.colfilter,tp,LOCATION_MZONE,0,1,nil) then
    if c:IsRelateToEffect(e) and c:IsCanTurnSet() and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
      Duel.BreakEffect()
      c:CancelToGrave()
      Duel.ChangePosition(c,POS_FACEDOWN)
      Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
    end
  end
end

-- ②的filter：筛选自己墓地的，除了哥伦比娅本身之外的，有哥伦比娅卡名记述的卡
function cm.tgfilter(c)
  return aux.IsCodeListed(c,60013027) and c:IsAbleToDeck() and not c:IsCode(60013027)
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
