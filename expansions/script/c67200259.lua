--封缄的瞌睡法师 米库莉
function c67200259.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200259,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200259)
	e1:SetCost(c67200259.thcost)
	e1:SetTarget(c67200259.thtg)
	e1:SetOperation(c67200259.thop)
	c:RegisterEffect(e1)  
	--cant attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	--e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)  
	--Disable
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3)
	--equip 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200259,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,67200260)
	e4:SetTarget(c67200259.eqtg)
	e4:SetOperation(c67200259.eqop)
	c:RegisterEffect(e4)
end
function c67200259.spfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x674) and c:IsReleasable()
end
function c67200259.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c67200259.spfilter1,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,c67200259.spfilter1,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c67200259.thfilter(c)
	return c:IsSetCard(0x674) and not c:IsCode(67200259) and c:IsAbleToHand()
end
function c67200259.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200259.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c67200259.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200259.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c67200259.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c67200259.eqfilter(c)
	return c:IsSetCard(0x674) and c:IsType(TYPE_PENDULUM) and c:IsLevelBelow(4)
end
function c67200259.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c67200259.tgfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c67200259.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c67200259.eqfilter,tp,LOCATION_EXTRA+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	Duel.SelectTarget(tp,c67200259.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA+LOCATION_MZONE+LOCATION_GRAVE)
end
function c67200259.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67200259.eqfilter),tp,LOCATION_EXTRA+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
		local ec=g:GetFirst()
		if ec then
			if not Duel.Equip(tp,ec,tc) then return end
			--equip limit
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_EQUIP_LIMIT)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e4:SetLabelObject(tc)
			e4:SetValue(c67200259.eqlimit)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e4)
		end
	end
end
function c67200259.eqlimit(e,c)
	return c==e:GetLabelObject()
end

