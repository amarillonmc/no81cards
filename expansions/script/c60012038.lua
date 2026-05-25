-- 闪耀的金币
--Duel.LoadScript("c.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
  -- 激活效果
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(cm.target)
  e1:SetOperation(cm.activate)
  c:RegisterEffect(e1)
end

-- 目标函数
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
  local b1=false
  local b2=false
  local b3=false
  if Duel.IsPlayerCanDraw(tp,1) and Duel.GetFlagEffect(tp,m+10000000)==0 then b1=true end
  if Duel.GetFlagEffect(tp,m+20000000)==0 then b2=true end
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,nil,TYPE_NORMAL,0,0,1,RACE_MACHINE,ATTRIBUTE_LIGHT)
    and Duel.GetFlagEffect(tp,m+30000000)==0 then b3=true end
  if chk==0 then return b1 or b2 or b3 end
end

-- 激活操作
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  Duel.RegisterFlagEffect(tp,m,0,0,1)
  local b1=false
  local b2=false
  local b3=false
  if Duel.IsPlayerCanDraw(tp,1) and Duel.GetFlagEffect(tp,m+10000000)==0 then b1=true end
  if Duel.GetFlagEffect(tp,m+20000000)==0 then b2=true end
  if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,nil,TYPE_NORMAL,0,0,1,RACE_MACHINE,ATTRIBUTE_LIGHT)
    and Duel.GetFlagEffect(tp,m+30000000)==0 then b3=true end
  -- 选1项发动
  local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(m,1)},
		{b2,aux.Stringid(m,2)},
		{b3,aux.Stringid(m,3)})
  if op==1 then
    -- 自己抽1张
    Duel.Draw(tp,1,REASON_EFFECT)
    Duel.RegisterFlagEffect(tp,m+10000000,0,0,1)
  elseif op==2 then
    -- 回复100基本分
    Duel.Recover(tp,100,REASON_EFFECT)
    Duel.RegisterFlagEffect(tp,m+20000000,0,0,1)
  elseif op==3 then
    -- 变成通常怪兽特殊召唤
    if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPE_NORMAL,0,0,1,RACE_MACHINE,ATTRIBUTE_LIGHT) then
      c:AddMonsterAttribute(TYPE_NORMAL)
      Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
    end
    Duel.RegisterFlagEffect(tp,m+30000000,0,0,1)
  end
  if Duel.GetFlagEffect(tp,m+10000000)+Duel.GetFlagEffect(tp,m+20000000)+Duel.GetFlagEffect(tp,m+30000000)>=3 then 
    Duel.ResetFlagEffect(tp,m+10000000)
    Duel.ResetFlagEffect(tp,m+20000000)
    Duel.ResetFlagEffect(tp,m+30000000)
  end
end