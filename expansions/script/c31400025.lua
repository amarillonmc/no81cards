local m=31400025
local cm=_G["c"..m]
cm.name="武神帝-伊邪那岐"
function cm.initial_effect(c)
  c:SetUniqueOnField(1,0,31400025)
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),4,2,cm.spxyzfilter,aux.Stringid(31400025,0),99,cm.xyzop)
  aux.EnablePendulumAttribute(c,false)
  c:EnableReviveLimit()
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCode(EFFECT_MAX_MZONE)
  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e1:SetTargetRange(0,1)
  e1:SetValue(cm.value)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetRange(LOCATION_PZONE)
  e2:SetCode(EFFECT_UNRELEASABLE_SUM)
  e2:SetTargetRange(LOCATION_MZONE,0)
  e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
  e2:SetValue(cm.sumlimit)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(31400025,1))
  e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
  e3:SetType(EFFECT_TYPE_IGNITION)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1,31400025)
  e3:SetCost(cm.sgspcost)
  e3:SetOperation(cm.sgspop)
  c:RegisterEffect(e3)
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(31400025,2))
  e4:SetType(EFFECT_TYPE_QUICK_O)
  e4:SetCode(EVENT_FREE_CHAIN)
  e4:SetRange(LOCATION_MZONE+LOCATION_EXTRA)
  e4:SetCondition(cm.pencon)
  e4:SetOperation(cm.penop)
  c:RegisterEffect(e4)
end
c31400025.pendulum_level=4
function cm.spxyzfilter(c)
  return c:IsFaceup() and c:IsRace(RACE_BEASTWARRIOR) and not c:IsCode(31400025)
end
function cm.xyzop(e,tp,chk)
  if chk==0 then return Duel.GetFlagEffect(tp,31400025)==0 end
  Duel.RegisterFlagEffect(tp,31400025,RESET_PHASE+PHASE_END,0,1)
end
function cm.bjfilter(c)
  return c:IsSetCard(0x88) and c:IsType(TYPE_XYZ)
end
function cm.bjfilterexr(c)
  return c:IsSetCard(0x88) and c:IsType(TYPE_XYZ) and c:IsHasEffect(EFFECT_EXTRA_RELEASE)
end
function cm.bjfilterexrsum(c)
  return c:IsSetCard(0x88) and c:IsType(TYPE_XYZ) and c:IsHasEffect(EFFECT_EXTRA_RELEASE_SUM)
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
  return c:IsSetCard(0x88) and c:GetRace()==RACE_BEAST and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsAbleToGrave())
end
function cm.deckfilter2(c)
  return c:IsSetCard(0x88) and c:GetRace()==RACE_WINDBEAST and c:IsAbleToHand()
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
  local lc=e:GetHandler()
  local con1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
  local con2=lc:IsPosition(POS_FACEUP)
  local con3=lc:IsLocation(LOCATION_MZONE)
  local con4=lc:IsLocation(LOCATION_EXTRA) and (Duel.GetMatchingGroupCount(aux.FilterBoolFunction(Card.IsCode,31400025),tp,LOCATION_ONFIELD,0,nil)<=0)
  local con5=not lc:IsStatus(STATUS_CHAINING)
  return con1 and con2 and (con3 or con4) and con5
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
  local lc=e:GetHandler()
  local con1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
  local con2=lc:IsRelateToEffect(e)
  local con3=lc:IsLocation(LOCATION_MZONE)
  local con4=lc:IsLocation(LOCATION_EXTRA) and (Duel.GetMatchingGroupCount(aux.FilterBoolFunction(Card.IsCode,31400025),tp,LOCATION_ONFIELD,0,nil)<=0)
  if con1 and con2 and (con3 or con4) then
  Duel.MoveToField(lc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
  end
end