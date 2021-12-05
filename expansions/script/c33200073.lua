--铁战灵兽 M波士可多拉
function c33200073.initial_effect(c)
	aux.AddCodeList(c,33200071) 
	--spesm
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x322),9,99,c33200073.ovfilter,aux.Stringid(33200073,0),99,c33200073.xyzop)
	c:EnableReviveLimit()   
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c33200073.disable)
	e1:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e1) 
	--ReturnToField
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCountLimit(1,33200073)
	e2:SetCondition(c33200073.spcon1)
	e2:SetTarget(c33200073.sptg)
	e2:SetOperation(c33200073.spop)
	c:RegisterEffect(e2) 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT__LEAVE_FIELD)
	e4:SetCountLimit(1,33200073)
	e4:SetCondition(c33200073.spcon2)
	e4:SetTarget(c33200073.sptg)
	e4:SetOperation(c33200073.spop)
	c:RegisterEffect(e4) 
	--battle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200073,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c33200073.bacost)
	e3:SetTarget(c33200073.batg)
	e3:SetOperation(c33200073.baop)
	c:RegisterEffect(e3)
end

--xyz
function c33200073.ovfilter(c)
	return c:IsFaceup() and c:IsCode(33200071)
end
function c33200073.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x323)
end
function c33200073.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,33200052)==0
	and Duel.IsExistingMatchingCard(c33200073.xyzfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.RegisterFlagEffect(tp,33200052,nil,EFFECT_FLAG_OATH,1)
end

--e1
function c33200073.disable(e,c)
	local seq=aux.MZoneSequence(c:GetSequence())
	return Duel.IsExistingMatchingCard(c33200073.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,seq)
end
function c33200073.cfilter(c,seq2)
	local seq1=aux.MZoneSequence(c:GetSequence())
	return c:IsFaceup() and c:IsSetCard(0x322) and seq1==4-seq2
end

--e2
function c33200073.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE) 
end
function c33200073.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp and (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED))
end
function c33200073.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33200073.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end


--e3
function c33200073.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x322)
end
function c33200073.bacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33200073.batg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200073.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c33200073.baop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c33200073.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(300)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end