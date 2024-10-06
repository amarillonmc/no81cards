--芳青之梦 柳梢妃
function c21113840.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DISABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	e0:SetCondition(c21113840.discon)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,21113840)
	e1:SetCost(c21113840.cost)
	e1:SetTarget(c21113840.tg)
	e1:SetOperation(c21113840.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_GRAVE_SPSUMMON+CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21113841)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c21113840.cost2)
	e2:SetTarget(c21113840.tg2)
	e2:SetOperation(c21113840.op2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(21113840,ACTIVITY_SPSUMMON,c21113840.counter)	
end
function c21113840.counter(c)
	return c:IsSetCard(0xc914)
end
function c21113840.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()~=2
end
function c21113840.t(c)
	return c:IsSetCard(0xc914) and c:IsDiscardable()
end
function c21113840.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(21113840,tp,ACTIVITY_SPSUMMON)==0 and Duel.IsExistingMatchingCard(c21113840.t,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,c21113840.t,1,1,REASON_COST+REASON_DISCARD,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTarget(c21113840.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetCountLimit(1)
	e2:SetOperation(c21113840.opq)
	Duel.RegisterEffect(e2,tp)
end
function c21113840.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xc914)
end
function c21113840.q(c)
	return c:IsSetCard(0xc914) and c:IsType(1) and c:IsAbleToHand() and not c:IsCode(21113840)
end
function c21113840.opq(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,21113840)==0 and Duel.IsExistingMatchingCard(c21113840.q,tp,1,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(21113840,1)) then
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21113840.q,tp,1,0,1,1,nil)
		if #g>0 then		
		Duel.SendtoHand(g,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,g)
		end
	end
	Duel.ResetFlagEffect(tp,21113840)
	e:Reset()
end
function c21113840.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,4)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function c21113840.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21113840,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and not c:IsType(TYPE_TUNER) and c:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(21113840,0)) then
	Duel.BreakEffect()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_TUNER)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
	end
end
function c21113840.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(21113840,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTarget(c21113840.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetCountLimit(1)
	e2:SetOperation(c21113840.opw)
	Duel.RegisterEffect(e2,tp)
end
function c21113840.r(c)
	return c:IsSetCard(0xc914) and c:IsType(1) and c:IsAbleToGrave()
end
function c21113840.opw(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,21113840+1)==0 and Duel.IsExistingMatchingCard(c21113840.r,tp,1,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(21113840,1)) then
	Duel.Hint(3,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21113840.r,tp,1,0,1,1,nil)
		if #g>0 then		
		Duel.SendtoGrave(g,REASON_RULE)
		end
	end
	Duel.ResetFlagEffect(tp,21113840+1)
	e:Reset()
end
function c21113840.w(c)
	return c:IsSetCard(0xc914) and c:IsFaceup() and c:IsAbleToGrave()
end
function c21113840.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c21113840.w,tp,12,0,1,nil) end
	Duel.Hint(3,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c21113840.w,tp,12,0,1,1,nil)	
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c21113840.e(c,e,tp)
	return c:IsSetCard(0xc914) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,4)>0 and not c:IsCode(21113840)
end
function c21113840.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21113840+1,RESET_PHASE+PHASE_END,0,1)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(0x10) and Duel.IsExistingMatchingCard(c21113840.e,tp,0x10,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(21113840,2)) then
	Duel.BreakEffect()
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21113840.e,tp,0x10,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end