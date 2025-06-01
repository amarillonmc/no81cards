--人理之基 大黑天
function c22023120.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023120,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22023120)
	e1:SetCondition(c22023120.spcon1)
	e1:SetTarget(c22023120.sptg1)
	e1:SetOperation(c22023120.spop1)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023120,1))
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22023121)
	e2:SetTarget(c22023120.retg)
	e2:SetOperation(c22023120.recop)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023120,3))
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22023121)
	e3:SetCondition(c22023120.erescon)
	e3:SetCost(c22023120.erecost)
	e3:SetTarget(c22023120.retg)
	e3:SetOperation(c22023120.recop)
	c:RegisterEffect(e3)
end
c22023120.effect_with_darkguda=true
function c22023120.cfilter(c)
	return c:IsFaceup() and c:IsCode(22020000) and c:GetOriginalAttribute()==ATTRIBUTE_DARK 
end
function c22023120.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22023120.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22023120.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22023120.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c22023120.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22023120.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22023120.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22023120.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c22023120.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SelectOption(tp,aux.Stringid(22023120,2))
	local tc=Duel.GetFirstTarget()
end
function c22023120.atkfilter(c)
	return c:IsFaceup() and (c:IsAttackAbove(0) or c:IsDefenseAbove(0)) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c22023120.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e3:SetLabel(3)
	e3:SetValue(c22023120.effectfilter)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetLabel(4)
	Duel.RegisterEffect(e4,tp)
	e3:SetLabelObject(e4)
	e4:SetLabelObject(tc)
	local ct=Duel.GetMatchingGroupCount(c22023120.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Recover(tp,ct*500,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c22023120.atkfilter,tp,0,LOCATION_MZONE,1,nil) then
		local g=Duel.GetMatchingGroup(c22023120.atkfilter,tp,0,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-100)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end
function c22023120.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local label=e:GetLabel()
	local tc
	if label==3 then
		tc=e:GetLabelObject():GetLabelObject()
	else
		tc=e:GetLabelObject()
	end
	return tc and tc==te:GetHandler()
end
function c22023120.erescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22023120.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end