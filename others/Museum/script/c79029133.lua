--维多利亚·狙击干员-梅
function c79029133.initial_effect(c)
	--SpecialSummon 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,79029133)
	e1:SetTarget(c79029133.sptg)
	e1:SetOperation(c79029133.spop)
	c:RegisterEffect(e1)
	--disable 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029133,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,09029133)
	e2:SetTarget(c79029133.negtg)
	e2:SetOperation(c79029133.negop)
	c:RegisterEffect(e2)
end
function c79029133.ckfil(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xa900)
end
function c79029133.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c79029133.ckfil,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SelectTarget(tp,c79029133.ckfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c79029133.ckfil2(c)
	return c:GetSequence()<5
end
function c79029133.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0x4902) and c:IsType(TYPE_MONSTER)
end
function c79029133.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Debug.Message("犯罪分子们，给我束手就擒吧！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029133,0))
	if not Duel.IsExistingMatchingCard(c79029133.ckfil2,tp,LOCATION_MZONE,0,1,c) and Duel.IsExistingMatchingCard(c79029133.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79029133,4)) then 
	Debug.Message("现场搜查！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029133,2))
	local sg=Duel.SelectMatchingCard(tp,c79029133.thfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	end
	end
end
function c79029133.negfilter(c)
	return aux.disfilter1(c)
end
function c79029133.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c79029133.negfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029133.negfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c79029133.negfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetLabel(ev)
	e1:SetCountLimit(1)
	e1:SetCondition(c79029133.cicon)
	e1:SetOperation(c79029133.ciop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c79029133.cicon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()+2==ev and Duel.IsPlayerCanDraw(tp,1) and rp==1-tp 
end
function c79029133.ciop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(79029133,5)) then 
	Debug.Message("这是一次警告！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029133,3))  
	Duel.Draw(tp,1,REASON_EFFECT)
	end
	e:Reset()
end
function c79029133.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
	Debug.Message("掏出你们的证件！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029133,1))
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end
end













