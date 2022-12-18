--墓 园 死 者 白 圣 女
local m=22348084
local cm=_G["c"..m]
function cm.initial_effect(c)
	--changename
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348084,0))
--  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22348084)
	e1:SetCost(c22348084.cost)
	e1:SetTarget(c22348084.target)
	e1:SetOperation(c22348084.operation)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348084,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22348084)
	e2:SetCost(c22348084.spcost)
	e2:SetTarget(c22348084.sptg)
	e2:SetOperation(c22348084.spop)
	c:RegisterEffect(e2)
end
function c22348084.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c22348084.cnfilter(c)
	return c:IsFaceup()
end
function c22348084.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348084.cnfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
  local tep=nil
  if Duel.GetCurrentChain()>1 then tep=Duel.GetChainInfo(Duel.GetCurrentChain()-1,CHAININFO_TRIGGERING_PLAYER) end
  if tep and tep==1-tp and Duel.SelectYesNo(tp,aux.Stringid(22348084,2)) then
	  e:SetLabel(1)
  else
	  e:SetLabel(0)
  end
end
function c22348084.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,c22348084.cnfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc:IsFaceup() then
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			e0:SetCode(EFFECT_CHANGE_CODE)
			e0:SetValue(22348080)
			tc:RegisterEffect(e0)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(RACE_ZOMBIE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		 end
	end
	elseif e:GetLabel()==1 and Duel.IsExistingMatchingCard(c22348084.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(22348080)
		e1:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	end
end


function c22348084.spcostfilter(c,tp)
	return c:IsSetCard(0x703) and c:IsFaceup() and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c22348084.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348084.spcostfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348084.spcostfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c22348084.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22348084.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end



