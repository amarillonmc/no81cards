-- 暴食的零嘴
Duel.LoadScript("c60001511.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
  -- 添加安纳提玛系列的卡名记述，规则上当作安纳提玛卡使用
  aux.AddCodeList(c,60012048)
  
  -- ①：激活效果，二选一，土之秘术1的cost
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
  e1:SetCost(byd.EarthRite)
  e1:SetLabel(1)
  e1:SetTarget(cm.sptg)
  e1:SetOperation(cm.spop)
  c:RegisterEffect(e1)
end

-- ①的过滤：大地之魔片的卡，不是万食的安纳提玛
function cm.afilter(c)
  return c:IsAbleToHand() and aux.IsCodeListed(c,60012048) and not c:IsCode(60012053)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    local b1=Duel.IsExistingMatchingCard(cm.afilter,tp,LOCATION_DECK,0,1,nil)
    local b2=Duel.IsPlayerCanDraw(tp,2)
    return b1 or b2
  end
  local b1=Duel.IsExistingMatchingCard(cm.afilter,tp,LOCATION_DECK,0,1,nil)
  local b2=Duel.IsPlayerCanDraw(tp,2)
  local op=0
  if b1 and b2 then
    op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
  elseif b1 then
    op=Duel.SelectOption(tp,aux.Stringid(m,1))
  else
    op=Duel.SelectOption(tp,aux.Stringid(m,2))
  end
  e:SetLabelObject(op)
  if op==0 then
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
  else
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
  end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
  local op=e:GetLabelObject()
  if op==0 then
    -- 选1：加大地之魔片的卡到手
    local g=Duel.SelectMatchingCard(tp,cm.afilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
      Duel.SendtoHand(g,nil,REASON_EFFECT)
      Duel.ConfirmCards(1-tp,g)
    end
  else
    -- 选2：抽2张
    Duel.Draw(tp,2,REASON_EFFECT)
  end
end
