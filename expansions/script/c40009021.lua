--机空队 炎天一式
function c40009021.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c40009021.matfilter,1,1) 
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009021,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,40009021)
	e2:SetCondition(c40009021.thcon)
	e2:SetTarget(c40009021.eqtg)
	e2:SetOperation(c40009021.eqop)
	c:RegisterEffect(e2)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009021,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,40009022)
	e1:SetCost(c40009021.descost)
	e1:SetTarget(c40009021.rmtg)
	e1:SetOperation(c40009021.rmop)
	c:RegisterEffect(e1)
end
function c40009021.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c40009021.matfilter(c)
	return not c:IsLink(1) and c:GetBaseAttack()==0 and c:IsType(TYPE_EFFECT)
end
function c40009021.eqfilter(c,tp)
	return c:IsType(TYPE_QUICKPLAY) and c:IsSetCard(0xf13) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c40009021.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c40009021.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND)
end
function c40009021.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c40009021.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c40009021.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c40009021.eqlimit(e,c)
	return e:GetOwner()==c
end
function c40009021.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf13) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c40009021.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009021.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	if Duel.IsExistingMatchingCard(c40009021.costfilter,tp,LOCATION_ONFIELD,0,1,nil)
		 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c40009021.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c40009021.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c40009021.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c40009021.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40009021.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c40009021.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c40009021.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c40009021.retcon)
		e1:SetOperation(c40009021.retop)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		--[[local reset=0
		if tc:IsControler(tp) then
			reset=RESET_OPPO_TURN
		else
			reset=RESET_SELF_TURN
		end
		if Duel.GetTurnPlayer()==1-tp then
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
			e1:SetValue(Duel.GetTurnCount())
			tc:RegisterFlagEffect(40009021,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+reset,0,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			e1:SetValue(0)
			tc:RegisterFlagEffect(40009021,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+reset,0,1)
		end--]]
		if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_END then
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
			e1:SetValue(Duel.GetTurnCount())
			tc:RegisterFlagEffect(40009021,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			e1:SetValue(0)
			tc:RegisterFlagEffect(40009021,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c40009021.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=1-tp or Duel.GetTurnCount()==e:GetValue() then return false end
	return e:GetLabelObject():GetFlagEffect(40009021)~=0
end
function c40009021.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end

