-- 虫风花·魅禄
local cm,m,o=GetID()
function cm.initial_effect(c)
  -- 添加虫风花系列的卡名记述，方便其他卡识别
  aux.AddCodeList(c,60012033)
  -- 注册进化指示物的许可
  c:EnableCounterPermit(0x624)
  
  -- ①：自己场上没有怪兽的场合，这张卡可以从手卡特殊召唤
  --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
  
  -- ②：对方召唤/特殊召唤怪兽成功的触发效果
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(m,0))
  e2:SetCategory(CATEGORY_COUNTER+CATEGORY_RECOVER+CATEGORY_DAMAGE+CATEGORY_TOHAND)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetRange(LOCATION_MZONE)
  --e2:SetCountLimit(1,m)
  e2:SetCondition(cm.act2_con)
  e2:SetTarget(cm.act2_target)
  e2:SetOperation(cm.act2_activate)
  c:RegisterEffect(e2)
  local e2_2=e2:Clone()
  e2_2:SetCode(EVENT_SUMMON_SUCCESS)
  c:RegisterEffect(e2_2)
  
  -- ③的子效果1：1个以上指示物，自己/对方回合可以用②的效果，只在这张卡在场期间1次，加NO_TURN_RESET
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(m,1))
  e3:SetCategory(CATEGORY_COUNTER+CATEGORY_RECOVER+CATEGORY_DAMAGE+CATEGORY_TOHAND)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetRange(LOCATION_MZONE)
  e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
  e3:SetCondition(cm.act3_con1)
  e3:SetTarget(cm.act2_target)
  e3:SetOperation(cm.act2_activate)
  c:RegisterEffect(e3)
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
-- ②的触发条件：对方召唤/特殊召唤了怪兽，用你说的IsType(TYPE_MONSTER)判断
function cm.act2_con(e,tp,eg,ep,ev,re,r,rp)
  return rp==1-tp and eg:IsExists(function(tc) return tc:IsType(TYPE_MONSTER) end,1,nil)
end

-- ②的目标函数
function cm.act2_target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
end

-- ②的效果执行
function cm.act2_activate(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  -- 对方的怪兽等级降1，自己等级升1
  local tc=eg:Filter(function(tc) return tc:IsType(TYPE_MONSTER) end,nil):GetFirst()
  if tc then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_LEVEL)
    e1:SetValue(-1)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    tc:RegisterEffect(e1)
  end
  if c:IsFaceup() then
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_LEVEL)
    e2:SetValue(1)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e2)
    -- 放置进化指示物
    if c:IsCanHaveCounter(0x624) then
      c:AddCounter(0x624,1)
      Duel.RegisterFlagEffect(tp,60002148,0,0,1)
    end
  end
  -- 检查自己是不是场上等级最高的怪兽
  local maxlv=0
  local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
  for tc in aux.Next(g) do
    if tc:GetLevel()>maxlv then
      maxlv=tc:GetLevel()
    end
  end
  if c:GetLevel()>=maxlv then
    -- 等级变回3
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CHANGE_LEVEL)
    e3:SetValue(3)
    e3:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e3)
    -- 检查有没有3个以上的进化指示物
    local has3=c:GetCounter(0x624)>=3
    if has3 then
      -- 3个以上的话，全部适用，不用选
      Duel.Recover(tp,300,REASON_EFFECT)
      Duel.Damage(1-tp,100,REASON_EFFECT)
      local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToHand),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
      if #sg>0 then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
      end
    else
      -- 否则选1项适用
      local op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3),aux.Stringid(m,4))
      if op==0 then
        Duel.Recover(tp,300,REASON_EFFECT)
      elseif op==1 then
        Duel.Damage(1-tp,100,REASON_EFFECT)
      else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToHand),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
        if #sg>0 then
          Duel.SendtoHand(sg,nil,REASON_EFFECT)
          Duel.ConfirmCards(1-tp,sg)
        end
      end
    end
  end
end

-- 1个以上进化指示物的条件
function cm.act3_con1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsFaceup() and c:GetCounter(0x624)>=1
end
