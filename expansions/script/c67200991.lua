--天垣修正者 双司镇命
function c67200991.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200991,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c67200991.target)
	e3:SetOperation(c67200991.operation)
	c:RegisterEffect(e3) 
	--hand to pzone 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200991,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	--e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(3,67200991)
	e1:SetCondition(c67200991.pspcon)
	e1:SetTarget(c67200991.pstg)
	e1:SetOperation(c67200991.psop)
	c:RegisterEffect(e1)   
end
function c67200991.filter(c)
	return c:IsSetCard(0xc67a) and c:IsAbleToHand() and c:IsType(TYPE_PENDULUM)
end
function c67200991.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200991.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67200991.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200991.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local code=g:GetFirst():GetCode()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(c67200991.aclimit)
		e1:SetLabel(code)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c67200991.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(e:GetLabel())
end
--
function c67200991.filter1(c,e,tp)
	local b1=not c:IsForbidden()
	local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsLocation(LOCATION_HAND)
	local b3=Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLocation(LOCATION_EXTRA)
	return c:IsSetCard(0xc67a) and c:IsType(TYPE_PENDULUM) and (b1 or b2 or b3)
end
function c67200991.pspcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (re:GetActiveType()==TYPE_PENDULUM+TYPE_SPELL and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and bit.band(loc,LOCATION_PZONE)==LOCATION_PZONE and rc:IsSetCard(0x67a))
end
function c67200991.check1(g,e,tp)
	return g:IsExists(c67200991.cfilter1,1,nil,e,tp,g) and g:IsContains(e:GetHandler())
end
function c67200991.cfilter1(c,e,tp,g)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsLocation(LOCATION_HAND)
	local b2=Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLocation(LOCATION_EXTRA)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (b1 or b2) and g:IsExists(c67200991.cfilter2,1,c,e,tp)
end
function c67200991.cfilter2(c)
	return not c:IsForbidden()
end
function c67200991.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c67200991.filter1,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp)
	if chk==0 then return g:CheckSubGroup(c67200991.check1,2,2,e,tp) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c67200991.psop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	if c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c67200991.filter1,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local sg=g:SelectSubGroup(tp,c67200991.check1,false,2,2,e,tp)
		if #sg==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local tc=sg:FilterSelect(tp,c67200991.cfilter2,1,1,nil):GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			sg:RemoveCard(tc)
			if #sg>0 then
				Duel.SpecialSummon(sg:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end