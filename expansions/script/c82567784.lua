--方舟骑士·深夏守夜人 黑
function c82567784.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x825),1)
	c:EnableReviveLimit()
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c82567784.target)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c82567784.atkcon)
	e2:SetCost(c82567784.atkcost)
	e2:SetOperation(c82567784.atkop)
	c:RegisterEffect(e2)
end
function c82567784.target(e,c)
	return c:IsSetCard(0x825)
end
function c82567784.defcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and e:GetHandler():GetBattleTarget()
end
function c82567784.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and not bc:IsAttackPos() and bc:GetAttack()>0
end
function c82567784.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(82567784)==0 end
	c:RegisterFlagEffect(82567784,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c82567784.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local bc=tc:GetBattleTarget()
	if tc:IsRelateToBattle() and tc:IsFaceup() and bc:IsRelateToBattle() 
		then
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(bc:GetDefense())
		tc:RegisterEffect(e1)
	end
end
function c82567784.filter(c,e) 
	 local tp=e:GetHandlerPlayer()
	 return c:IsFaceup()  and Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x5825)>0
end
function c82567784.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() and chkc:IsCanBeEffectTarget() end
	if chk==0 then return Duel.IsExistingTarget(c82567784.filter,tp,0,LOCATION_MZONE,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c82567784.filter,tp,0,LOCATION_MZONE,1,1,nil,e)
	 Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,tc,1,tp,0)
end
function c82567784.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget() 
	local adval=Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x5825)*200
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(-adval)
		tc:RegisterEffect(e1)
	end
end
