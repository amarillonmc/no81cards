--姬神的封缄英杰 艾库莉亚·菲弥琳丝
function c67200310.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--EXTRA P SUMMON ONLY ONCE
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200310,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200310)
	e1:SetCost(c67200310.epcost)
	e1:SetTarget(c67200310.eptg)
	e1:SetOperation(c67200310.epop)
	c:RegisterEffect(e1)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200310,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c67200310.eqcon)
	e4:SetTarget(c67200310.eqtg)
	e4:SetOperation(c67200310.eqop)
	c:RegisterEffect(e4)  
end
function c67200310.spfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x3674) and c:IsReleasable()
end
function c67200310.epcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c67200310.spfilter1,tp,LOCATION_ONFIELD,0,1,c) end
	local g=Duel.SelectMatchingCard(tp,c67200310.spfilter1,tp,LOCATION_ONFIELD,0,1,1,c)
	g:AddCard(c)
	Duel.Release(g,REASON_COST)
end
function c67200310.eptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c67200310.epop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200310,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCountLimit(1,67200303)
	e1:SetValue(c67200310.pendvalue)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c67200310.pendvalue(e,c)
	return c:IsLocation(LOCATION_EXTRA) and c:IsSetCard(0x3674)
end
--
function c67200310.eqfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSetCard(0x3674) and c:IsType(TYPE_MONSTER)
end
function c67200310.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200310.eqfilter,1,nil,tp)
end
function c67200310.filter(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function c67200310.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c67200310.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67200310.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c67200310.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,0,0)
end
function c67200310.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk=tc:GetBaseAttack()
		if atk<0 then atk=0 end
		if not Duel.SendtoGrave(tc,REASON_EFFECT) then return end
		if atk>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e1:SetValue(atk)
			c:RegisterEffect(e1)
		end
	end
end


