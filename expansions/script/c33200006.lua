--锻溶工匠 恒温造渣员
function c33200006.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,c33200006.ffilter1,c33200006.ffilter2)
	--token set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200006,0))
	e1:SetCategory(CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c33200006.damcon)
	e1:SetTarget(c33200006.tktg)
	e1:SetOperation(c33200006.tkop)
	c:RegisterEffect(e1) 
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200006,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c33200006.descost)
	e3:SetTarget(c33200006.destg)
	e3:SetOperation(c33200006.desop)
	c:RegisterEffect(e3)
end

--fusion
function c33200006.ffilter1(c)
	return c:IsSetCard(0x321)
end
function c33200006.ffilter2(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAttribute(ATTRIBUTE_FIRE)
end

--e1
function c33200006.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c33200006.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c33200006.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local token=Duel.CreateToken(tp,33200009)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e1:SetValue(TYPE_CONTINUOUS+TYPE_SPELL)
	token:RegisterEffect(e1)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end

--e2
function c33200006.thfilter(c)
	return c:IsSetCard(0x321) and c:IsAbleToHand()
end
function c33200006.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsReleasable()
end
function c33200006.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200008.tgfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c33200008.tgfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c33200006.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c33200006.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT) then 
			Duel.BreakEffect()
			if Duel.IsExistingMatchingCard(c33200006.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33200006,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
				local g=Duel.SelectTarget(tp,c33200006.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)   
				if g:GetCount()>0 then
					local thc=g:GetFirst()
					Duel.SendtoHand(thc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,thc)
				end
			end
		end
	end
end
