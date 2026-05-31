-- 水之法则·瓦姆杜斯
local cm,m,o=GetID()
function cm.initial_effect(c)
  -- 添加水之法则系列的卡名记述
  --aux.AddCodeList(c,60012042)
  -- 注册进化指示物的许可
  c:EnableCounterPermit(0x624)
  -- 连接怪兽的复活限制
  c:EnableReviveLimit()
  
  -- 连接素材：卡名不同的怪兽2只以上，最多3只
  aux.AddLinkProcedure(c,nil,2,3,cm.lcheck)
  
  -- 效果注册：根据素材数量注册不同效果
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(cm.regcon)
  e2:SetOperation(cm.regop)
  c:RegisterEffect(e2)
  
  -- ②的效果：有进化指示物的时候，攻击力上升400
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_UPDATE_ATTACK)
  e3:SetCondition(cm.atkcon)
  e3:SetValue(800)
  c:RegisterEffect(e3)
end

-- 素材检查：卡名都不同
function cm.lcheck(g,lc)
  return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end

-- 注册效果的条件：连接召唤成功
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

-- 根据素材数量注册不同的效果
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local ct=c:GetMaterialCount()
  
  -- 2只以上的效果：连接区召唤怪兽的时候，给它们加进化指示物
  if ct>=2 then
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(cm.ctcon)
    e1:SetOperation(cm.ctop)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
  end
  
  -- 3只以上的效果：主阶段特殊召唤手卡怪兽
  if ct>=3 then
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(cm.sptg)
    e3:SetOperation(cm.spop)
    e3:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e3)
    c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
  end
end

-- 连接区怪兽的过滤
function cm.cfilter(c,g)
  return c:IsFaceup() and g:IsContains(c)
end

-- 加进化指示物的条件：连接区有怪兽召唤/特殊召唤
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
  local lg=e:GetHandler():GetLinkedGroup()
  return lg and eg:IsExists(cm.cfilter,1,nil,lg)
end

-- 加进化指示物的操作
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local lg=c:GetLinkedGroup()
  if not lg then return end
  local g=eg:Filter(cm.cfilter,nil,lg)
  local tc=g:GetFirst()
  while tc do
    if tc:IsCanHaveCounter(0x624) then
      tc:AddCounter(0x624,1)
      Duel.RegisterFlagEffect(tp,60002148,0,0,1)
    end
    tc=g:GetNext()
  end
end

-- 特殊召唤的过滤
function cm.spfilter(c,e,tp)
  return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 特殊召唤的目标
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

-- 特殊召唤的操作
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end

-- 攻击力上升的条件：有进化指示物
function cm.atkcon(e)
  local c=e:GetHandler()
  return c:IsFaceup() and c:GetCounter(0x624)>=1
end
