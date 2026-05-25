-- 丽金花·云庆
local cm,m,o=GetID()
function cm.initial_effect(c)
  -- 添加丽金花系列的卡名记述
  aux.AddCodeList(c,60012036)
  -- 注册进化指示物的许可
  c:EnableCounterPermit(0x624)
  
  -- 统计自己的召唤/特殊召唤次数，整个决斗的
  if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
  
  -- ①：特殊召唤的效果，1回合1次
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,m)
  e1:SetCondition(cm.spcon)
  e1:SetTarget(cm.sptg)
  e1:SetOperation(cm.spop)
  c:RegisterEffect(e1)
  
  -- ②：回复基本分的时候，加闪耀的金币，1回合最多3次
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(m,1))
  e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_RECOVER)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(3)
  e2:SetCondition(cm.reccon)
  e2:SetTarget(cm.rectg)
  e2:SetOperation(cm.recop)
  c:RegisterEffect(e2)
  
  -- ③的子效果：1个以上指示物，得到特殊召唤的效果，只在这张卡在场期间1次
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(m,2))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetRange(LOCATION_MZONE)
  e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
  e3:SetCondition(cm.sp2con)
  e3:SetTarget(cm.sp2tg)
  e3:SetOperation(cm.sp2op)
  c:RegisterEffect(e3)
  
  -- ③的子效果：3个以上指示物，得到回合结束的效果
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(m,3))
  e4:SetCategory(CATEGORY_REMOVE)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e4:SetCode(EVENT_PHASE+PHASE_END)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCountLimit(1)
  e4:SetCondition(cm.endcon)
  e4:SetTarget(cm.endtg)
  e4:SetOperation(cm.endop)
  c:RegisterEffect(e4)
end

-- 统计召唤次数的操作
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),m,0,0,1)
		tc=eg:GetNext()
	end
end

-- ①的条件：自己场上没有表侧的卡
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)==0
end

-- ①的目标
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

-- ①的操作
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  end
end

-- 检索的过滤：荣耀的丽金花或者丽金花的挥霍
function cm.thfilter(c)
  return c:IsCode(60012039,60012040) and c:IsAbleToHand()
end

-- ②的条件：自己回复了基本分
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
  return ep==tp
end

-- ②的目标
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(cm.coinfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

-- ②的操作
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.coinfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
  if #g>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
  end
end

-- 闪耀的金币的过滤
function cm.coinfilter(c)
  return c:IsCode(60012038) and c:IsAbleToHand()
end

-- 1个以上指示物的条件
function cm.sp2con(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsFaceup() and c:GetCounter(0x624)>=1
end

-- 特殊召唤的目标
function cm.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

-- 特殊召唤的操作
function cm.sp2op(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  if #g>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end

-- 5星以下的怪兽的过滤
function cm.spfilter(c,e,tp)
  return c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 3个以上指示物的条件
function cm.endcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsFaceup() and c:GetCounter(0x624)>=3
end

-- 回合结束的目标
function cm.endtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFlagEffect(tp,m)>=20 and Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)>0 end
  local ct=Duel.GetFlagEffect(tp,m)/20
  Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct,1-tp,LOCATION_HAND)
end

-- 回合结束的操作
function cm.endop(e,tp,eg,ep,ev,re,r,rp)
  local ct=Duel.GetFlagEffect(tp,m)
  local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
  if #g==0 then return end
  for i=1,ct do
    if ct<20 then return end
		ct=ct-20
    Duel.ConfirmCards(tp,g)
    local sg=g:Select(tp,1,1,nil)
    Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
    g:RemoveCard(sg:GetFirst())
  end
end
