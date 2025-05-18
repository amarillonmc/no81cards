--千夜 午后的阳光
function c60150601.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy and set
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(60150601,3))
	e11:SetCategory(CATEGORY_DESTROY)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_PZONE)
	e11:SetCountLimit(1)
	e11:SetTarget(c60150601.e11tg)
	e11:SetOperation(c60150601.e11op)
	c:RegisterEffect(e11)
	--can not activate effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60150601,0))
	e1:SetCategory(CATEGORY_ANNOUNCE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,60150601)
	e1:SetTarget(c60150601.acttg)
	e1:SetOperation(c60150601.actop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60150601,4))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCountLimit(1,6010601)
	e2:SetCondition(c60150601.descon)
	e2:SetTarget(c60150601.destg)
	e2:SetOperation(c60150601.desop)
	c:RegisterEffect(e2)
	--Duel.AddCustomActivityCounter(60150601,ACTIVITY_SPSUMMON,c60150601.counterfilter)
end
function c60150601.e11tgdesf(c,tp)
	if c:IsFacedown() then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft==0 and c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5 then
		return Duel.IsExistingMatchingCard(c60150601.e11tgf,tp,LOCATION_DECK,0,1,nil,true)
	else
		return Duel.IsExistingMatchingCard(c60150601.e11tgf,tp,LOCATION_DECK,0,1,nil,false)
	end
end
function c60150601.e11tgf(c,ignore)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(ignore)
end
function c60150601.e11tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c60150601.e11tgdesf,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c60150601.e11tgdesf,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150601,3))
end
function c60150601.e11op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c60150601.e11tgf,tp,LOCATION_DECK,0,1,1,nil,false)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
		end
	end
end
function c60150601.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return aux.GetAttributeCount(g)>0 end
	local tc=g:GetFirst()
	local att=0
	while tc do
		att=bit.bor(att,tc:GetAttribute())
		tc=g:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local ac=Duel.AnnounceAttribute(tp,1,att)
	e:SetLabel(ac)
	Duel.SetChainLimit(c60150601.climit)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150601,0))
end
function c60150601.climit(re,rp,tp)
	return tp==rp or not re:GetHandler():IsType(TYPE_MONSTER)
end
function c60150601.actop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local sg=g:Filter(Card.IsAttribute,nil,e:GetLabel())
	if sg:GetCount()<=0 then return end
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
		tc=sg:GetNext()
	end
end
function c60150601.counterfilter(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c60150601.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(60150601,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60150601.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c60150601.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_SPELLCASTER)
end
function c60150601.rpfilter(c,e,tp)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_PENDULUM) and (not c:IsForbidden()
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))) and not c:IsCode(60150601)
end
function c60150601.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150601.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c60150601.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150601,6))
		local g=Duel.SelectMatchingCard(tp,c60150601.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		local op=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			op=Duel.SelectOption(tp,aux.Stringid(60150601,1),aux.Stringid(60150601,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(60150601,1))
		end
		if op==0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c60150601.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x5b21)
end
function c60150601.adtg1f(c)
	return c:IsFaceup()
end
function c60150601.adtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c60150601.adtg1f,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c60150601.adtg1f,tp,LOCATION_MZONE,0,1,1,nil)
end
function c60150601.adop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local att=tc:GetAttribute()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local tc2=g:GetFirst()
		while tc2 do
			if tc2:IsAttribute(att) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc2:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc2:RegisterEffect(e2)
			end
			tc2=g:GetNext()
		end
	end
end
function c60150601.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c60150601.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,562)
	local rc=Duel.AnnounceAttribute(tp,1,0xffff)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(rc)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1,tp)
end
function c60150601.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c60150601.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150601,4))
end
function c60150601.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,562)
	local rc=Duel.AnnounceAttribute(tp,1,0xffff)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(rc)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end