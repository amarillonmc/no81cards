--幻兽佣兵团 斥候-狸猫
function c33200420.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200420,0))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c33200420.smcon)
	e1:SetTarget(c33200420.smtg)
	e1:SetOperation(c33200420.smop)
	c:RegisterEffect(e1) 
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200420,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,33200420)
	e2:SetTarget(c33200420.thtg)
	e2:SetOperation(c33200420.thop)
	c:RegisterEffect(e2)
end

--e1
function c33200420.smcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c33200420.filter(c)
	return c:IsFacedown()
end
function c33200420.smtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and c33200420.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33200420.filter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33200420,2))
	local g=Duel.SelectTarget(tp,c33200420.filter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetChainLimit(c33200420.limit(g:GetFirst()))
end
function c33200420.smop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33200420,4))
	end
end
function c33200420.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end

--e2
function c33200420.thfilter(c)
	return c:IsSetCard(0x329) and c:IsAbleToHand()
end
function c33200420.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,0,LOCATION_DECK)
end
function c33200420.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)+1
	local g2=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if g1>=g2 then g1=g2 end
	Duel.ConfirmDecktop(tp,g1)
	local g3=Duel.GetDecktopGroup(tp,g1):Filter(c33200420.thfilter,nil)
	if g3:GetCount()==0 then return end
	if g3:GetCount()>=3 and Duel.SelectYesNo(tp,aux.Stringid(33200420,3)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g3:FilterSelect(tp,c33200420.thfilter,2,2,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
	else 
		local sg=g3:FilterSelect(tp,c33200420.thfilter,1,1,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33200420.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33200420.splimit(e,c)
	return not c:IsSetCard(0x329)
end
