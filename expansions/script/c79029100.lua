--深海猎人·据点-阿戈尔的遗迹
function c79029100.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c79029100.target)
	e1:SetOperation(c79029100.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c79029100.eqlimit)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c79029100.con)
	e4:SetTarget(c79029100.cttg)
	e4:SetOperation(c79029100.ctop)
	c:RegisterEffect(e4)
	--double tribute
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e5:SetValue(c79029100.effcon)
	c:RegisterEffect(e5) 
  
end
function c79029100.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xa900)
end
function c79029100.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029100.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029100.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c79029100.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79029100.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c79029100.eqlimit(e,c)
	return c:IsSetCard(0xa900)
end
function c79029100.effcon(e,c)
	return c:IsSetCard(0xa900)
end
function c79029100.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_CONTINUOUS)
end
function c79029100.filter(c,e,tp)
	return c:IsSetCard(0x1908)
end
function c79029100.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(c79029100.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 and Duel.IsPlayerCanSpecialSummonMonster(tp,79029101,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_WATER)  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)

end
function c79029100.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029100.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
	   if Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 and  Duel.GetLocationCount(tp,LOCATION_MZONE)>=0 and Duel.IsPlayerCanSpecialSummonMonster(tp,79029101,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_WATER) then
	local token=Duel.CreateToken(tp,79029101)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	   end  
	end
end 