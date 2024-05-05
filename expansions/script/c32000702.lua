--抵抗巨炮 美太那

local s,id,o = GetID()
local zd = 0x3d4
function s.initial_effect(c)

  --SpOrToGraveFromHand
  local e1 = Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,1))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,id)
  e1:SetCondition(s.e1con)
  e1:SetTarget(s.e1tg)
  e1:SetOperation(s.e1op)
  c:RegisterEffect(e1)


  --HandToDeckAndAtkUpAndDraw
  local e2 = Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE+CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1,id+1)
  e2:SetTarget(s.e2tg)
  e2:SetOperation(s.e2op)
  c:RegisterEffect(e2)


end

--e1

function s.e1tohfilter(c)
  return c:IsSetCard(zd) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end

function s.e1con(e,tp,eg,ep,ev,re,r,rp)
  return (Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2)
end

function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c = e:GetHandler()
  if chk == 0 then return c:IsAbleToGrave() or Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end

  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE,c,1,tp,LOCATION_HAND)
end

function s.e1op(e,tp,eg,ep,ev,re,r,rp)
  local c = e:GetHandler()
  if c:IsRelateToEffect(e) and (c:IsAbleToGrave() or Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then
    local op = 0

    if c:IsAbleToGrave() and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
      op = Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
     elseif c:IsAbleToGrave() then
      Duel.SelectOption(tp,aux.Stringid(id,3))
      op = 1
     else
      Duel.SelectOption(tp,aux.Stringid(id,2))
      op = 0
    end

    if op == 0 then
      Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
     else
      Duel.SendtoGrave(c,nil,REASON_EFFECT)
      if Duel.IsExistingMatchingCard(s.e1tohfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
        local tc = Duel.SelectMatchingCard(tp,s.e1tohfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
      end
    end
  end

  local e1 = Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetTargetRange(1,0)
  e1:SetTarget(s.splimit)
  e1:SetReset(RESET_PHASE+PHASE_END,2)
  Duel.RegisterEffect(e1,tp)
  local e2 = e1:Clone()
  e2:SetCode(EFFECT_CANNOT_SUMMON)
  Duel.RegisterEffect(e2,tp)
end

function s.splimit(e,c)
  return not c:IsSetCard(zd)
end


--e2

function s.e2todfilter(c)
  return c:IsAbleToDeck()
end

function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk == 0 then return Duel.IsExistingMatchingCard(s.e2todfilter,tp,LOCATION_HAND,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,nil,tp,LOCATION_HAND)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,nil,tp,0)
  Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,nil,tp,LOCATION_MZONE)
end

function s.e2op(e,tp,eg,ep,ev,re,r,rp)
  local c = e:GetHandler()
  if not (Duel.IsExistingMatchingCard(s.e2todfilter,tp,LOCATION_HAND,0,1,nil)) then return end

  --ToDeck
  local max = Duel.GetMatchingGroup(s.e2todfilter,tp,LOCATION_HAND,0,nil):GetCount()
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g = Duel.SelectMatchingCard(tp,s.e2todfilter,tp,LOCATION_HAND,0,1,max,nil)
  Duel.SendtoDeck(g,nil,3,REASON_EFFECT)

  --UpAtk
  local upg = Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
  local tc = upg:GetFirst()
  local upn = g:GetCount()
  while tc do
    local e1 = Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    e1:SetValue(1000*upn)
    tc:RegisterEffect(e1)
    tc = upg:GetNext()
  end

  --Draw
  local ct = 0
  if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then
    ct=ct+1
  end
  if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then
    ct=ct+1
  end
  if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
    ct=ct+1
  end

  local e2 = Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_PHASE+PHASE_END)
  e2:SetCountLimit(1)
  e2:SetLabel(ct)
  e2:SetCondition(s.e2dracon)
  e2:SetOperation(s.e2draop)
  e2:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e2,tp)
end


function s.e2dracon(e,tp,eg,ep,ev,re,r,rp)
  local draN = e:GetLabel()
  return Duel.IsPlayerCanDraw(tp,draN)
end

function s.e2draop(e,tp,eg,ep,ev,re,r,rp)
  local draN = e:GetLabel()
  if Duel.IsPlayerCanDraw(tp,draN) and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
    Duel.Draw(tp,draN,REASON_EFFECT)
  end
end












