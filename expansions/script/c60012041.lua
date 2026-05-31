-- 风之法则·艾云尼亚
local cm,m,o=GetID()
function cm.initial_effect(c)
  -- 注册进化指示物的许可
  c:EnableCounterPermit(0x624)
  -- 连接怪兽的复活限制
  c:EnableReviveLimit()
  
  -- 连接素材：包含风属性怪兽的怪兽2只
  aux.AddLinkProcedure(c,nil,2,2,function(g)
    return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND)
  end)
  
  -- ①：特殊召唤成功的时候，给自己加进化指示物
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetCategory(CATEGORY_COUNTER)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetOperation(cm.spop)
  c:RegisterEffect(e1)
  
  -- ②的子效果：有进化指示物的时候，攻击力上升400
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetCondition(cm.atkcon)
  e2:SetValue(800)
  c:RegisterEffect(e2)
  
  -- ②的子效果：有进化指示物的时候，得到特殊召唤的效果，1回合1次
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(m,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1,m)
  e3:SetCondition(cm.sp2con)
  e3:SetCost(cm.sp2cost)
  e3:SetTarget(cm.sp2tg)
  e3:SetOperation(cm.sp2op)
  c:RegisterEffect(e3)
end

-- ①的操作：加进化指示物
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and c:IsCanHaveCounter(0x624) then
    c:AddCounter(0x624,1)
    Duel.RegisterFlagEffect(tp,60002148,0,0,1)
  end
end

-- 攻击力上升的条件：有进化指示物
function cm.atkcon(e)
  local c=e:GetHandler()
  return c:IsFaceup() and c:GetCounter(0x624)>=1
end

-- 特殊召唤效果的条件：有进化指示物
function cm.sp2con(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsFaceup() and c:GetCounter(0x624)>=1
end

-- 特殊召唤的cost：丢弃1张手卡
function cm.sp2cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
  Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

-- 特殊召唤的目标
function cm.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

-- 特殊召唤的操作
function cm.sp2op(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
    -- 如果是风属性，给它加进化指示物
    if tc:IsAttribute(ATTRIBUTE_WIND) and tc:IsCanHaveCounter(0x624) then
      tc:AddCounter(0x624,1)
      Duel.RegisterFlagEffect(tp,60002148,0,0,1)
    end
  end
end

-- 墓地怪兽的过滤
function cm.spfilter(c,e,tp)
  return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
