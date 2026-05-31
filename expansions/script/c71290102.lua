-- 三月七-六相冰-
Duel.LoadScript("c71290100.lua")
local cm,m,o=GetID()
cm.isPlaneswalker=true
function cm.initial_effect(c)
  -- 添加黑塔-空间站的卡名记述
  aux.AddCodeList(c,71290105)
  
  -- ①：自己场上没有怪兽存在的场合，这张卡可以从手卡特殊召唤
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(cm.spcon1)
  c:RegisterEffect(e1)
  
  -- ②和③的效果，使用库的简化函数，一行代替两个效果
  Heita.endeff(c)
end

-- ①的特招条件：自己场上没有怪兽
function cm.spcon1(e,c)
  if c==nil then return true end
  local tp=c:GetControler()
  return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and Duel.GetMatchingGroupCount(Card.IsOnField,tp,LOCATION_MZONE,0,nil)==0
end
