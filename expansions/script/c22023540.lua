--人理之基 布拉达曼特
function c22023540.initial_effect(c)
	aux.AddCodeList(c,22023340)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c22023540.matfilter1,nil,nil,aux.NonTuner(Card.IsSetCard,0xff1),1,99)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023540,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,22023540)
	e1:SetCondition(c22023540.thcon)
	e1:SetTarget(c22023540.thtg)
	e1:SetOperation(c22023540.thop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023540,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,22023541)
	e2:SetTarget(c22023540.distg)
	e2:SetOperation(c22023540.disop)
	c:RegisterEffect(e2)
	--negate ere
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023540,2))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,22023541)
	e3:SetCondition(c22023540.erecon)
	e3:SetCost(c22023540.erecost)
	e3:SetTarget(c22023540.distg)
	e3:SetOperation(c22023540.disop)
	c:RegisterEffect(e3)
end
function c22023540.matfilter1(c,syncard)
	return c:IsTuner(syncard) or (c:IsSetCard(0xff1) and Duel.GetFlagEffect(tp,22023340)>0)
end
function c22023540.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c22023540.filter(c)
	return c:IsSetCard(0x6ff1) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or chk and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c22023540.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local res=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)<=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		return Duel.IsExistingMatchingCard(c22023540.filter,tp,LOCATION_DECK,0,1,nil,e,tp,res)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c22023540.thop(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.GetFlagEffect(tp,22023340)>2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c22023540.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,res):GetFirst()
	if tc then
		if res and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c22023540.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and aux.NegateEffectMonsterFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c22023540.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function c22023540.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22023540.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end