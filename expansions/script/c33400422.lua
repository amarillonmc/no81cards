--AST 日下部燎子 休闲装
function c33400422.initial_effect(c)
	 --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400422,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,33400422)
	e1:SetCondition(c33400422.thcon)
	e1:SetTarget(c33400422.thtg2)
	e1:SetOperation(c33400422.thop2)
	c:RegisterEffect(e1)
	 --Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400422,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c33400422.eqcon)
	e2:SetTarget(c33400422.eqtg)
	e2:SetOperation(c33400422.eqop)
	c:RegisterEffect(e2)
end
function c33400422.thcon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x6343)
end
function c33400422.thfilter2(c)
	return c:IsSetCard(0x9343)  and c:IsAbleToHand()
end
function c33400422.cccfilter1(c)
	return c:IsCode(33400428) and c:IsFaceup()
end
function c33400422.cccfilter2(c)
	return c:IsCode(33400425) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c33400422.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400422.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and  not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x341) then 
		if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,0,LOCATION_MZONE,1,nil,0x341)   
		or (  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and 
			(Duel.IsExistingMatchingCard(c33400421.cccfilter1,tp,LOCATION_ONFIELD,0,1,nil) or 
			Duel.IsExistingMatchingCard(c33400421.cccfilter2,tp,LOCATION_MZONE,0,1,nil))) 
		then
		Duel.SetChainLimit(aux.FALSE)
		end
	end
end
function c33400422.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33400422.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c33400422.cccfilter1(c)
	return c:IsCode(33400428) and c:IsFaceup()
end
function c33400422.cccfilter2(c)
	return c:IsCode(33400425) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c33400422.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	e:SetLabelObject(tc)
	return tc and ((Duel.IsExistingMatchingCard(c33400422.cccfilter1,tp,LOCATION_SZONE,0,1,nil) or 
	Duel.IsExistingMatchingCard(c33400422.cccfilter2,tp,LOCATION_MZONE,0,1,nil) 
	) or tc:IsSetCard(0x341))
end
function c33400422.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c33400422.filter(chkc,e,tp,e:GetHandler()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c33400422.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,0,0,0,0)
end
function c33400422.eqop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33400422.filter,tp,LOCATION_GRAVE,0,nil,e,tp,e:GetHandler())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g1=g:Select(tp,1,1,nil)
		local tc=g1:GetFirst()
		Duel.Equip(tp,tc,e:GetHandler())
		if not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x341) then 
			if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,0,LOCATION_MZONE,1,nil,0x341)   
			or (  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and 
				(Duel.IsExistingMatchingCard(c33400421.cccfilter1,tp,LOCATION_ONFIELD,0,1,nil) or 
				Duel.IsExistingMatchingCard(c33400421.cccfilter2,tp,LOCATION_MZONE,0,1,nil))) 
			then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1:SetRange(LOCATION_MZONE)
				e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
				e1:SetCountLimit(1)
				e1:SetValue(c33400422.valcon)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e:GetHandler():RegisterEffect(e1)  
			end
		end
end
function c33400422.valcon(e,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c33400422.filter(c,e,tp,ec)
	return c:IsSetCard(0x6343)  and c:CheckEquipTarget(ec)and c:CheckUniqueOnField(tp)
end