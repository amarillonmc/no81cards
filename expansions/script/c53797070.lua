local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.regcon)
	e1:SetOperation(s.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_BATTLE_START then e1:SetValue(Duel.GetTurnCount()) else e1:SetValue(0) end
	e1:SetReset(RESET_EVENT+0x16c0000)
	e:GetHandler():RegisterEffect(e1)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetTurnCount()~=e:GetValue()
end
function s.spfilter1(c,e,tp,zone)
	return c:IsRace(RACE_ZOMBIE) and c:IsLevel(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)<=0 then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,zone)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(s.efilter)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetCode(EFFECT_MUST_ATTACK)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local tc=Duel.GetAttacker()
		local ag,da=tc:GetAttackableTarget()
		tc:CreateEffectRelation(e)
		return ag:IsExists(aux.TRUE,1,e:GetHandler()) or da
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local ag,da=tc:GetAttackableTarget()
	local at=Duel.GetAttackTarget()
	if da and e:GetHandler():IsRelateToEffect(e) then
		local sel=0
		Duel.Hint(HINT_SELECTMSG,tp,31)
		if ag:IsExists(aux.TRUE,1,e:GetHandler()) then
			sel=Duel.SelectOption(tp,1213,1214)
		else
			sel=Duel.SelectOption(tp,1213)
		end
		if sel==0 then
			s.rmop(e,tc,tp)
			Duel.ChangeAttackTarget(nil)
			return
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
	local ac=ag:Select(tp,1,1,e:GetHandler()):GetFirst()
	if ac then
		s.rmop(e,tc,tp)
		Duel.ChangeAttackTarget(ac)
	end
end
function s.rmop(e,c,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetLabelObject(c)
	e1:SetOperation(s.op)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker()==e:GetLabelObject() then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Remove(e:GetLabelObject(),POS_FACEDOWN,REASON_EFFECT)
	end
end
