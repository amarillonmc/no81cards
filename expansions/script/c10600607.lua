-- 藏在笑容背后的秘密
local s, id = GetID()
local USED_FLAG = id + 300   -- 使用次数标记
local PREP_FLAG = id + 500   -- 经过的准备阶段数标记

function s.initial_effect(c)
  c:SetUniqueOnField(1,0,id) 
	--Activate
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_ACTIVATE)
	e00:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e00)

  -- ① 不受其他卡的效果影响
  local e0 = Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_SINGLE)
  e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e0:SetRange(LOCATION_SZONE)
  e0:SetCode(EFFECT_IMMUNE_EFFECT)
  e0:SetValue(s.immfilter)
  c:RegisterEffect(e0)

  -- ② 主要阶段二速效果（同一连锁最多1次）
  local e1 = Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id, 0))
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetRange(LOCATION_SZONE)
  e1:SetHintTiming(TIMING_MAIN_END)
  e1:SetCountLimit(1, EFFECT_COUNT_CODE_CHAIN)
  e1:SetCondition(s.condition)
  e1:SetCost(s.cost)
  e1:SetTarget(s.target)
  e1:SetOperation(s.operation)
  c:RegisterEffect(e1)

	-- 准备阶段计数增加（永续，不入连锁）
  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCondition(s.prepcon)
  e2:SetOperation(s.prepop)
  c:RegisterEffect(e2)

  -- ③ 准备阶段破坏并清场
  local e3 = Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(id, 1))
  e3:SetCategory(CATEGORY_DESTROY + CATEGORY_TODECK)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e3:SetCode(EVENT_PHASE + PHASE_STANDBY)
  e3:SetRange(LOCATION_SZONE)
  e3:SetCondition(s.descon3)
  e3:SetTarget(s.tg3)
  e3:SetOperation(s.op3)
  c:RegisterEffect(e3)
end

-- 不受其他卡效果影响
function s.immfilter(e, te)
  return te:GetHandler() ~= e:GetHandler()
end

-- ② 主要阶段，满足发动条件才能发动
function s.condition(e, tp, eg, ep, ev, re, r, rp)
  local ph = Duel.GetCurrentPhase()
  if ph ~= PHASE_MAIN1 and ph ~= PHASE_MAIN2 then return false end
	local c = e:GetHandler()
	if s.get_next_use(c) > 6 then return false end
  return s.check(tp, e:GetHandler(),e)
end

-- 获取下一次使用序号
function s.get_next_use(c)
  return c:GetFlagEffect(USED_FLAG) + 1
end

-- ② 支付不同cost
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
  local c = e:GetHandler()
  local next_use = s.get_next_use(c)
  local mod = next_use % 3
  if mod == 1 then
    -- 第1,4次：除外卡组1张（里侧）
    if chk == 0 then
      return Duel.IsExistingMatchingCard(Card.IsAbleToRemove, tp, LOCATION_DECK, 0, 1, nil)
    end
  Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectMatchingCard(tp, Card.IsAbleToRemove, tp, LOCATION_DECK, 0, 1, 1, nil)
    Duel.Remove(g, POS_FACEDOWN, REASON_COST)
    e:SetLabel(1)
  elseif mod == 2 then
    -- 第2,5次：除外墓地1张（里侧）
    if chk == 0 then
      return Duel.IsExistingMatchingCard(Card.IsAbleToRemove, tp, LOCATION_GRAVE, 0, 1, nil)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectMatchingCard(tp, Card.IsAbleToRemove, tp, LOCATION_GRAVE, 0, 1, 1, nil)
    Duel.Remove(g, POS_FACEDOWN, REASON_COST)
    e:SetLabel(2)
  else
    -- 第3,6次：除外手卡1张（里侧）
    if chk == 0 then
      return Duel.IsExistingMatchingCard(Card.IsAbleToRemove, tp, LOCATION_HAND, 0, 1, nil)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectMatchingCard(tp, Card.IsAbleToRemove, tp, LOCATION_HAND, 0, 1, 1, nil)
    Duel.Remove(g, POS_FACEDOWN, REASON_COST)
    e:SetLabel(3)
  end
end

-- ② 发动条件检测
function s.check(tp, c,e)
  local next_use = s.get_next_use(c)
  local mod = next_use % 3
  if mod == 1 then
    -- 需要卡组有卡可除外，墓地有卡可回收
    return Duel.IsExistingMatchingCard(Card.IsAbleToRemove, tp, LOCATION_DECK, 0, 1, nil)
      and Duel.IsExistingMatchingCard(Card.IsAbleToHand, tp, LOCATION_GRAVE, 0, 1, nil)
  elseif mod == 2 then
    -- 需要墓地有卡可除外，手牌有可特召的怪兽，且场上有可用格子
    return Duel.IsExistingMatchingCard(Card.IsAbleToRemove, tp, LOCATION_GRAVE, 0, 1, nil)
      and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned, tp, LOCATION_HAND, 0, 1, nil, e, 0, tp, false, false)
      and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
  else
    -- 需要手牌有卡可除外，卡组有卡可检索
    return Duel.IsExistingMatchingCard(Card.IsAbleToRemove, tp, LOCATION_HAND, 0, 1, nil)
      and Duel.IsExistingMatchingCard(Card.IsAbleToHand, tp, LOCATION_DECK, 0, 1, nil)
  end
end

-- ② 注册效果信息
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
  local branch = e:GetLabel()
  if chk == 0 then return true end
  if branch == 1 then
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectTarget(tp, Card.IsAbleToHand, tp, LOCATION_GRAVE, 0, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, g, 1, 0, 0)
  elseif branch == 2 then
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_HAND)
  else
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
  end
end

-- ② 操作（1、2、3、4、5、6）
function s.operation(e, tp, eg, ep, ev, re, r, rp)
  local c = e:GetHandler()
  c:RegisterFlagEffect(USED_FLAG, 0, 0, 1)
  local branch = e:GetLabel()
  if branch == 1 then
    -- 第1、4次使用
    local tc = Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
      Duel.SendtoHand(tc, nil, REASON_EFFECT)
    end
  elseif branch == 2 then
    -- 第2、5次使用
    if Duel.GetLocationCount(tp, LOCATION_MZONE) <= 0 then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local sg = Duel.SelectMatchingCard(tp, Card.IsCanBeSpecialSummoned, tp, LOCATION_HAND, 0, 1, 1, nil, e, 0, tp, false, false)
    if #sg > 0 then
      Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
    end
  else
    -- 第3、6次使用
    if not Duel.IsExistingMatchingCard(Card.IsAbleToHand, tp, LOCATION_DECK, 0, 1, nil) then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local sg = Duel.SelectMatchingCard(tp, Card.IsAbleToHand, tp, LOCATION_DECK, 0, 1, 1, nil)
    local tc = sg:GetFirst()
    if tc then
      if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
        Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
      else
        Duel.SendtoHand(tc, nil, REASON_EFFECT)
        Duel.ConfirmCards(1 - tp, tc)
      end
    end
  end
  local used = c:GetFlagEffect(USED_FLAG)
  if used == 1 then
    local e_hint = Effect.CreateEffect(c)
    e_hint:SetDescription(aux.Stringid(id, 3))  
    e_hint:SetType(EFFECT_TYPE_SINGLE)
    e_hint:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e_hint:SetReset(RESET_EVENT + RESETS_STANDARD)
    c:RegisterEffect(e_hint, true)
  elseif used == 2 then
    local e_hint = Effect.CreateEffect(c)
    e_hint:SetDescription(aux.Stringid(id, 4))  
    e_hint:SetType(EFFECT_TYPE_SINGLE)
    e_hint:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e_hint:SetReset(RESET_EVENT + RESETS_STANDARD)
    c:RegisterEffect(e_hint, true)
  elseif used == 3 then
    local e_hint = Effect.CreateEffect(c)
    e_hint:SetDescription(aux.Stringid(id, 5))  
    e_hint:SetType(EFFECT_TYPE_SINGLE)
    e_hint:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e_hint:SetReset(RESET_EVENT + RESETS_STANDARD)
    c:RegisterEffect(e_hint, true)
  elseif used == 4 then
    local e_hint = Effect.CreateEffect(c)
    e_hint:SetDescription(aux.Stringid(id, 6))  
    e_hint:SetType(EFFECT_TYPE_SINGLE)
    e_hint:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e_hint:SetReset(RESET_EVENT + RESETS_STANDARD)
    c:RegisterEffect(e_hint, true)
  elseif used == 5 then
    local e_hint = Effect.CreateEffect(c)
    e_hint:SetDescription(aux.Stringid(id, 7))  
    e_hint:SetType(EFFECT_TYPE_SINGLE)
    e_hint:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e_hint:SetReset(RESET_EVENT + RESETS_STANDARD)
    c:RegisterEffect(e_hint, true)
  elseif used == 6 then
    local e_hint = Effect.CreateEffect(c)
    e_hint:SetDescription(aux.Stringid(id, 8))  
    e_hint:SetType(EFFECT_TYPE_SINGLE)
    e_hint:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e_hint:SetReset(RESET_EVENT + RESETS_STANDARD)
    c:RegisterEffect(e_hint, true)
  end
end

-- ③ 准备阶段计数增加
function s.prepcon(e, tp, eg, ep, ev, re, r, rp)
  return Duel.GetTurnPlayer()==tp
end
function s.prepop(e, tp, eg, ep, ev, re, r, rp)
  e:GetHandler():RegisterFlagEffect(PREP_FLAG, 0, 0, 1)
end

-- ③ 发动条件：发动次数 + 经过准备阶段数 >= 6
function s.descon3(e, tp, eg, ep, ev, re, r, rp)
  local c = e:GetHandler()
  local used = c:GetFlagEffect(USED_FLAG)
  local prep = c:GetFlagEffect(PREP_FLAG)
  return (prep >= 6 or used >= 6 or used + prep >= 6) and Duel.GetTurnPlayer()==tp
end

-- ③ 声明破坏效果
function s.tg3(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then return true end
  Duel.SetOperationInfo(0, CATEGORY_DESTROY, e:GetHandler(), 1, 0, 0)
end

-- ③ 破坏此卡
function s.op3(e, tp, eg, ep, ev, re, r, rp)
  local c = e:GetHandler()
  if Duel.Destroy(c, REASON_EFFECT) ~= 0 then
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 1))
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_PHASE + PHASE_END)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetReset(RESET_PHASE + PHASE_END)
		e1:SetCountLimit(1)
    e1:SetTarget(s.endtg)
    e1:SetOperation(s.endop)
    Duel.RegisterEffect(e1, tp)
  end
end

function s.endtg(e, tp, eg, ep, ev, re, r, rp, chk)
  if chk == 0 then return true end
  local g1 = Duel.GetMatchingGroup(nil, tp, LOCATION_ONFIELD, 0, nil)
  local g2 = Duel.GetMatchingGroup(nil, tp, LOCATION_HAND, 0, nil)
  local g3 = Duel.GetMatchingGroup(nil, tp, LOCATION_GRAVE, 0, nil)
  local g4 = Duel.GetMatchingGroup(nil, tp, LOCATION_REMOVED, 0, nil)
  local g = g1 + g2 + g3 + g4
  Duel.SetOperationInfo(0, CATEGORY_TODECK, g, #g, 0, 0)
	--if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
	--Duel.SetChainLimit(aux.FALSE)
	--end
end

function s.endop(e, tp, eg, ep, ev, re, r, rp)
  local g1 = Duel.GetMatchingGroup(nil, tp, LOCATION_ONFIELD, 0, nil)
  local g2 = Duel.GetMatchingGroup(nil, tp, LOCATION_HAND, 0, nil)
  local g3 = Duel.GetMatchingGroup(nil, tp, LOCATION_GRAVE, 0, nil)
  local g4 = Duel.GetMatchingGroup(nil, tp, LOCATION_REMOVED, 0, nil)
  local g = g1 + g2 + g3 + g4
  g = g:Filter(Card.IsAbleToDeck, nil)
  if #g > 0 then
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
  end
end