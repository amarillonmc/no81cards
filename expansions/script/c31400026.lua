local m=31400026
local cm=_G["c"..m]
cm.name="武神姬-伊邪那美"
function cm.initial_effect(c)
  c:SetUniqueOnField(1,0,31400026)
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_BEASTWARRIOR),4,2,cm.spxyzfilter,aux.Stringid(31400026,0),99,cm.xyzop)
  aux.EnablePendulumAttribute(c,false)
  c:EnableReviveLimit()
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetRange(LOCATION_PZONE)
  e1:SetTargetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD)
  e1:SetTarget(cm.disabletg)
  e1:SetCondition(cm.discon)
  e1:SetCode(EFFECT_DISABLE)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetCountLimit(1,31400026)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCondition(cm.xupcon)
  e2:SetOperation(cm.xupop)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetRange(LOCATION_GRAVE+LOCATION_EXTRA)
  e3:SetCondition(cm.pencon)
  e3:SetOperation(cm.penop)
  c:RegisterEffect(e3)
end
c31400026.pendulum_level=4
function cm.spxyzfilter(c)
  return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsCode(31400026)
end
function cm.xyzop(e,tp,chk)
  if chk==0 then return Duel.GetFlagEffect(tp,31400026)==0 end
  Duel.RegisterFlagEffect(tp,31400026,RESET_PHASE+PHASE_END,0,1)
end
function cm.bjfilter(c)
  return c:IsSetCard(0x88) and c:IsType(TYPE_XYZ)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetMatchingGroupCount(cm.bjfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil) > 0
end
function cm.disabletg(e,c)
  return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and (not c:IsSetCard(0x88))
end
function cm.xupfilter(c,e,tp)
  return c:IsSetCard(0x88) and c:IsType(TYPE_XYZ) and not c:IsCode(31400025) and not c:IsCode(31400026) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function cm.xupcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetMatchingGroupCount(cm.xupfilter,tp,LOCATION_EXTRA,0,nil,e,tp)>0 and e:GetHandler():IsCanBeXyzMaterial(nil)
end
function cm.xupop(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetHandler()
  if not (Duel.GetMatchingGroupCount(cm.xupfilter,tp,LOCATION_EXTRA,0,nil,e,tp)>0 and tc:IsCanBeXyzMaterial(nil) and tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,cm.xupfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
  local sc=g:GetFirst()
  if sc then
	local mg=tc:GetOverlayGroup()
	if mg:GetCount()~=0 then
	  Duel.Overlay(sc,mg)
	end
	sc:SetMaterial(Group.FromCards(tc))
	Duel.Overlay(sc,Group.FromCards(tc))
	Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	sc:CompleteProcedure()
  end
end
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
  local lc=e:GetHandler()
  return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and (lc:IsPosition(POS_FACEUP)) and (Duel.GetMatchingGroupCount(aux.FilterBoolFunction(Card.IsCode,31400026),tp,LOCATION_ONFIELD,0,nil)<=0) and not lc:IsStatus(STATUS_CHAINING)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
  if e:GetHandler():IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and (Duel.GetMatchingGroupCount(aux.FilterBoolFunction(Card.IsCode,31400026),tp,LOCATION_ONFIELD,0,nil)<=0) then
  Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
  end
end