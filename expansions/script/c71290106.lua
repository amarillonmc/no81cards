-- 姬子-群星的引航者-
Duel.LoadScript("c71290100.lua")
local cm,m,o=GetID()
cm.isPlaneswalker=true
function cm.initial_effect(c)
  -- 添加黑塔-空间站的卡名记述
  aux.AddCodeList(c,71290105)
  
  -- ①：场地区域有星穹列车的场合，手卡特招，然后墓地回卡组
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,m)
  e1:SetCondition(cm.spcon1)
  e1:SetTarget(cm.sptg1)
  e1:SetOperation(cm.spop1)
  c:RegisterEffect(e1)
  
  -- ②和③的效果，使用库的简化函数，一行代替两个效果
  Heita.endeff(c)
end

-- ①的条件：自己场地区域有星穹列车-开拓之星-
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_FZONE,0,1,nil,71290105)
end
-- ①的target
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
  local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,math.min(g:GetCount(),5),0,0)
end
-- ①的operation
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  -- 先特殊召唤这张卡
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
  -- 然后选墓地的卡回卡组，至多5张
  local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,nil)
  if g:GetCount()==0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local sg=g:Select(tp,1,5,nil)
  if sg:GetCount()>0 then
    local ct=Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    -- 回了5张的话，抽1张
    if ct==5 then
      Duel.Draw(tp,1,REASON_EFFECT)
    end
  end
end
