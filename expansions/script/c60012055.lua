-- 操量的安纳提玛·达斯特迪兹
Duel.LoadScript("c60001511.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
  -- 注册安纳提玛的指示物许可
  c:EnableCounterPermit(0x624)
  
  -- ①：手卡丢弃，触发效果，连击数量减1
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetCategory(CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetCost(cm.spcost1)
  e1:SetTarget(cm.sptg1)
  e1:SetOperation(cm.spop1)
  c:RegisterEffect(e1)
  
  -- ②：仪式召唤成功，除外对方的卡，连击4的话加效果
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(m,1))
  e2:SetCategory(CATEGORY_REMOVE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(cm.spcon2)
  e2:SetTarget(cm.sptg2)
  e2:SetOperation(cm.spop2)
  c:RegisterEffect(e2)
  
  -- ③的子效果：1个以上指示物，攻防上升
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetCondition(cm.incon1)
  e3:SetValue(cm.atkval)
  c:RegisterEffect(e3)
  local e4=e3:Clone()
  e4:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e4)
  
  -- ③的子效果：3个以上指示物，不能作为效果对象
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE)
  e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
  e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e5:SetRange(LOCATION_MZONE)
  e5:SetCondition(cm.incon3)
  e5:SetValue(aux.tgoval)
  c:RegisterEffect(e5)
end

-- ①的cost：丢弃这张卡，再丢弃1张手卡
function cm.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsDiscardable() and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
  Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
  Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
  if Duel.Draw(tp,1,REASON_EFFECT)>0 then
    -- 这个回合，连击的所需数量减1
    Duel.RegisterFlagEffect(tp,60040052,RESET_PHASE+PHASE_END,0,1)
  end
end

-- ②的条件：仪式召唤成功
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
  local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
-- ②的operation：除外对方的卡，连击4的话加效果
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
  if g:GetCount()>0 then
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
  end
  -- 判断连击4的条件
  if byd.link(c,4) then
    -- 这个回合，对方不能发动墓地的卡的效果
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(0,1)
    e1:SetValue(cm.aclimit)
    Duel.RegisterEffect(e1,tp)
  end
end
-- 不能发动墓地效果的限制
function cm.aclimit(e,re,tp)
  return re:GetHandler():IsLocation(LOCATION_GRAVE)
end

-- ③的条件：1个以上安纳提玛指示物
function cm.incon1(e)
  local c=e:GetHandler()
  return c:IsFaceup() and c:GetCounter(0x6624)>=1
end
-- ③的数值：指示物数量*400
function cm.atkval(e,c)
  return c:GetCounter(0x6624)*400
end
-- ③的条件：3个以上安纳提玛指示物
function cm.incon3(e)
  local c=e:GetHandler()
  return c:IsFaceup() and c:GetCounter(0x6624)>=3
end
