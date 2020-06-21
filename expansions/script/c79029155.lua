--维多利亚·据点-温室花园
function c79029155.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c79029155.target)
	e1:SetOperation(c79029155.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c79029155.eqlimit)
	c:RegisterEffect(e2) 
	--atk def 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c79029155.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4) 
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c79029155.thcon)
	e5:SetTarget(c79029155.thtg)
	e5:SetOperation(c79029155.thop)
	c:RegisterEffect(e5) 
end
function c79029155.eqlimit(e,c)
	return c:IsSetCard(0xf02)
end
function c79029155.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf02)
end
function c79029155.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029155.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029155.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c79029155.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79029155.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c79029155.val(e,c,Counter)  
	if e:GetHandler():GetEquipTarget()==nil then return end
	if e:GetHandler():GetEquipTarget():IsType(TYPE_XYZ) then 
	return e:GetHandler():GetEquipTarget():GetRank()*100
	else return e:GetHandler():GetEquipTarget():GetLevel()*100 end
end
function c79029155.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSummonType(SUMMON_TYPE_PENDULUM) and e:GetHandler():IsType(TYPE_CONTINUOUS)
end
function c79029155.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029155.cfilter,3,nil,tp)
end
function c79029155.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c79029155.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end







