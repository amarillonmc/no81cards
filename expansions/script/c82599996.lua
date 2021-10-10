--魔戒仪士消逝之线-牙狼
function c82599996.initial_effect(c)
	c:EnableReviveLimit()
	--AddCounter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,82599996)
	e1:SetCost(c82599996.cost)
	e1:SetTarget(c82599996.cttg)
	e1:SetOperation(c82599996.ctop)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--draw(battle)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c82599996.drcon)
	e3:SetTarget(c82599996.drtg)
	e3:SetOperation(c82599996.drop)
	c:RegisterEffect(e3)
	--return
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c82599996.retreg)
	c:RegisterEffect(e4)
end
function c82599996.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c82599996.tkfilter(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsSetCard(0x821)
end
function c82599996.filter(c)
	return c:IsFaceup() 
end
function c82599996.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:GetLevel()>0 and chkc:IsSetCard(0x821) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c82599996.tkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82599996.tkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c82599996.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp)
  then  local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
end
end
function c82599996.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetTurnPlayer()==tp
end
function c82599996.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c82599996.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	Duel.Draw(p,d,REASON_EFFECT)
end
function c82599996.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_ATKCHANGE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(c82599996.retcon)
	e1:SetTarget(c82599996.rettg)
	e1:SetOperation(c82599996.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(c82599996.retcon2)
	c:RegisterEffect(e2)
end
function c82599996.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
end
function c82599996.retcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) 
end
function c82599996.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
			return true
		else
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsPlayerCanSpecialSummonMonster(tp,82599980,0,0x4011,2500,2000,8,RACE_WARRIOR,ATTRIBUTE_LIGHT)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,nil,tp,0)
	Duel.SetChainLimit(c82599996.chlimit)
end
function c82599996.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,82599980,0,0x4011,2500,2000,8,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
			local token=Duel.CreateToken(tp,82599980)
		   if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
	local sg=Duel.GetMatchingGroup(c82599996.filter,tp,LOCATION_MZONE,0,nil)
	local tc=sg:GetFirst()
	
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_CANNOT_DISABLE)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
	end
	end
end
function c82599996.chlimit(e,ep,tp)
	return tp==ep
end
