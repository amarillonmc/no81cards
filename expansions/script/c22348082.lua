--墓 园 死 者 殇 死 魔
local m=22348082
local cm=_G["c"..m]
function cm.initial_effect(c)
	--DECKDES
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348082,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22348082)
	e1:SetCost(c22348082.cost)
	e1:SetTarget(c22348082.target)
	e1:SetOperation(c22348082.operation)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348082,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22348082)
	e2:SetCost(c22348082.spcost)
	e2:SetTarget(c22348082.sptg)
	e2:SetOperation(c22348082.spop)
	c:RegisterEffect(e2)
	
end
function c22348082.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c22348082.tgfilter(c)
	return c:IsSetCard(0x703) and c:IsAbleToGrave()
end
function c22348082.tgfilter2(c)
	return c:IsSetCard(0x703) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)   
end
function c22348082.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c22348082.tgfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
  local tep=nil
  if Duel.GetCurrentChain()>1 then tep=Duel.GetChainInfo(Duel.GetCurrentChain()-1,CHAININFO_TRIGGERING_PLAYER) end
  if tep and tep==1-tp then
	  e:SetCategory(CATEGORY_DECKDES+CATEGORY_TOHAND)
	  e:SetLabel(1)
	  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
  else
	  e:SetCategory(CATEGORY_DECKDES)
	  e:SetLabel(0)
	  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
  end
end
function c22348082.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348082.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		  if e:GetLabel()==1 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c22348082.tgfilter2),tp,LOCATION_GRAVE,0,1,nil)  and Duel.SelectYesNo(tp,aux.Stringid(22348082,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348082.tgfilter2),tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		 end
	end
end
function c22348082.spcostfilter(c,tp)
	return c:IsSetCard(0x703) and c:IsFaceup() and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c22348082.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348082.spcostfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348082.spcostfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c22348082.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22348082.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end


















