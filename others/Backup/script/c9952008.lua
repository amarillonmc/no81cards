--XYZ-极·神龙炮
function c9952008.initial_effect(c)
	c:SetSPSummonOnce(9952008)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9952008.ffilter,3,true)
	aux.AddContactFusionProcedure(c,IsAbleToDeckOrExtraAsCost,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,aux.tdcfop(c))
   --cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
  --equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9952008,3))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,99520081)
	e2:SetTarget(c9952008.target)
	e2:SetOperation(c9952008.operation)
	c:RegisterEffect(e2)
 --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9952008,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,9952008)
	e2:SetCondition(c9952008.descon)
	e2:SetCost(c9952008.descost)
	e2:SetTarget(c9952008.destg)
	e2:SetOperation(c9952008.desop)
	c:RegisterEffect(e2)
  --search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9952008,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,99520080)
	e2:SetCondition(c9952008.thcon)
	e2:SetTarget(c9952008.thtg)
	e2:SetOperation(c9952008.thop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9952008.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9952008.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9952008,6))
end
function c9952008.ffilter(c,fc,sub,mg,sg)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_UNION)
end
function c9952008.efilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c9952008.eqfilter(c,g)
	return (c:IsType(TYPE_EQUIP) or c:IsType(TYPE_UNION)) and g:IsExists(c9952008.eqcheck,1,nil,c)
end
function c9952008.eqcheck(c,ec)
	return ec:CheckEquipTarget(c)
end
function c9952008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
		local g=Duel.GetMatchingGroup(c9952008.efilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c9952008.eqfilter,tp,LOCATION_GRAVE,0,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c9952008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	local g=Duel.GetMatchingGroup(c9952008.efilter,tp,LOCATION_MZONE,0,nil)
	local eq=Duel.GetMatchingGroup(c9952008.eqfilter,tp,LOCATION_GRAVE,0,nil,g)
	if ft>eq:GetCount() then ft=eq:GetCount() end
	if ft==0 then return end
	for i=1,ft do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9952008,4))
		local ec=eq:Select(tp,1,1,nil):GetFirst()
		eq:RemoveCard(ec)
		local tc=g:FilterSelect(tp,c9952008.eqcheck,1,1,nil,ec):GetFirst()
		if tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,ec,tc,true,true) then return end
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c9952008.eqlimit)
		ec:RegisterEffect(e1)
		end
	end
	Duel.EquipComplete()
end
function c9952008.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end
function c9952008.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c9952008.costfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_UNION) and c:IsAbleToGraveAsCost()
end
function c9952008.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9952008.costfilter,tp,LOCATION_DECK+LOCATION_HAND,0,3,nil) end
	local g=Duel.GetMatchingGroup(c9952008.costfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	if g:GetCount()>3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=g:Select(tp,3,3,nil)
	end
	Duel.SendtoGrave(g,REASON_COST)
end
function c9952008.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9952008.rmfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_UNION) and c:IsAbleToRemove()
end
function c9952008.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if Duel.Destroy(g,REASON_EFFECT)==0 then return end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9952008.rmfilter,tp,LOCATION_DECK,0,c)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsLocation(LOCATION_DECK) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
		and Duel.SelectYesNo(tp,aux.Stringid(9952008,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:Select(tp,1,1,nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c9952008.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c9952008.thfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_UNION) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9952008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9952008.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9952008.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9952008.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end