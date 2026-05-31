-- 光之法则·龙敖
local cm,m,o=GetID()
function cm.initial_effect(c)
  -- 添加光之法则系列的卡名记述
  aux.AddCodeList(c,60012049)
  -- 注册进化指示物的许可
  c:EnableCounterPermit(0x624)
  -- 连接怪兽的复活限制
  c:EnableReviveLimit()
  
  -- 连接素材：光·暗属性的怪兽2只以上，最多3只
  aux.AddLinkProcedure(c,cm.matfilter,2,3)
  
  -- ①：从卡组送可以放进化指示物的怪兽，然后特殊召唤同等级的机械族
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetCountLimit(1,m)
  e1:SetRange(LOCATION_MZONE)
  e1:SetCost(cm.spcost)
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

-- ①的cost标记
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  e:SetLabel(100)
  return true
end

-- cost的过滤：可以放置进化指示物的怪兽，能送去墓地
function cm.cfilter(c)
  return c:IsCanHaveCounter(0x624) and c:IsAbleToGraveAsCost()
end

-- 特殊召唤的过滤：机械族，等级符合，能特殊召唤
function cm.spfilter(c,e,tp,lv)
  return c:IsRace(RACE_MACHINE) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- ①的目标
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then
    if e:GetLabel()~=100 then return false end
    e:SetLabel(0)
    local cg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_DECK,0,nil)
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and cg:GetCount()>0
      and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,cg:GetClassCount(Card.GetCode))
  end
  local cg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_DECK,0,nil)
  local ct=cg:GetClassCount(Card.GetCode)
  local tg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp,ct)
  local lvt={}
  local tc=tg:GetFirst()
  while tc do
    local tlv=0
    tlv=tlv+tc:GetLevel()
    lvt[tlv]=tlv
    tc=tg:GetNext()
  end
  local pc=1
  for i=1,12 do
    if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
  end
  lvt[pc]=nil
  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
  local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  aux.GCheckAdditional=aux.dncheck
  local rg=cg:SelectSubGroup(tp,aux.TRUE,false,lv,lv)
  aux.GCheckAdditional=nil
  Duel.SendtoGrave(rg,REASON_COST)
  e:SetLabel(lv)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

-- 特殊召唤的过滤2：等级正好是选的那个
function cm.spfilter2(c,e,tp,lv)
  return c:IsRace(RACE_MACHINE) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- ①的操作
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  local lv=e:GetLabel()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end

-- 攻击力上升的条件：有进化指示物
function cm.atkcon(e)
  local c=e:GetHandler()
  return c:IsFaceup() and c:GetCounter(0x624)>=1
end
