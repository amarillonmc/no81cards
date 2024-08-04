--VV－百識公国
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,75952542)
	e2:SetCondition(s.stcon)
	e2:SetTarget(s.sttg)
	e2:SetOperation(s.stop)
	c:RegisterEffect(e2)
end
function s.setfilter(c,tp)
	return c:IsSetCard(0x17d) and not c:IsCode(75952542) and c:IsType(TYPE_FIELD) and not c:IsForbidden() and c:CheckUniqueOnField(1-tp) and c:IsCanPlaceInFieldZone(tp,1-tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
function s.stcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_FZONE,LOCATION_FZONE)==2
end
function s.stfilter(c,tp)
	local seq=c:GetSequence()
	return seq<=4 and c:IsType(TYPE_EFFECT) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,seq)
end
function s.cfilter(c,seq)
	return aux.MZoneSequence(c:GetSequence())==4-seq
end
function s.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.stfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.stfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75952542,0))
	Duel.SelectTarget(tp,s.stfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
end
function s.stop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsControler(1-tp) and not tc:IsImmuneToEffect(e)) then return end
	local zone=1<<tc:GetSequence()
	local oc=Duel.GetMatchingGroup(s.seqfilter,tp,0,LOCATION_SZONE,nil,tc:GetSequence()):GetFirst()
	if oc then
		Duel.Destroy(oc,REASON_RULE)
	end
	if Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true,zone) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
function s.seqfilter(c,seq)
	return c:GetSequence()==seq
end
