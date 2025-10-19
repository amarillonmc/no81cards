--驯兽师 玄羽
function c16300000.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,16300000)
	e1:SetTarget(c16300000.target)
	e1:SetOperation(c16300000.activate)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16300000,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,16300000+1)
	e2:SetTarget(c16300000.eqtg)
	e2:SetOperation(c16300000.eqop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16300000,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(TIMING_BATTLE_PHASE)
	e3:SetCondition(c16300000.condition2)
	e3:SetTarget(c16300000.target2)
	e3:SetOperation(c16300000.operation2)
	c:RegisterEffect(e3)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(16300000,2))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c16300000.handcon)
	c:RegisterEffect(e0)
end
c16300000.has_text_type=TYPE_UNION
function c16300000.thfilter(c)
	return c:IsSetCard(0x3dc6) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c16300000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16300000.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c16300000.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c16300000.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c16300000.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3dc6)
		and Duel.IsExistingMatchingCard(c16300000.eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK,0,1,nil,tp)
end
function c16300000.eqfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3dc6)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:IsFaceupEx()
end
function c16300000.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c16300000.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c16300000.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c16300000.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK)
end
function c16300000.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16300000.eqfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK,0,1,1,nil,tp)
		local sc=g:GetFirst()
		if not sc then return end
		if not Duel.Equip(tp,sc,tc) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(c16300000.eqlimit)
		sc:RegisterEffect(e1)
	end
end
function c16300000.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c16300000.condition2(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c16300000.filter(c,e,tp)
	return c:GetAttackAnnouncedCount()>0 and Duel.IsExistingMatchingCard(c16300000.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp,c)
end
function c16300000.spfilter(c,e,tp,ec)
	local op=c:GetOwner()
	return c:IsHasEffect(EFFECT_UNION_STATUS) and c:GetEquipTarget()==ec
		and Duel.GetLocationCount(op,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,op)
end
function c16300000.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c16300000.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c16300000.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c16300000.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
end
function c16300000.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local op=tc:GetOwner()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.GetLocationCount(op,LOCATION_MZONE)>0 then
		local g=Duel.GetMatchingGroup(c16300000.spfilter,tp,LOCATION_SZONE,0,nil,e,tp,tc)
		if Duel.SpecialSummon(g,0,tp,op,false,false,POS_FACEUP)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EXTRA_ATTACK)
			e1:SetValue(tc:GetAttackAnnouncedCount())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
function c16300000.hcfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x3dc6)
end
function c16300000.handcon(e)
	return not Duel.IsExistingMatchingCard(c16300000.hcfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end