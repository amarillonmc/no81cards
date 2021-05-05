--卡通水精鳞-深渊昆德
function c40008490.initial_effect(c)
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c40008490.atklimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c40008490.dircon)
	c:RegisterEffect(e4)
	--set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40008490,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetTarget(c40008490.settg)
	e5:SetOperation(c40008490.setop)
	c:RegisterEffect(e5)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40008490,1))
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,40008490)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetTarget(c40008490.sptg)
	e5:SetOperation(c40008490.spop)
	c:RegisterEffect(e5)	
end
function c40008490.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c40008490.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c40008490.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c40008490.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c40008490.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c40008490.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c40008490.setfilter(c)
	return c:IsSetCard(0x62) and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable()
end
function c40008490.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008490.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c40008490.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c40008490.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
function c40008490.thfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x62) and c:IsAbleToGrave()
end
function c40008490.thfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x62) and c:IsAbleToGrave() and c:GetSequence()<5
end
function c40008490.spfilter(c,e,tp)
	return c:IsSetCard(0x62) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40008490.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		local b=false
		if ft>0 then
			b=Duel.IsExistingTarget(c40008490.thfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		else
			b=Duel.IsExistingTarget(c40008490.thfilter2,tp,LOCATION_MZONE,0,1,nil)
		end
		return b and Duel.IsExistingTarget(c40008490.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	if ft>0 then
		g1=Duel.SelectTarget(tp,c40008490.thfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	else
		g1=Duel.SelectTarget(tp,c40008490.thfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c40008490.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
	e:SetLabelObject(g1:GetFirst())
end
function c40008490.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc1,tc2=Duel.GetFirstTarget()
	if tc1~=e:GetLabelObject() then tc1,tc2=tc2,tc1 end
	if tc1:IsRelateToEffect(e) and Duel.SendtoGrave(tc1,REASON_EFFECT)>0
		and tc1:IsLocation(LOCATION_GRAVE) and tc2:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
	end
end
