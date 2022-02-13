--旭光与黄昏同在
local m=60000056
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(cm.spcon)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon1)
	c:RegisterEffect(e1) 
	--Effect 2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.con)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.con)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
	--Effect 3
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.con1)
	e5:SetTarget(cm.tg1)
	e5:SetOperation(cm.op1)
	c:RegisterEffect(e5) 
end
--Effect 1
function cm.cfilter(c)
	return c:IsSetCard(0x62a) and c:IsFaceup()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then return false end
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>=15 
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then return false end
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>=15 and (#g==0 or (#g>0 and g:FilterCount(cm.cfilter,nil)==#g)) 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--Effect 2
function cm.togfilter(c)
	return c:IsSetCard(0x62a) and c:IsAbleToGrave()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(cm.togfilter,tp,LOCATION_DECK,0,1,nil)
	and not e:GetHandler():IsAttack(2500)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(cm.togfilter,tp,LOCATION_DECK,0,1,nil)
		and not c:IsAttack(2500) 
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.togfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e1:SetValue(2500)
				c:RegisterEffect(e1)
			end
		end
	end
end
--Effect 3 
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x62a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and c:IsAbleToDeck()
		and e:GetHandler():GetFlagEffect(m)==0  end
	e:GetHandler():RegisterFlagEffect(m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if c:IsLocation(LOCATION_ONFIELD) then
			Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			if not og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then return end
			if og:GetFirst():IsLocation(LOCATION_DECK) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
				local tc=g:GetFirst()
				if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
					e1:SetTargetRange(1,0)
					e1:SetLabel(tc:GetCode())
					e1:SetTarget(cm.splimit)
					e1:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e1,tp)
				end
			end
		end
	end
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se and se:GetHandler():IsCode(m) and c:GetCode()==e:GetLabel()
end
