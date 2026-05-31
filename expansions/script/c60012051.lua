-- 万食的安纳提玛·拉拉安瑟姆
Duel.LoadScript("c60012048.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
  -- 注册进化指示物的许可
  c:EnableCounterPermit(0x624)
  -- 添加大地之魔片的卡名记述
  aux.AddCodeList(c,60012048)
  aux.AddCodeList(c,m+1)
  
  -- ①：丢弃这张卡，从卡组加大地之魔片的卡到手
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetCost(cm.spcost1)
  e1:SetTarget(cm.sptg1)
  e1:SetOperation(cm.spop1)
  c:RegisterEffect(e1)
  
  -- ②：仪式召唤成功，发动土之秘术1，特殊召唤怪兽
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(m,1))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(cm.spcon2)
  e2:SetCost(byd.EarthRite)
  e2:SetLabel(1)
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

-- ①的cost：丢弃这张卡
function cm.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsDiscardable() end
  Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
-- ①的过滤：大地之魔片的卡，不是这张卡本身
function cm.afilter1(c)
  return c:IsAbleToHand() and aux.IsCodeListed(c,60012048) and not c:IsCode(m)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(cm.afilter1,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.SelectMatchingCard(tp,cm.afilter1,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end

-- ②的条件：仪式召唤成功
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
-- ②的过滤：7星以下，可以放进化指示物，或者仪式怪兽
function cm.spfilter2(c,e,tp)
  return c:IsLevelBelow(7)
    and c:IsCanHaveCounter(0x624) and Duel.IsCanAddCounter(c:GetControler(),0x624,1,c)
    and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or (c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsType(TYPE_RITUAL)))
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end

-- ③的条件：1个以上进化指示物
function cm.incon1(e)
  local c=e:GetHandler()
  return c:IsFaceup() and c:GetCounter(0x624)>=1
end
-- ③的数值：指示物数量*400
function cm.atkval(e,c)
  return c:GetCounter(0x624)*400
end
-- ③的条件：3个以上进化指示物
function cm.incon3(e)
  local c=e:GetHandler()
  return c:IsFaceup() and c:GetCounter(0x624)>=3
end
