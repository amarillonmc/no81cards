--罪恶王冠 筱宫绫濑
function c1008027.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	-- e1:SetCountLimit(1,1008027)
	-- e1:SetCost(c1008027.cost)
	e1:SetTarget(c1008027.tktg)
	e1:SetOperation(c1008027.tkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--creat void
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1008027,1))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_SINGLE)
	e5:SetCode(1008001)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c1008027.voidtg)
	e5:SetOperation(c1008027.voidop)
	c:RegisterEffect(e5)
end
function c1008027.cfilter(c)
	return c:IsSetCard(0x320e) and c:IsAbleToGrave()
end
-- function c1008027.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	-- if chk==0 then return Duel.IsExistingMatchingCard(c1008027.cfilter,tp,LOCATION_DECK,0,1,nil) end
	-- Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	-- local g=Duel.SelectMatchingCard(tp,c1008027.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	-- if g:GetCount()>0 then
		-- Duel.SendtoGrave(g,REASON_EFFECT)
	-- end
-- end
function c1008027.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1008030,0,0x4011,1800,1800,4,RACE_MACHINE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c1008027.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,1008030,0,0x4011,1800,1800,4,RACE_MACHINE,ATTRIBUTE_EARTH) then
		local code = 1008030
		local token=Duel.CreateToken(tp,code)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		--special summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		e1:SetLabelObject(token)
		e1:SetCondition(c1008027.atcon)
		e1:SetValue(aux.imval1)
		c:RegisterEffect(e1)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetValue(aux.tgoval)
		c:RegisterEffect(e3)
	end
	Duel.BreakEffect()
	if c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENCE)
	end
end
function c1008027.atcon(e)
	return e:GetLabelObject():IsLocation(LOCATION_MZONE)
end
function c1008027.voidfilter(c)
	return c:IsSetCard(0x320e) and c:IsFaceup()
end
function c1008027.voidtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c1008027.voidfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and e:GetHandler():IsLocation(LOCATION_MZONE) and e:GetHandler():IsFaceup() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.Hint(8,tp,1008029)
	local g=Duel.SelectTarget(tp,c1008027.voidfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c1008027.voidop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 or not c:IsRelateToEffect(e) then return end
	if not c:IsLocation(LOCATION_MZONE) or not c:IsFaceup() then return end
	local eqc=Duel.GetFirstTarget()
	if eqc:IsRelateToEffect(e) then
		c:RegisterFlagEffect(10080011,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(1008001,4))
		local code = 1008029
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local g=Group.FromCards(Duel.CreateToken(tp,code))
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.BreakEffect()
		Duel.Equip(tp,tc,eqc,true)
		c:SetCardTarget(tc)
		--Destroy
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e2:SetCode(EVENT_LEAVE_FIELD)
		e2:SetOperation(c1008027.desop)
		c:RegisterEffect(e2,true)
		--Destroy2
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetCondition(c1008027.descon2)
		e3:SetOperation(c1008027.desop2)
		c:RegisterEffect(e3,true)
	end
end
function c1008027.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_ONFIELD) then
		Duel.Destroy(tc,REASON_RULE)
	end
end
function c1008027.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc) and re and not re:GetHandler():IsSetCard(0x320e)
end
function c1008027.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_RULE)
end