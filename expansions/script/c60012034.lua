-- 虫风花的飞翔
local cm,m,o=GetID()
function cm.initial_effect(c)
  -- 添加虫风花系列的卡名记述，方便其他卡识别
  aux.AddCodeList(c,60012033)
  -- 注册进化指示物的许可
  c:EnableCounterPermit(0x624)
  
  -- 加入手卡的对方回合也能从手卡发动的效果，照着你给的图3图4的代码
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e0:SetCode(EVENT_TO_HAND)
  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e0:SetOperation(cm.op0)
  c:RegisterEffect(e0)
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(m,0))
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
  e2:SetCondition(cm.handcon)
  c:RegisterEffect(e2)
  
  -- 速攻魔法的激活效果
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,1))
  e1:SetCategory(CATEGORY_COUNTER+CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(cm.target)
  e1:SetOperation(cm.activate)
  c:RegisterEffect(e1)
end

-- 加入手卡时的操作，注册flag，照着你给的代码
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
  if e:GetHandler():GetFieldID()<=172 then return end
  e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end

-- 手卡发动的条件，照着你给的代码
function cm.handcon(e)
  return e:GetHandler():GetFlagEffect(m)~=0
end

-- 目标函数
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
end

-- 效果执行
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
  -- 检查有没有3个以上的进化指示物
  local has3=Duel.IsCanRemoveCounter(tp,1,0,0x624,3,REASON_RULE)
  if has3 then
    -- 3个以上的话，全部适用，不用选
    -- 给自己场上1只怪兽放置1个进化指示物
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
    local tc=Duel.SelectMatchingCard(tp,Card.IsCanHaveCounter,tp,LOCATION_MZONE,0,1,1,nil,0x624):GetFirst()
    if tc then
      tc:AddCounter(0x624,1)
      Duel.RegisterFlagEffect(tp,60002148,0,0,1)
    end
    -- 取除1个进化指示物，自己抽1张
    if Duel.IsCanRemoveCounter(tp,1,0,0x624,1,REASON_EFFECT) then
      Duel.RemoveCounter(tp,1,0,0x624,1,REASON_EFFECT)
      Duel.Draw(tp,1,REASON_EFFECT)
    end
    -- 选自己场上1只怪兽等级变为12
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local tc2=Duel.SelectMatchingCard(tp,function(tc) return tc:IsType(TYPE_MONSTER) end,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
    if tc2 then
      local e1=Effect.CreateEffect(e:GetHandler())
      e1:SetType(EFFECT_TYPE_SINGLE)
      e1:SetCode(EFFECT_CHANGE_LEVEL)
      e1:SetValue(12)
      e1:SetReset(RESET_EVENT+RESETS_STANDARD)
      tc2:RegisterEffect(e1)
    end
  else
    -- 否则选1项适用
    local op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3),aux.Stringid(m,4))
    if op==0 then
      -- 给自己场上1只怪兽放置1个进化指示物
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
      local tc=Duel.SelectMatchingCard(tp,Card.IsCanHaveCounter,tp,LOCATION_MZONE,0,1,1,nil,0x624):GetFirst()
      if tc then
        tc:AddCounter(0x624,1)
        Duel.RegisterFlagEffect(tp,60002148,0,0,1)
      end
    elseif op==1 then
      -- 取除1个进化指示物，自己抽1张
      if Duel.IsCanRemoveCounter(tp,1,0,0x624,1,REASON_EFFECT) then
        Duel.RemoveCounter(tp,1,0,0x624,1,REASON_EFFECT)
        Duel.Draw(tp,1,REASON_EFFECT)
      end
    else
      -- 选自己场上1只怪兽等级变为12
      Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
      local tc=Duel.SelectMatchingCard(tp,function(tc) return tc:IsType(TYPE_MONSTER) end,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
      if tc then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetValue(12)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
      end
    end
  end
end
