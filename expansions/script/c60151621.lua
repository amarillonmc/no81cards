--破碎的命运
function c60151621.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60151621+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c60151621.target)
	e1:SetOperation(c60151621.activate)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c60151621.e2cost)
	e2:SetOperation(c60151621.e2op)
	c:RegisterEffect(e2)
end
function c60151621.filter(c,tp)
	local lv=c:GetOriginalLevel()
	local rk=c:GetOriginalRank()
	return c:IsFaceup() and c:IsSetCard(0xcb25) and (c:IsType(TYPE_MONSTER) or c:IsLocation(LOCATION_PZONE)) and Duel.IsExistingMatchingCard(c60151621.pcfilter,tp,LOCATION_DECK,0,1,nil,lv,rk)
end
function c60151621.pcfilter(c,lv,rk)
	return c:IsSetCard(0xcb25) and c:IsType(TYPE_PENDULUM) and (not c:IsForbidden() or c:IsAbleToHand()) and (c:GetLevel()==lv or c:GetLevel()==rk)
end
function c60151621.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c60151621.filter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.SelectTarget(tp,c60151621.filter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,1,nil,tp)
end
function c60151621.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lv=tc:GetOriginalLevel()
	local rk=tc:GetOriginalRank()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local g=Duel.SelectMatchingCard(tp,c60151621.pcfilter,tp,LOCATION_DECK,0,1,2,nil,lv,rk)
		local pc=g:GetFirst()
		while pc do
			if pc:IsAbleToHand() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
				if Duel.SelectYesNo(tp,aux.Stringid(60151621,0)) then
					Duel.SendtoHand(pc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,pc)
				else
					Duel.MoveToField(pc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
				end
			elseif pc:IsAbleToHand() and not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
				Duel.SendtoHand(pc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,pc)
			else
				Duel.MoveToField(pc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
			pc=g:GetNext()
		end
	end
end
function c60151621.cfilter(c)
	return c:IsSetCard(0xcb25) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function c60151621.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c60151621.cfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c60151621.cfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c60151621.e2op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end