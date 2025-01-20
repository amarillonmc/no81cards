--花开有序 风不误信
function c16372018.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c16372018.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--recover
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(16372018,1))
	e21:SetCategory(CATEGORY_RECOVER)
	e21:SetType(EFFECT_TYPE_IGNITION)
	e21:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e21:SetRange(LOCATION_FZONE)
	e21:SetCountLimit(1,16372018)
	e21:SetCondition(c16372018.con)
	e21:SetLabel(1)
	e21:SetTarget(c16372018.rectg)
	e21:SetOperation(c16372018.recop)
	c:RegisterEffect(e21)
	--search
	local e22=Effect.CreateEffect(c)
	e22:SetDescription(aux.Stringid(16372018,2))
	e22:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e22:SetType(EFFECT_TYPE_IGNITION)
	e22:SetRange(LOCATION_FZONE)
	e22:SetCountLimit(1,16372018+100)
	e22:SetCondition(c16372018.con)
	e22:SetLabel(2)
	e22:SetCost(c16372018.thcost)
	e22:SetTarget(c16372018.thtg)
	e22:SetOperation(c16372018.thop)
	c:RegisterEffect(e22)
	--negate
	local e23=Effect.CreateEffect(c)
	e23:SetDescription(aux.Stringid(16372018,3))
	e23:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e23:SetType(EFFECT_TYPE_QUICK_O)
	e23:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e23:SetCode(EVENT_CHAINING)
	e23:SetRange(LOCATION_FZONE)
	e23:SetCountLimit(1,16372018+200)
	e23:SetCondition(c16372018.negcon)
	e23:SetCost(c16372018.negcost)
	e23:SetLabel(3)
	e23:SetTarget(c16372018.negtg)
	e23:SetOperation(c16372018.negop)
	c:RegisterEffect(e23)
	--set
	local e24=Effect.CreateEffect(c)
	e24:SetDescription(aux.Stringid(16372018,4))
	e24:SetCategory(CATEGORY_DRAW)
	e24:SetType(EFFECT_TYPE_IGNITION)
	e24:SetRange(LOCATION_FZONE)
	e24:SetCountLimit(1,16372018+300)
	e24:SetCondition(c16372018.con)
	e24:SetLabel(4)
	e24:SetTarget(c16372018.settg)
	e24:SetOperation(c16372018.setop)
	c:RegisterEffect(e24)
	--SpecialSummon
	local e25=Effect.CreateEffect(c)
	e25:SetDescription(aux.Stringid(16372018,5))
	e25:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e25:SetType(EFFECT_TYPE_IGNITION)
	e25:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e25:SetRange(LOCATION_FZONE)
	e25:SetCountLimit(1,16372018+400)
	e25:SetCondition(c16372018.con)
	e25:SetLabel(5)
	e25:SetTarget(c16372018.target)
	e25:SetOperation(c16372018.activate)
	c:RegisterEffect(e25)
end
function c16372018.indfilter(c)
	return c:IsSetCard(0xdc1) and c:IsFaceup() and c:GetSequence()<5
end
function c16372018.indcon(e)
	return Duel.IsExistingMatchingCard(c16372018.indfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
function c16372018.ckfilter(c,type)
	return c:IsFaceup() and c:IsSetCard(0xdc1) and c:GetOriginalType()&type>0 and c:GetSequence()<5
end
function c16372018.con(e,tp,eg,ep,ev,re,r,rp)
	local ck=0
	if Duel.IsExistingMatchingCard(c16372018.ckfilter,tp,LOCATION_SZONE,0,1,nil,TYPE_RITUAL) then ck=ck+1 end
	if Duel.IsExistingMatchingCard(c16372018.ckfilter,tp,LOCATION_SZONE,0,1,nil,TYPE_FUSION) then ck=ck+1 end
	if Duel.IsExistingMatchingCard(c16372018.ckfilter,tp,LOCATION_SZONE,0,1,nil,TYPE_SYNCHRO) then ck=ck+1 end
	if Duel.IsExistingMatchingCard(c16372018.ckfilter,tp,LOCATION_SZONE,0,1,nil,TYPE_XYZ) then ck=ck+1 end
	if Duel.IsExistingMatchingCard(c16372018.ckfilter,tp,LOCATION_SZONE,0,1,nil,TYPE_LINK) then ck=ck+1 end
	return ck>=e:GetLabel()
end
function c16372018.recfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xdc1) and c:IsLevel(3) and c:GetAttack()>0
end
function c16372018.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c16372018.recfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16372018.recfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c16372018.recfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function c16372018.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
end
function c16372018.costfilter(c,tp)
	return c:IsSetCard(0xdc1) and c:GetOriginalType()&TYPE_MONSTER>0 and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c16372018.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c16372018.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16372018.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp) end
	local g=Duel.SelectMatchingCard(tp,c16372018.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
end
function c16372018.thfilter(c,code)
	return c:IsSetCard(0xdc1) and not c:IsCode(code) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c16372018.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c16372018.thop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c16372018.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c16372018.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and c16372018.con(e)
end
function c16372018.negcostfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xdc1) and c:IsAbleToGraveAsCost()
end
function c16372018.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16372018.negcostfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c16372018.negcostfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c16372018.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c16372018.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c16372018.setfilter(c,eg)
	return c:IsSetCard(0xdc1) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c16372018.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c16372018.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c16372018.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c16372018.setfilter,tp,LOCATION_GRAVE,0,1,1,nil,eg):GetFirst()
	if tc and Duel.MoveToField(tc,tp,p,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc:RegisterEffect(e1)
		Duel.BreakEffect()
		Duel.Draw(tp,1,0x40)
	end
end
function c16372018.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xdc1)
end
function c16372018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c16372018.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c16372018.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c16372018.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c16372018.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end