--折纸使 十部梨梨梦
function c9910485.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9910485)
	e1:SetCondition(c9910485.pencon)
	e1:SetTarget(c9910485.pentg)
	e1:SetOperation(c9910485.penop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910485,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9910486)
	e2:SetCost(c9910485.spcost)
	e2:SetTarget(c9910485.sptg)
	e2:SetOperation(c9910485.spop)
	c:RegisterEffect(e2)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,9910486)
	e4:SetCondition(c9910485.setcon)
	e4:SetTarget(c9910485.settg)
	e4:SetOperation(c9910485.setop)
	c:RegisterEffect(e4)
end
function c9910485.pencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x3950)
end
function c9910485.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c9910485.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local dg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if dg:GetCount()<2 then return end
	if Duel.Destroy(dg,REASON_EFFECT)~=2 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(c9910485.negcon)
	e1:SetOperation(c9910485.negop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910485.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
		and Duel.GetFlagEffect(tp,9910485)<1
end
function c9910485.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(9910485,1)) then return end
	Duel.Hint(HINT_CARD,0,9910485)
	Duel.RegisterFlagEffect(tp,9910485,RESET_PHASE+PHASE_END,0,1)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
end
function c9910485.costfilter(c)
	return c:IsSetCard(0x3950) and c:IsLevel(5) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
		and (c:IsLocation(LOCATION_DECK) or c:IsFaceup())
end
function c9910485.fselect(g)
	return g:GetClassCount(Card.GetLocation)==g:GetCount()
end
function c9910485.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9910485.costfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil)
	if chk==0 then return #g>0
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg=g:SelectSubGroup(tp,c9910485.fselect,false,1,2)
	for tc in aux.Next(sg) do
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c9910485.tgfilter(c)
	return c:IsSetCard(0x3950) and c:IsAbleToRemove()
end
function c9910485.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c9910485.tgfilter,tp,LOCATION_HAND,0,1,c)
		and Duel.IsExistingMatchingCard(c9910485.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function c9910485.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		local g1=Duel.GetMatchingGroup(c9910485.tgfilter,tp,LOCATION_HAND,0,nil)
		local g2=Duel.GetMatchingGroup(c9910485.tgfilter,tp,LOCATION_DECK,0,nil)
		if #g1>0 and #g2>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg1=g1:Select(tp,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg2=g2:Select(tp,1,1,nil)
			sg1:Merge(sg2)
			Duel.SendtoGrave(sg1,REASON_EFFECT)
		end
	end
end
function c9910485.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and not re:GetHandler():IsCode(9910485)))
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c9910485.setfilter(c)
	return c:IsSetCard(0x3950) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c9910485.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910485.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9910485.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9910485.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
end
