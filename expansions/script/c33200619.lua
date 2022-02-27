--圣剑教堂 所罗门神殿
function c33200619.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33200621+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--ritual summon
	local e2=aux.AddRitualProcGreater2(c,c33200619.filter,LOCATION_HAND,nil,nil,true)
	e2:SetDescription(aux.Stringid(33200619,0))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--level change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200619,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,33200619)
	e3:SetTarget(c33200619.lvtg)
	e3:SetOperation(c33200619.lvop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33200619,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,33200620)
	e4:SetCondition(c33200619.thcon)
	e4:SetTarget(c33200619.thtg)
	e4:SetOperation(c33200619.thop)
	c:RegisterEffect(e4)
end

--e2
function c33200619.filter(c,e,tp,chk)
	return c:IsSetCard(0x5329)
end

--e3
function c33200619.lvfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x5329) and c:IsType(TYPE_MONSTER)
end
function c33200619.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33200619.lvfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33200619.lvfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c33200619.lvfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c33200619.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local op=0
		if tc:IsLevelBelow(2) then 
			op=0
		else
			op=Duel.SelectOption(tp,aux.Stringid(33200619,3),aux.Stringid(33200619,4))
		end
		if op==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		else
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_LEVEL)
			e2:SetValue(-2)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end

--e4
function c33200619.tgcfilter(c,tp,rp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp and c:IsPreviousSetCard(0x5329)
		and c:IsReason(REASON_RELEASE) and c:GetLevel()>=3
end
function c33200619.thfilter2(c,lv)
	return c:IsSetCard(0x5329) and c:IsAbleToHand() and c:IsLevel(lv)
end
function c33200619.thfilter(c)
	return Duel.IsExistingMatchingCard(c33200619.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetLevel()-2)
end
function c33200619.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33200619.tgcfilter,1,nil,tp,rp)
end
function c33200619.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local sg=eg:Filter(c33200619.tgcfilter,nil,tp,rp)
	if chk==0 then return sg:IsExists(c33200619.thfilter,1,nil) end
	local slg=sg:Filter(c33200619.thfilter,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=slg:Select(tp,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33200619.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.IsExistingMatchingCard(c33200619.thfilter2,tp,LOCATION_DECK,0,1,nil,tc:GetLevel()-2) then
		local thg=Duel.SelectMatchingCard(tp,c33200619.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel()-2)
		if thg:GetCount()>0 then
			Duel.SendtoHand(thg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,thg)
		end
	end
end

