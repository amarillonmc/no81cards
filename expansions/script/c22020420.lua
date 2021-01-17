--人理之基 吾之神明在此
function c22020420.initial_effect(c)
	c:SetUniqueOnField(1,0,22020420)
	aux.AddCodeList(c,22020410)
	--change effect type
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(22020420)
	e0:SetRange(LOCATION_SZONE)
	e0:SetTargetRange(1,0)
	c:RegisterEffect(e0)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22020420,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22020420.condition)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020420,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,22020420)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c22020420.cost)
	e2:SetCondition(c22020420.discon)
	e2:SetTarget(c22020420.distg)
	e2:SetOperation(c22020420.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(22020420,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,22020420)
	c:RegisterEffect(e3)
end
function c22020420.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Debug.Message("主的力量降临于此！")
end
function c22020420.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c22020420.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c22020420.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xff1) and c:IsCanTurnSet()
end
function c22020420.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc~=c and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c22020420.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22020420.filter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c22020420.filter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c22020420.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
			Duel.SendtoGrave(eg,REASON_EFFECT)
		end
		local tc=Duel.GetFirstTarget()
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Debug.Message("我之旗帜啊，请保护我的同胞们！")
			Debug.Message("吾主在此！")
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		end
	end
end
