local s,id,o=GetID()
function s.initial_effect(c)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(s.sctg)
	e3:SetOperation(s.scop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.spcon2)
	e4:SetTarget(s.sptg2)
	e4:SetOperation(s.spop2)
	c:RegisterEffect(e4)
end
function s.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not (rc:IsLocation(LOCATION_HAND) and rc:IsType(TYPE_PENDULUM) and rc:GetLeftScale()>=3)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_HAND) and rc:IsType(TYPE_PENDULUM) and rc:GetLeftScale()>=3
end
function s.pcfilter(c)
	if not c:IsType(TYPE_PENDULUM) then return false end
	return c:GetLeftScale()>=2 or c:IsReleasable()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetFirstMatchingCard(s.pcfilter,tp,LOCATION_PZONE,0,c)
	if chk==0 then return tc and s.cost(e,tp,eg,ep,ev,re,r,rp,0) end
	s.cost(e,tp,eg,ep,ev,re,r,rp,1)
	if tc:GetLeftScale()>=2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(-2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		tc:RegisterEffect(e2)
	else
		Duel.Release(tc,REASON_COST)
	end
end
function s.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsDefense(2350) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsLevel(2) and c:IsLocation(LOCATION_HAND+LOCATION_DECK)
end
function s.scfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_PZONE,0,1,nil) end
end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,s.scfilter,tp,LOCATION_PZONE,0,1,1,nil):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		tc:RegisterEffect(e2)
	end
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>=2
end
function s.pzfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if c:IsLocation(LOCATION_EXTRA) and c:IsFacedown() then return false end
		if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
		if not Duel.IsExistingMatchingCard(s.pzfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) then return false end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if c:IsLocation(LOCATION_HAND) then
			return ft>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		else
			local ex_ft=Duel.GetLocationCountFromEx(tp,tp,nil,c)
			local emz_ft=Duel.GetLocationCountFromEx(tp,tp,nil,c,0x60)
			return ex_ft>0 and (ft>=2 or (ft>=1 and emz_ft>0))
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_PZONE)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local b1=c:IsLocation(LOCATION_HAND) and ft>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	local ex_ft=Duel.GetLocationCountFromEx(tp,tp,nil,c)
	local emz_ft=Duel.GetLocationCountFromEx(tp,tp,nil,c,0x60)
	local b2=c:IsLocation(LOCATION_EXTRA) and ex_ft>0 and (ft>=2 or (ft>=1 and emz_ft>0))
	if not (b1 or b2) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.pzfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	if #g>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
