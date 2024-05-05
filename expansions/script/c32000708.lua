--抵抗巨炮 安那米

local s,id,o = GetID()
local zd = 0x3d4
function s.initial_effect(c)

  --SpOnOpFromHand
  local e1 = Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,id)
  e1:SetCondition(s.e1con)
  e1:SetTarget(s.e1tg)
  e1:SetOperation(s.e1op)
  c:RegisterEffect(e1)

  --OrigOwnerDrawWhenSpSum
  local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
	
  

end

--e1

function s.e1con(e,tp,eg,ep,ev,re,r,rp)
  return (Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2)
end

function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c = e:GetHandler()
  if chk == 0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE) > 0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end

  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end

function s.e1op(e,tp,eg,ep,ev,re,r,rp)
  local c = e:GetHandler()
  if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
      Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)

    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(s.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e1,c:GetOwner())
    local e2 = e1:Clone()
    e2:SetCode(EFFECT_CANNOT_SUMMON)
    Duel.RegisterEffect(e2,c:GetOwner())
  end
end

function s.splimit(e,c)
  return not c:IsSetCard(zd)
end


--e2

function s.e2tohfilter(c)
    return c:IsSetCard(zd) and c:IsAbleToHand()
end

function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk == 0 then return Duel.IsExistingMatchingCard(s.e2tohfilter,c:GetOwner() ,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,c:GetOwner(),LOCATION_DECK)
end

function s.e2op(e,tp,eg,ep,ev,re,r,rp)
  local c = e:GetHandler()
  if not (Duel.IsExistingMatchingCard(s.e2tohfilter,c:GetOwner() ,LOCATION_DECK,0,1,nil))
    then return end
   Duel.Hint(HINT_SELECTMSG,c:GetOwner(),HINTMSG_TOHAND)
  local g = Duel.SelectMatchingCard(c:GetOwner(),s.e2tohfilter,c:GetOwner(),LOCATION_DECK,0,1,1,nil)
  Duel.SendtoHand(g,nil,REASON_EFFECT)
end










