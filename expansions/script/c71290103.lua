-- 阿兰-防卫科负责人-
Duel.LoadScript("c71290100.lua")
local cm,m,o=GetID()
cm.isPlaneswalker=true
function cm.initial_effect(c)
  -- 添加黑塔-空间站的卡名记述
  aux.AddCodeList(c,71290100)
  
  -- ①：召唤/特招成功，从手卡特招4星以下的黑塔怪兽
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetCountLimit(1,m)
  e1:SetTarget(cm.sptg1)
  e1:SetOperation(cm.spop1)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  c:RegisterEffect(e2)
  
  -- ②和③的效果，使用库的简化函数，一行代替两个效果
  Heita.endeff(c)
end

-- ①的过滤：4星以下的黑塔怪兽，可特殊召唤
function cm.spfilter(c,e,tp)
  return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
