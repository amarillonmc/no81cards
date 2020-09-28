--恒星级强者
function c72100107.initial_effect(c)
	---special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c72100107.spcon)
	e1:SetOperation(c72100107.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c72100107.defval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,72100107)
	e3:SetTarget(c72100107.seatg)
	e3:SetOperation(c72100107.seaop)
	c:RegisterEffect(e3)
end
function c72100107.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c72100107.spcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c72100107.spfilter,tp,LOCATION_HAND,0,nil)
	if not c:IsAbleToGraveAsCost() or Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY) then
		g:RemoveCard(c)
	end
	return g:CheckWithSumGreater(Card.GetLevel,9)
end
function c72100107.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c72100107.spfilter,c:GetControler(),LOCATION_HAND,0,nil)
	if not c:IsAbleToGraveAsCost() or Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY) then
		g:RemoveCard(c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=g:SelectWithSumGreater(tp,Card.GetLevel,9)
	Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
end
-----
function c72100107.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c72100107.defval(e,c)
	return Duel.GetMatchingGroupCount(c72100107.filter,c:GetControler(),LOCATION_GRAVE,0,nil)*800
end
-----------
function c72100107.filter(c)
  return c:IsLevel(8) and c:IsAbleToHand()
end
function c72100107.seatg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c72100107.filter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c72100107.seaop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c72100107.filter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
  end
end
