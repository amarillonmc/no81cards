local m=60000025
local cm=_G["c"..m]
cm.name="盛夏风暴 博士"
function cm.initial_effect(c)
  c:SetUniqueOnField(1,0,60000025)
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),4,2,cm.spxyzfilter,aux.Stringid(m,0),99,cm.xyzop)

  c:EnableReviveLimit()
  
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(m,1))
  e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1,m)
  e3:SetCost(cm.sgspcost)
  e3:SetOperation(cm.sgspop)
  c:RegisterEffect(e3)
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(m,2))
  e4:SetType(EFFECT_TYPE_QUICK_O)
  e4:SetCode(EVENT_FREE_CHAIN)
  e4:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
  e4:SetCondition(cm.pencon)
  e4:SetOperation(cm.penop)
  c:RegisterEffect(e4)
end
function cm.spxyzfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x6623) and not c:IsCode(m)
end
function cm.xyzop(e,tp,chk)
  if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
  Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.bjfilter(c)
  return c:IsSetCard(0x6623) and c:IsType(TYPE_XYZ)
end
function cm.bjfilterexr(c)
  return c:IsSetCard(0x6623) and c:IsType(TYPE_XYZ) and c:IsHasEffect(EFFECT_EXTRA_RELEASE)
end
function cm.bjfilterexrsum(c)
  return c:IsSetCard(0x6623) and c:IsType(TYPE_XYZ) and c:IsHasEffect(EFFECT_EXTRA_RELEASE_SUM)
end
function cm.value(e,fp,rp,r)
  if rp==e:GetHandlerPlayer() or r~=LOCATION_REASON_TOFIELD then return 7 end
  local limit=Duel.GetMatchingGroupCount(cm.bjfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)
  return limit>0 and limit or 7
end
function cm.sumlimit(e,c)
  local tp=e:GetHandlerPlayer()
  if c:IsControler(1-tp) then
  local mint,maxt=c:GetTributeRequirement()
  local x=Duel.GetMatchingGroupCount(cm.bjfilter,tp,LOCATION_MZONE,0,nil)
  local y=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
  local ex=Duel.GetMatchingGroupCount(cm.bjfilterexr,tp,LOCATION_MZONE,0,nil)
  local exs=Duel.GetMatchingGroupCount(cm.bjfilterexrsum,tp,LOCATION_MZONE,0,nil)
  if ex==0 and exs>0 then
	ex=1
  end
  return y-maxt+ex+1 > x-ex
  else
  return false
  end
end
function cm.deckfilter1(c,e,tp)
  return c:IsSetCard(0x6623) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsAbleToGrave())
end
function cm.deckfilter2(c)
  return c:IsSetCard(0x6623) and c:IsAbleToHand()
end
function cm.sgspcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(cm.deckfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.deckfilter2,tp,LOCATION_DECK,0,1,nil) end
  local g=e:GetHandler():GetOverlayGroup()
  Duel.SendtoGrave(g,REASON_COST)
end
function cm.sgspop(e,tp,eg,ep,ev,re,r,rp)
  if not (Duel.IsExistingMatchingCard(cm.deckfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) or Duel.IsExistingMatchingCard(cm.deckfilter2,tp,LOCATION_DECK,0,1,nil)) then return end
  local sg=Duel.SelectMatchingCard(tp,cm.deckfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
  local sc=sg:GetFirst()
  if sc then
	if (sc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0) and (not sc:IsAbleToGrave() or Duel.SelectOption(tp,1152,1191)==0) then
	  Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	else
	  Duel.SendtoGrave(sc,REASON_EFFECT)
	end 
  end
  local sg=Duel.SelectMatchingCard(tp,cm.deckfilter2,tp,LOCATION_DECK,0,1,1,nil)
  local sc=sg:GetFirst()
  if sc then	
	Duel.SendtoHand(sc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sc)
  end
end
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsLocation(LOCATION_ONFIELD) or e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT) end
end
