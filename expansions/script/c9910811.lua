--创生之锈
function c9910811.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9910811.target)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c9910811.descon)
	e2:SetCost(c9910811.descost)
	e2:SetTarget(c9910811.destg)
	e2:SetOperation(c9910811.desop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c9910811.setcost)
	e3:SetTarget(c9910811.settg)
	e3:SetOperation(c9910811.setop)
	c:RegisterEffect(e3)
end
function c9910811.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c9910811.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c9910811.rmfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c9910811.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
		and Duel.SelectYesNo(tp,aux.Stringid(9910811,0)) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
		e:SetOperation(c9910811.activate)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c9910811.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,e:GetHandler())
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c9910811.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	for tc in aux.Next(g) do
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
	end
end
function c9910811.descon(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetHandler():GetCardTarget()
	local rc=re:GetHandler()
	return tg and rc and tg:IsContains(rc) and Duel.IsChainNegatable(ev)
end
function c9910811.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,9910802) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,9910802)
	Duel.Release(g,REASON_COST)
end
function c9910811.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9910811.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c9910811.rfilter(c,e,tp,mc)
	if not c:IsCode(9910801) then return false end
	if Duel.GetMZoneCount(tp,c,tp)>0 and Duel.IsExistingMatchingCard(c9910811.setfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) then return true end
	local flag=Duel.GetLocationCount(tp,LOCATION_SZONE)==0 and mc:IsLocation(LOCATION_SZONE) and mc:GetSequence()<5
	return Duel.IsExistingMatchingCard(c9910811.setfilter2,tp,LOCATION_DECK,0,1,nil,flag)
end
function c9910811.setfilter1(c,e,tp)
	return c:IsSetCard(0x6951) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c9910811.setfilter2(c,ignore)
	return c:IsSetCard(0x6961) and not c:IsCode(9910811) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(ignore)
end
function c9910811.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.CheckReleaseGroup(tp,c9910811.rfilter,1,c,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c9910811.rfilter,1,1,c,e,tp,c)
	g:AddCard(c)
	Duel.Release(g,REASON_COST)
end
function c9910811.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c9910811.setfilter(c,e,tp)
	if not c:IsSetCard(0x6951) then return false end
	if c:IsType(TYPE_MONSTER) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	else return not c:IsCode(9910811) and c:IsSSetable() end
end
function c9910811.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9910811.setfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if tc:IsType(TYPE_MONSTER) then
		res=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		if res~=0 then Duel.ConfirmCards(1-tp,tc) end
	else
		Duel.SSet(tp,tc)
	end
end
