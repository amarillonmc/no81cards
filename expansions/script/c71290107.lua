-- 瓦尔特-黑洞-
Duel.LoadScript("c71290100.lua")
local cm,m,o=GetID()
cm.isPlaneswalker=true
function cm.initial_effect(c)
  -- 添加黑塔-空间站的卡名记述
  aux.AddCodeList(c,71290105)
  
  -- ①：场地区域有星穹列车的场合，手卡特招，然后翻卡组顶3张选1加手
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
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
    and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
-- ①的operation
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  -- 先特殊召唤这张卡
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
  -- 然后翻开卡组最上面3张卡
  local g=Duel.GetDecktopGroup(tp,3)
  if g:GetCount()==0 then return end
  Duel.ConfirmCards(1-tp,g)
  -- 选1张加入手卡
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local sg=g:Select(tp,1,1,nil)
  if sg:GetCount()>0 then
    Duel.SendtoHand(sg,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,sg)
    -- 剩下的卡放回卡组
    g:Sub(sg)
    if g:GetCount()>0 then
      Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    end
  end
end
