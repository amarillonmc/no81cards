-- 暗之法则·菲迪埃尔
local cm,m,o=GetID()
function cm.initial_effect(c)
  -- 添加暗之法则系列的卡名记述
  --aux.AddCodeList(c,60012045)
  -- 注册进化指示物的许可
  c:EnableCounterPermit(0x624)
  -- 连接怪兽的复活限制
  c:EnableReviveLimit()
  
  -- 连接素材：光·暗属性的怪兽2只以上，最多3只
  aux.AddLinkProcedure(c,cm.matfilter,2,3)
  
  -- ①：连接召唤成功的时候，特殊召唤墓地的1星和2星怪兽
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCountLimit(1,m)
  e1:SetCondition(cm.spcon)
  e1:SetTarget(cm.sptg)
  e1:SetOperation(cm.spop)
  c:RegisterEffect(e1)
  
  -- ②的效果：有进化指示物的时候，攻击力上升400
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetCondition(cm.atkcon)
  e2:SetValue(800)
  c:RegisterEffect(e2)
end

-- 素材过滤：光或暗属性的怪兽
function cm.matfilter(c,lc,sumtype,tp)
  return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK)
end

-- ①的条件：连接召唤成功
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

-- 1星怪兽的过滤
function cm.spfilter1(c,e,tp)
  return c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 2星怪兽的过滤
function cm.spfilter2(c,e,tp)
  return c:IsLevel(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- ①的目标
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
			and not Duel.IsPlayerAffectedByEffect(tp,59822133)
      and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
      and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
  end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end

-- ①的操作
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
  local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter1),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter2),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  if #g1>0 and #g2>0 then
    local tc1=g1:GetFirst()
    local tc2=g2:GetFirst()
		local sg=Group.FromCards(tc1,tc2)
    -- 特殊召唤
    Duel.SpecialSummonStep(sg,0,tp,tp,false,false,POS_FACEUP)
    -- 不能成为连接召唤的素材
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    e1:SetValue(1)
    tc1:RegisterEffect(e1)
    local e2=e1:Clone()
    tc2:RegisterEffect(e2)
    Duel.SpecialSummonComplete()
  end
end

-- 攻击力上升的条件：有进化指示物
function cm.atkcon(e)
  local c=e:GetHandler()
  return c:IsFaceup() and c:GetCounter(0x624)>=1
end
