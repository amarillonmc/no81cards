local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.rmcon)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAINING)
		ge2:SetCondition(s.clearop1)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAIN_END)
		ge3:SetCondition(s.clearop2)
		Duel.RegisterEffect(ge3,0)
		s[0]={}
		s[1]=false
	end
end
function s.clearop1(e,tp,eg,ep,ev,re,r,rp)
	if s[1] then s[0]={} s[1]=false end
end
function s.clearop2(e,tp,eg,ep,ev,re,r,rp)
	if #(s[0])~=0 then s[1]=true end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(2,id)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_GRAVE,0)
	e2:SetTarget(s.eftg1)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(2,id)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetTargetRange(LOCATION_GRAVE,0)
	e4:SetTarget(s.eftg2)
	e4:SetLabelObject(e3)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function s.eftg1(e,c)
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	if g:GetCount()==0 then return end
	return g:GetMinGroup(Card.GetSequence):GetFirst()==c and c:IsType(TYPE_SPELL)
end
function s.eftg2(e,c)
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	if g:GetCount()==0 then return end
	return g:GetMinGroup(Card.GetSequence):GetFirst()==c and c:IsType(TYPE_TRAP)
end
function s.filter(c)
	return c:IsRace(RACE_INSECT) and c:IsLevel(1) and c:IsType(TYPE_TUNER) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>1 or e:GetHandler():IsAbleToRemove() and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local res
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then res=Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) end
	local c=e:GetHandler()
	if not res or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	local op=aux.SelectFromOptions(tp,{c:IsAbleToRemove(),aux.Stringid(id,1)},{#g>1 and g:GetMaxGroup(Card.GetSequence):GetFirst()~=c,aux.Stringid(id,2)})
	if op==1 then Duel.Remove(c,POS_FACEUP,REASON_EFFECT) elseif op==2 then Duel.MoveSequence(c,0) end
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActivated() or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local rc=re:GetHandler()
	s[0][rc]=rc:GetFieldID()
	return g:IsContains(rc) and rc:IsRelateToEffect(re)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local rc=re:GetHandler()
		if rc:GetFieldID()==s[0][rc] then rc:CreateEffectRelation(e) end
		return rc:GetFieldID()==s[0][rc] and c:IsAbleToRemove()
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(e) or rc:IsImmuneToEffect(e) then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,4))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.tdcon)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	rc:RegisterEffect(e1)
	if c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,1,nil)
	if g:GetCount()>0 then
		if g:GetFirst():IsOnField() then Duel.HintSelection(g) end
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
