--芳青之梦 猫之教义
function c21113855.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(c21113855.actcon)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21113855,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,21113855)
	e2:SetTarget(c21113855.tg)
	e2:SetOperation(c21113855.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21113855,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,21113856)
	e3:SetTarget(c21113855.tg3)
	e3:SetOperation(c21113855.op3)
	c:RegisterEffect(e3)
end
function c21113855.act(c)
	return c:IsFaceup() and c:IsSetCard(0xc914) and c:IsDisabled()
end
function c21113855.actcon(e)
	return Duel.IsExistingMatchingCard(c21113855.act,e:GetHandlerPlayer(),4,0,1,nil)
end
function c21113855.e(c,e,tp)
	return c:IsFaceupEx() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,4)>0
end
function c21113855.tg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c21113855.e,tp,0x30,0,1,nil,e,tp) end
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21113855.e,tp,0x30,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0x30)
end
function c21113855.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end	
function c21113855.q(c)
	return c:IsFaceup() and c:IsSetCard(0xc914)
end
function c21113855.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21113855.q,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(3,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(11,tp,fd)
	local seq=math.log(fd,2)
	e:SetLabel(seq)
end
function c21113855.move(c,seq)
	if not c21113855.q(c) then return end
	if c:IsFacedown() then return end
	if c:GetSequence()~=seq then 
		return true
	else return end
end
function c21113855.seq(c,seq)
	if c:GetSequence()==seq then 
		return true
	else return end
end
function c21113855.w(c,e,tp,cg)
	local g=Duel.GetFieldGroup(tp,0,12)
	return #g>0
end
function c21113855.op3(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabel()
	Duel.Hint(3,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c21113855.move,tp,LOCATION_MZONE,0,1,1,nil,seq):GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
	local oc=Duel.GetMatchingGroup(c21113855.seq,tp,LOCATION_MZONE,0,nil,seq):GetFirst()
	if oc then Duel.Destroy(oc,REASON_RULE) end
	Duel.MoveSequence(tc,seq)
	Duel.AdjustAll()
	local cg=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		if #cg>0 and Duel.SelectYesNo(tp,aux.Stringid(21113855,2)) then
		Duel.BreakEffect()
		Duel.Destroy(cg,REASON_EFFECT)
		end
	end	
end