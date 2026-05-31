-- 阮·梅-天才俱乐部#81-
Duel.LoadScript("c71290100.lua")
local cm,m,o=GetID()
cm.isPlaneswalker=true
function cm.initial_effect(c)
  -- 添加黑塔-空间站的卡名记述
  aux.AddCodeList(c,71290100)
  
  -- ①：手卡送墓，这个回合通常召唤最多5次，不能特殊召唤
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,m)
  e1:SetCost(cm.cost1)
  e1:SetOperation(cm.op1)
  c:RegisterEffect(e1)
  
  -- ②和③的效果，使用库的简化函数，一行代替两个效果
  Heita.endeff(c)
  
end

-- ①的cost：把这张卡从手卡送墓
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToGraveAsCost() end
  Duel.SendtoGrave(c,REASON_COST)
end
-- ①的operation：设置这个回合的召唤限制
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  -- 这个回合，自己的通常召唤最多5次
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(5)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
  -- 这个回合，自己不能特殊召唤怪兽
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e2:SetTargetRange(1,0)
  e2:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e2,tp)
end
