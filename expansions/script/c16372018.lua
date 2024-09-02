--花开有序 风不误信
function c16372018.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PLANT))
	e1:SetValue(300)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e11)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16372018,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,16372018)
	e2:SetCost(c16372018.thcost)
	e2:SetTarget(c16372018.thtg)
	e2:SetOperation(c16372018.thop)
	c:RegisterEffect(e2)
	--recover
	local e31=Effect.CreateEffect(c)
	e31:SetDescription(aux.Stringid(16372018,1))
	e31:SetCategory(CATEGORY_RECOVER)
	e31:SetType(EFFECT_TYPE_IGNITION)
	e31:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e31:SetRange(LOCATION_FZONE)
	e31:SetCountLimit(1)
	e31:SetCondition(c16372018.con1)
	e31:SetTarget(c16372018.rectg)
	e31:SetOperation(c16372018.recop)
	c:RegisterEffect(e31)
	--set
	local e32=Effect.CreateEffect(c)
	e32:SetDescription(aux.Stringid(16372018,2))
	e32:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e32:SetCode(EVENT_LEAVE_FIELD)
	e32:SetProperty(EFFECT_FLAG_DELAY)
	e32:SetRange(LOCATION_FZONE)
	e32:SetCountLimit(1)
	e32:SetCondition(c16372018.setcon)
	e32:SetTarget(c16372018.settg)
	e32:SetOperation(c16372018.setop)
	c:RegisterEffect(e32)
	--SpecialSummon
	local e33=Effect.CreateEffect(c)
	e33:SetDescription(aux.Stringid(16372018,3))
	e33:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e33:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e33:SetType(EFFECT_TYPE_IGNITION)
	e33:SetRange(LOCATION_FZONE)
	e33:SetCountLimit(1)
	e33:SetCondition(c16372018.con3)
	e33:SetTarget(c16372018.target)
	e33:SetOperation(c16372018.activate)
	c:RegisterEffect(e33)
end
function c16372018.cfilter(c,tp)
	return c:IsSetCard(0xdc1) and c:GetOriginalType()&TYPE_MONSTER>0 and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c16372018.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c16372018.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16372018.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp) end
	local g=Duel.SelectMatchingCard(tp,c16372018.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,tp)
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
function c16372018.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xdc1) and c:GetOriginalType()&TYPE_MONSTER>0 and c:IsLevelBelow(3)
end
function c16372018.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xdc1) and c:GetOriginalType()&TYPE_FUSION>0
end
function c16372018.filter3(c)
	return c:IsFaceup() and c:IsSetCard(0xdc1) and c:GetOriginalType()&TYPE_LINK>0
end
function c16372018.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c16372018.filter1,tp,LOCATION_SZONE,0,1,nil)
end
function c16372018.recfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xdc1) and c:IsLevelBelow(4) and c:GetAttack()>0
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
function c16372018.sfilter(c)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_SZONE)
		and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xdc1)
end
function c16372018.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16372018.sfilter,1,nil)
		and Duel.IsExistingMatchingCard(c16372018.filter2,tp,LOCATION_SZONE,0,1,nil)
end
function c16372018.setfilter(c,eg)
	return c:IsSetCard(0xdc1) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and not eg:IsContains(c)
end
function c16372018.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		or Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0)
		and Duel.IsExistingMatchingCard(c16372018.setfilter,tp,LOCATION_GRAVE,0,1,nil,eg) end
end
function c16372018.setop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
	local p=aux.SelectFromOptions(tp,{b1,aux.Stringid(16372000+1,5),tp},{b2,aux.Stringid(16372000+1,6),1-tp})
	if p~=nil then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c16372018.setfilter,tp,LOCATION_GRAVE,0,1,1,nil,eg):GetFirst()
		if tc then
			if Duel.MoveToField(tc,tp,p,LOCATION_SZONE,POS_FACEUP,true) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				tc:RegisterEffect(e1)
			end
		end
	end
end
function c16372018.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c16372018.filter3,tp,LOCATION_SZONE,0,1,nil)
end
function c16372018.spfilter(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and c:IsSetCard(0xdc1)
end
function c16372018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=Duel.GetLinkedZone(tp)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c16372018.spfilter(chkc,e,tp,zone) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c16372018.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c16372018.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c16372018.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local zone=Duel.GetLinkedZone(tp)
	if tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end