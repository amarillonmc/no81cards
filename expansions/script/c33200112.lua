--幻梦灵兽 胡地
function c33200112.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33200112)
	e1:SetCondition(c33200112.spcon1)
	e1:SetTarget(c33200112.sptg)
	e1:SetOperation(c33200112.spop)
	c:RegisterEffect(e1) 
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(c33200112.spcon2)
	c:RegisterEffect(e3) 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,33200113)
	e2:SetCondition(c33200112.ngcon)
	e2:SetTarget(c33200112.ngtg)
	e2:SetOperation(c33200112.ngop)
	c:RegisterEffect(e2)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33200112,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,33200112)
	e4:SetTarget(c33200112.thtg)
	e4:SetOperation(c33200112.thop)
	c:RegisterEffect(e4)
end

--e1
function c33200112.spfilter(c,e,tp,ft)
	return c:IsFaceup() and c:IsSetCard(0x324) and not c:IsCode(33200112) and c:IsAbleToHand()
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
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c33200112.spfilter,tp,LOCATION_MZONE,0,1,1,c,e,tp,ft)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c33200112.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if tc and tc:IsRelateToEffect(e) and ft>-1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end
end

--e2
function c33200112.ngcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x324)
end
function c33200112.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
end
function c33200112.ngop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) then
		local g=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		local tc=g:GetFirst()
		if tc then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
			end
		end
	end
end

--e4
function c33200112.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c33200112.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local dg=Duel.GetDecktopGroup(tp,1)
	local dgc=dg:GetFirst()
	if dgc:IsSetCard(0x324) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end