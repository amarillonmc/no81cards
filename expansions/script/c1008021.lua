--Guilty Crown
function c1008021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c1008021.target)
	e1:SetOperation(c1008021.operation)
	c:RegisterEffect(e1)
	--Atk Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetValue(c1008021.value)
	c:RegisterEffect(e2)
	--Disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c1008021.eqlimit)
	c:RegisterEffect(e3)
	--to hand 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1008021,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c1008021.cost)
	e4:SetTarget(c1008021.thtg)
	e4:SetOperation(c1008021.thop)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1008001,3))
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c1008021.tg)
	e5:SetOperation(c1008021.op)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
c1008021.DescSetName = 0x320e
function c1008021.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x320e) and c:GetBaseAttack()<=2000
end
function c1008021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c1008021.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1008021.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c1008021.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c1008021.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c1008021.value(e,c)
	return c:GetBaseAttack()*2
end
function c1008021.eqlimit(e,c)
	return c:IsSetCard(0x320e) and c:GetBaseAttack()<=2000
end
function c1008021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c1008021.thfilter(c)
	return c:IsSetCard(0x320e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1008021.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1008021.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1008021.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1008021.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c1008021.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and eg:IsExists(c1008021.ttfilter,1,nil,e,tp) end
	local g=eg:Filter(c1008021.ttfilter,nil,e,tp)
	Duel.SetTargetCard(g)
end
function c1008021.ttfilter(c,e,tp)
	return (c:IsCode(1008014) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1)
	or ((c:IsSetCard(0x320e)and c:GetCode()~=1008014 and c:GetCode()~=1008001) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
	and c:IsControler(tp) and c:IsFaceup()and c:IsType(TYPE_MONSTER)
end
function c1008021.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c1008021.ttfilter,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		local a=0
		if (tc:GetCode()==1008014 and Duel.GetLocationCount(tp,LOCATION_MZONE)>1)
		or ((tc:IsSetCard(0x320e)and tc:GetCode()~=1008014 and tc:GetCode()~=1008001) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then a=1 end
		if a==1 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.RaiseSingleEvent(tc,1008001,e,0,0,0,0)
			local e1=Effect.CreateEffect(tc)
			e1:SetDescription(aux.Stringid(1008001,4))
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetRange(LOCATION_MZONE)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(10080011,RESET_EVENT+0x1fe0000,0,1)
		end
		tc=g:GetNext()
	end
end