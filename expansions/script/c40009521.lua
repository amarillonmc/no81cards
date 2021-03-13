--黄金骑士的天道胜剑
function c40009521.initial_effect(c)
	aux.AddCodeList(c,40009510)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c40009521.target)
	e1:SetOperation(c40009521.operation)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c40009521.efilter)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c40009521.eqlimit)
	c:RegisterEffect(e3) 
	--extra attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40009521,0))
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetCountLimit(1,40009521)
	e4:SetCondition(c40009521.excon)
	e4:SetTarget(c40009521.extg)
	e4:SetOperation(c40009521.exop)
	c:RegisterEffect(e4)   
end
function c40009521.eqlimit(e,c)
	return c:IsCode(40009510) or (c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_WARRIOR))
end
function c40009521.filter(c)
	return c:IsFaceup() and c:IsCode(40009510) or (c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_WARRIOR))
end
function c40009521.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c40009521.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40009521.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c40009521.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c40009521.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c40009521.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c40009521.excon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c40009521.exfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(1)
end
function c40009521.extg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40009521.exfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40009521.exfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,40009523,0,0x4011,-2,-2,1,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c40009521.exfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,g:GetFirst():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c40009521.exop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,40009523,0,0x4011,-2,-2,1,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
		local val=Duel.Damage(tp,tc:GetAttack(),REASON_EFFECT)
		local token=Duel.CreateToken(tp,40009523)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE)
		e2:SetValue(val)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e2)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
