--鹰身信徒
function c56585888.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,76812113,LOCATION_MZONE+LOCATION_GRAVE)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(56585888,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,56585888)
	e1:SetTarget(c56585888.lvtg)
	e1:SetOperation(c56585888.lvop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(56585888,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,56585889)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c56585888.target)
	e2:SetOperation(c56585888.operation)
	c:RegisterEffect(e2)
end
function c56585888.filter(c,clv,catk,cdef)
	return c:IsSetCard(0x64) and c:IsLevelAbove(4) and not c:IsLevel(clv) and not c:IsAttack(catk) and not c:IsDefense(cdef)
		and ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_GRAVE))
end
function c56585888.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c56585888.filter(chkc,e:GetHandler():GetLevel()) end
	if chk==0 then return Duel.IsExistingTarget(c56585888.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,e:GetHandler(),e:GetHandler():GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c56585888.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,e:GetHandler(),e:GetHandler():GetLevel(),e:GetHandler():GetAttack(),e:GetHandler():GetDefense())
end
function c56585888.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e)
		and (not tc:IsLocation(LOCATION_MZONE) or tc:IsFaceup()) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_ATTACK)
		e2:SetValue(tc:GetAttack())
		c:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_SET_DEFENSE)
		e3:SetValue(tc:GetDefense())
		c:RegisterEffect(e3)
		
	end
end
function c56585888.thfilter(c)
	return c:IsSetCard(0x64) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c56585888.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsSetCard(0x64) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c56585888.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c56585888.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c56585888.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.GetMZoneCount(tp,e:GetHandler())>1
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(56585888,2),aux.Stringid(56585888,3))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(56585888,2))
	else op=Duel.SelectOption(tp,aux.Stringid(56585888,3))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
	end
end
function c56585888.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c56585888.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
		local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(c56585888.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if g:GetCount()>=2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,2,2,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
