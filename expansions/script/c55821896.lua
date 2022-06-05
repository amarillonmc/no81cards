--亚马逊暗杀者
function c55821896.initial_effect(c)
	c:SetUniqueOnField(1,0,55821896)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55821896,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c55821896.spcon)
	e1:SetTarget(c55821896.sptg)
	e1:SetOperation(c55821896.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Select
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c55821896.seltg)
	e3:SetOperation(c55821896.selop)
	c:RegisterEffect(e3)
end
function c55821896.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x4)
end
function c55821896.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c55821896.cfilter,1,nil,tp)
end
function c55821896.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c55821896.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c55821896.thfilter(c)
	return c:IsSetCard(0x4) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c55821896.seltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	local c=Duel.GetAttacker()
	if chk==0 then return (d and d:IsSetCard(0x4)) or (c and c:IsSetCard(0x4)) end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if not Duel.IsExistingMatchingCard(c55821896.thfilter,tp,LOCATION_DECK,0,1,nil) then
		op=Duel.SelectOption(tp,aux.Stringid(55821896,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(55821896,0),aux.Stringid(55821896,1))
	end
	e:SetLabel(op)
	if e:GetLabel()==0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c55821896.selop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(c55821896.filter,tp,0xff,0,nil)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ACTIVATE_COST)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		e1:SetCost(c55821896.costchk)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c55821896.actarget)
		e1:SetOperation(c55821896.costop)
		Duel.RegisterEffect(e1,tp)
		for tc in aux.Next(g) do
			local te=tc:GetActivateEffect()
			local e2=te:Clone()
			e2:SetProperty(te:GetProperty(),EFFECT_FLAG2_COF)
			e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
			e2:SetHintTiming(TIMING_BATTLE_PHASE,TIMING_BATTLE_PHASE)
			e2:SetLabelObject(c)
			e2:SetRange(LOCATION_DECK)
			tc:RegisterEffect(e2)
		end
	else
		if not e:GetHandler():IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c55821896.thfilter),tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

-------------------------Deck Activate-----------------------------

function c55821896.filter(c)
	return ((c:IsSetCard(0x4) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))) or
	c:IsCode(24094653)) and not c:IsForbidden()
end
function c55821896.costchk(e,te_or_c,tp)
	return Duel.GetFlagEffect(tp,55821896)==0
end
function c55821896.actarget(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(tc)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and tc:IsLocation(LOCATION_DECK) and (tc:IsSetCard(0x4) or tc:IsCode(24094653))
end
function c55821896.costop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.RegisterFlagEffect(tp,55821896,RESET_PHASE+PHASE_DAMAGE,0,1)
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
