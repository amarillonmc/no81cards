--芳青之梦 颂枝谣
function c21113800.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DISABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	e0:SetCondition(c21113800.discon)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,21113800)
	e1:SetCost(c21113800.cost)
	e1:SetTarget(c21113800.tg)
	e1:SetOperation(c21113800.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,21113801)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(c21113800.cost2)
	e2:SetOperation(c21113800.op2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(21113800,ACTIVITY_SPSUMMON,c21113800.counter)	
end
function c21113800.counter(c)
	return c:IsSetCard(0xc904)
end
function c21113800.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()~=2
end
function c21113800.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(21113800,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTarget(c21113800.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetCountLimit(1)
	e2:SetOperation(c21113800.op0)
	Duel.RegisterEffect(e2,tp)
end
function c21113800.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xc904)
end
function c21113800.op0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,21113800)==0 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,12,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(21113800,0)) then
	Duel.Hint(3,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,12,1,1,nil)
		if #g>0 then
		Duel.HintSelection(g)		
		Duel.SendtoGrave(g,REASON_RULE)
		end
	end
	Duel.ResetFlagEffect(tp,21113800)
	e:Reset()
end
function c21113800.q(c)
	return c:IsFaceup() and c:IsSetCard(0xc904)
end
function c21113800.w(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,4)>0 and c:IsSetCard(0xc904) and not c:IsCode(21113800)
end
function c21113800.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21113800.q,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,4)>0 and Duel.IsExistingMatchingCard(c21113800.w,tp,1,0,1,nil,e,tp) end
	Duel.Hint(3,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(11,tp,fd)
	local seq=math.log(fd,2)
	e:SetLabel(seq)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,1)
end
function c21113800.move(c,seq)
	if not c21113800.q(c) then return end
	if c:IsFacedown() then return end
	if c:GetSequence()~=seq then 
		return true
	else return end
end
function c21113800.seq(c,seq)
	if c:GetSequence()==seq then 
		return true
	else return end
end
function c21113800.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21113800,RESET_PHASE+PHASE_END,0,1)
	local seq=e:GetLabel()
	Duel.Hint(3,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c21113800.move,tp,LOCATION_MZONE,0,1,1,nil,seq):GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
	local oc=Duel.GetMatchingGroup(c21113800.seq,tp,LOCATION_MZONE,0,nil,seq):GetFirst()
	if oc then Duel.Destroy(oc,REASON_RULE) end
	Duel.MoveSequence(tc,seq)
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21113800.w,tp,1,0,1,1,nil,e,tp)
		if #g>0 then 
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end	
end
function c21113800.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(21113800,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTarget(c21113800.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c21113800.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetValue(c21113800.val0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetValue(c21113800.val0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c21113800.val0(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():GetSequence()>=5 and bit.band(loc,LOCATION_MZONE)~=0
end