--钢战-流星的痕迹
function c82557947.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82557947,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c82557947.thcon)
	e2:SetTarget(c82557947.thtg)
	e2:SetOperation(c82557947.thop)
	c:RegisterEffect(e2)
end
function c82557947.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x829) and c:IsControler(tp) 
end
function c82557947.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c82557947.cfilter,1,nil,tp)
end
function c82557947.tgfilter(c,tp,eg)
	return eg:IsContains(c) and Duel.IsExistingMatchingCard(c82557947.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute(),c:GetCode(),c:GetAttack())
end
function c82557947.thfilter(c,att,code,atk)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(att) and c:IsAbleToHand() and not c:IsCode(code) and c:IsAttackAbove(atk) 
end
function c82557947.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c82557947.tgfilter(chkc,tp,eg) end
	if chk==0 then return Duel.IsExistingTarget(c82557947.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp,eg)
		and Duel.GetFlagEffect(tp,82557947)==0 end
	Duel.RegisterFlagEffect(tp,82557947,RESET_CHAIN,0,1)
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c82557947.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,eg)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c82557947.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local att=tc:GetAttribute()
		local code=tc:GetCode()
		local atk=tc:GetAttack()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c82557947.thfilter,tp,LOCATION_DECK,0,1,1,nil,att,code,atk)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_FIELD)
			e0:SetCode(EFFECT_CANNOT_TO_HAND)
			e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e0:SetTargetRange(1,0)
			e0:SetTarget(c82557947.thlimit)
			e0:SetLabel(att)
			e0:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e0,tp)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c82557947.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c82557947.thlimit(e,c,tp,re)
	return c:IsAttribute(e:GetLabel()) and re and re:GetHandler():IsCode(82557947)
end
function c82557947.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end