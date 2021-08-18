--幻梦灵兽 胡地
function c33200112.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33200112)
	e1:SetCondition(c33200112.spcon1)
	e1:SetTarget(c33200112.sptg)
	e1:SetOperation(c33200112.spop)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c33200112.spcon2)
	c:RegisterEffect(e2) 

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200112,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,33200113)
	e3:SetTarget(c33200112.settg)  
	e3:SetOperation(c33200112.setop)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33200112,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c33200112.descon)
	e4:SetTarget(c33200112.destg)
	e4:SetOperation(c33200112.desop)
	c:RegisterEffect(e4)
end

--e1
function c33200112.spfilter(c,e,tp,ft)
	return c:IsFaceup() and c:IsSetCard(0x324) and not c:IsCode(33200112) 
		and (ft>0 or c:GetSequence()<5) and not c:IsType(TYPE_XYZ)
end
function c33200112.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingTarget(c33200112.spfilter,tp,LOCATION_MZONE,0,1,c,e,tp,ft)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and not Duel.IsPlayerAffectedByEffect(tp,33200100)
end
function c33200112.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingTarget(c33200112.spfilter,tp,LOCATION_MZONE,0,1,c,e,tp,ft)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and Duel.IsPlayerAffectedByEffect(tp,33200100) 
end
function c33200112.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c33200112.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33200112.spfilter,tp,LOCATION_MZONE,0,1,c,e,tp,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c33200112.spfilter,tp,LOCATION_MZONE,0,1,1,c,e,tp,ft)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c33200112.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if tc and tc:IsRelateToEffect(e) and ft>-1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end
end
--e3
function c33200112.setfilter(c)
	return c:IsCode(33200104) and c:IsSSetable()
end
function c33200112.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200112.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c33200112.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c33200112.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
--e4
function c33200112.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetAttacker()
	local tc=Duel.GetAttackTarget()
	return ac and ac:IsControler(tp) and ac:IsFaceup() and ac==c
end
function c33200112.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE+LOCATION_FZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_SZONE+LOCATION_FZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_SZONE+LOCATION_FZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c33200112.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end