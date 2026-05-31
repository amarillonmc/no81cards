-- 大黑塔-举世无双-
Duel.LoadScript("c71290100.lua")
local cm,m,o=GetID()
cm.isPlaneswalker=true
function cm.initial_effect(c)
  -- 添加黑塔-空间站的卡名记述
  aux.AddCodeList(c,71290100)
  
  -- ①：召唤/特招成功，破坏对方1张，无其他怪兽的话再除外1张
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetCountLimit(1,m)
  e1:SetTarget(cm.destg)
  e1:SetOperation(cm.desop)
  c:RegisterEffect(e1)
  local e1_2=e1:Clone()
  e1_2:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e1_2)
  
  -- ②和③的效果，使用库的简化函数，一行代替两个效果
  Heita.endeff(c)
  
end

-- ①的target
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
  local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
  -- 如果自己场上没有其他怪兽，额外添加除外的操作信息
  local c=e:GetHandler()
  if Duel.GetMatchingGroupCount(Card.IsOnField,tp,LOCATION_MZONE,0,c)==0 then
    local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
    if sg:GetCount()>0 then
      Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,1,0,0)
    end
  end
end
-- ①的operation
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
  -- 先破坏对方1张卡
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
  if g:GetCount()>0 then
    Duel.Destroy(g,REASON_EFFECT)
  end
  -- 检查自己场上有没有其他怪兽
  local c=e:GetHandler()
  if Duel.GetMatchingGroupCount(Card.IsOnField,tp,LOCATION_MZONE,0,c)>0 then return end
  -- 没有的话，再选对方1张卡除外
  local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
  if sg:GetCount()>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local rg=sg:Select(tp,1,1,nil)
    if rg:GetCount()>0 then
      Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
    end
  end
end

