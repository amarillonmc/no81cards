local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.skipcon)
	e1:SetOperation(s.skipop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_COST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(0xff)
	e2:SetLabelObject(e1)
	e2:SetOperation(s.spcop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.skipcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1
end
function s.skipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_EP)
	e1:SetTargetRange(0,1)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetTurnPlayer()~=tp then
		if Duel.GetCurrentPhase()<PHASE_BATTLE_START then
		if Duel.GetCurrentPhase()<PHASE_MAIN1 then
		if Duel.GetCurrentPhase()<PHASE_STANDBY then
			Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
		end
			Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
		end
			e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_OPPO_TURN,2)
			Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
			if Duel.GetTurnCount()==1 then 
				Duel.SkipPhase(1-tp,PHASE_END,RESET_PHASE+PHASE_END,1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e2:SetCode(EFFECT_SKIP_TURN)
				e2:SetTargetRange(1,0)
				e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
				Duel.RegisterEffect(e2,tp)
				Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
				Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
				Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,2)
			end
		else
			if Duel.GetCurrentPhase()<PHASE_END then
			if Duel.GetCurrentPhase()<PHASE_MAIN2 then
				Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
			end
				Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
			end
			Duel.SkipPhase(1-tp,PHASE_END,RESET_PHASE+PHASE_END,1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_SKIP_TURN)
			e2:SetTargetRange(1,0)
			e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
			Duel.RegisterEffect(e2,tp)
			Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
			Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
			Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,2)
		end
	else
		e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_OPPO_TURN)
		if Duel.GetCurrentPhase()<PHASE_END then
		if Duel.GetCurrentPhase()<PHASE_MAIN2 then
		if Duel.GetCurrentPhase()<PHASE_BATTLE_START then
		if Duel.GetCurrentPhase()<PHASE_MAIN1 then
		if Duel.GetCurrentPhase()<PHASE_STANDBY then
			Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
		end
			Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
		end
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_CANNOT_EP)
			e3:SetTargetRange(1,0)
			e3:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
			Duel.RegisterEffect(e3,tp)
			Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		end
			Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
		end
			Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		end
		Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	end
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(s.atkop)
	if Duel.GetCurrentPhase()&PHASE_BATTLE_START==0 then e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE_START) else e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE_START,2) end
	c:RegisterEffect(e4,true)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsAttackable,tp,0,LOCATION_MZONE,nil)
	if #g==0 then return end
	local tg=g:GetMaxGroup(Card.GetAttack)
	local tc=tg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	if #tg>1 then tc=tg:Select(tp,1,1,nil):GetFirst() end
	if tc:IsImmuneToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_BATTLED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(s.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e1)
	Duel.CalculateDamage(tc,c,true)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if g:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.spcop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	local tg=g:GetMaxGroup(Card.GetAttack)
	if tg:IsExists(Card.IsControler,1,nil,1-tp) then e:GetLabelObject():SetLabel(1) end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.spfilter(c,e,tp)
	return c:IsCode(93353691) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetCondition(s.econ)
		e1:SetValue(s.efilter)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function s.econ(e)
	local ph=Duel.GetCurrentPhase()
	return not ((ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()))
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
