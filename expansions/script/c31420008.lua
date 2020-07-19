local m=31420008
local cm=_G["c"..m]
cm.name="时计塔的启明音-篁惺之海斗"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,31420008)
	c:SetSPSummonOnce(31420008)
	aux.AddLinkProcedure(c,cm.linkmfilter,1,1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(cm.spcost)
	--c:RegisterEffect(e0)
	local em=Effect.CreateEffect(c)
	em:SetType(EFFECT_TYPE_QUICK_O)
	em:SetCode(EVENT_FREE_CHAIN)
	em:SetRange(LOCATION_MZONE)
	em:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	em:SetHintTiming(0,TIMING_END_PHASE+TIMING_BATTLE_START+TIMING_CHAIN_END+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_SSET)
	local e1=Effect.Clone(em)
	e1:SetDescription(aux.Stringid(31420008,0))
	--e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCost(cm.drawcost)
	e1:SetTarget(cm.drawtg)
	e1:SetOperation(cm.drawop)
	--e1:SetTarget(cm.destg)
	--e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	local e2=Effect.Clone(e1)
	e2:SetDescription(aux.Stringid(31420008,1))
	e2:SetCost(cm.disdescost)
	e2:SetTarget(cm.disdestg)
	e2:SetOperation(cm.disdesop)
	--c:RegisterEffect(e2)
	local e3=Effect.Clone(em)
	e3:SetDescription(aux.Stringid(31420008,2))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetTarget(cm.sertg)
	e3:SetOperation(cm.serop)
	c:RegisterEffect(e3)
	local e4=Effect.Clone(em)
	e4:SetDescription(aux.Stringid(31420008,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetTarget(cm.spstg)
	e4:SetOperation(cm.spsop)
	c:RegisterEffect(e4)
end
function cm.spfilter(c)
  return c:IsSetCard(0x5311) and c:IsPosition(POS_FACEUP)
end
function cm.linkmfilter(c)
  return c:IsSetCard(0x5311)
end
function cm.spcost(e,c,tp,st)
  if bit.band(st,SUMMON_TYPE_LINK)~=SUMMON_TYPE_LINK then return true end
  return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function cm.drawcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  local de=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
  local ha=Duel.GetMatchingGroupCount(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
  if de>1 and ha>0 and Duel.SelectYesNo(tp,aux.Stringid(31420008,1)) then
	local max
	if (de-1)>ha then
	  max=ha
	else
	  max=de-1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	e:SetLabel(Duel.DiscardHand(tp,Card.IsDiscardable,1,max,REASON_COST+REASON_DISCARD,nil))
  else
	e:SetLabel(0)
  end
end
function cm.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  local ct=e:GetLabel()
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1+ct,tp,LOCATION_DECK)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.drawop(e,tp,eg,ep,ev,re,r,rp)
  local ct=e:GetLabel()
  Duel.Draw(tp,1+ct,REASON_EFFECT)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
  if g:GetCount()>0 then
	Duel.Destroy(g,REASON_EFFECT)
  end
end
function cm.disdescost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	e:SetLabel(Duel.DiscardHand(tp,Card.IsDiscardable,1,Duel.GetMatchingGroupCount(Card.IsDiscardable,tp,LOCATION_HAND,0,nil),REASON_COST+REASON_DISCARD,nil))
end
function cm.disdestg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end
  local ct=e:GetLabel()
  Duel.SetTargetParam(ct)
  Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.disdesop(e,tp,eg,ep,ev,re,r,rp)
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
  local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,p+1,nil,e,tp)
  if g:GetCount()>0 then
	Duel.Destroy(g,REASON_EFFECT)
  end
end
function cm.serfilter(c)
  return c:IsSetCard(0x5311) and c:IsAbleToHand() and (c:IsLocation(LOCATION_DECK) or c:IsPosition(POS_FACEUP))
end
function cm.sertg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(cm.serfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.serop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,cm.serfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
  end
end
function cm.spsfilter(c,e,tp)
  return c:IsSetCard(0x5311) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(cm.spsfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.spsop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetMZoneCount(tp)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spsfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end