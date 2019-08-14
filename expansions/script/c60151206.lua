--无垢识 两仪式
function c60151206.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_SINGLE)
	e99:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e99:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e99)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c60151206.condition2)
	e1:SetOperation(c60151206.desop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,60151206)
	e2:SetCondition(c60151206.thcon)
	e2:SetCost(c60151206.thcost)
	e2:SetTarget(c60151206.thtg)
	e2:SetOperation(c60151206.thop)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c60151206.aclimit)
	e3:SetCondition(c60151206.actcon)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetOperation(c60151206.atkop)
	c:RegisterEffect(e4)

	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e14:SetCode(EVENT_BE_BATTLE_TARGET)
	e14:SetOperation(c60151206.atkop)
	c:RegisterEffect(e14)
	--direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetCondition(c60151206.dactcon)
	c:RegisterEffect(e5)
end
function c60151206.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function c60151206.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if c:GetBattleTarget()==nil then return end
	if tc:IsRelateToBattle() and tc:IsFaceup() and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) then
		local atk=c:GetAttack()
		local atk1=tc:GetAttack()
		local def1=tc:GetDefense()
		if c:GetFlagEffect(60151298)>0 then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60151201,0))
			Duel.Hint(HINT_CARD,0,60151206)
			if Duel.SendtoGrave(tc,REASON_RULE)~=0 then local atk2=tc:GetBaseAttack()
				if atk>atk2 then Duel.BreakEffect()
					Duel.Damage(1-tp,atk-atk2,REASON_EFFECT)
				end
				if atk2>atk then Duel.BreakEffect()
					Duel.Damage(1-tp,atk2-atk,REASON_EFFECT)
				end
			end
		else
			if atk>atk1 or atk>def1 then
				Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60151201,1))
				Duel.Hint(HINT_CARD,0,60151206)
				if Duel.SendtoGrave(tc,REASON_RULE)~=0 then local atk2=tc:GetBaseAttack()
					if atk>atk2 then Duel.BreakEffect()
						Duel.Damage(1-tp,atk-atk2,REASON_EFFECT)
					end
					if atk2>atk then Duel.BreakEffect()
						Duel.Damage(1-tp,atk2-atk,REASON_EFFECT)
					end
				end
			end
		end
	end
end
function c60151206.cfilter(c)
	return c:IsFaceup() and bit.band(c:GetType(),0x81)==0x81
end
function c60151206.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c60151206.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c60151206.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c60151206.thfilter(c)
	return c:IsCode(60151299) and c:IsAbleToHand()
end
function c60151206.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151206.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60151206.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60151206.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60151206.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c60151206.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c60151206.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c60151206.efilter)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	e:GetHandler():RegisterEffect(e1)
end
function c60151206.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c60151206.dactcon(e,tp,eg,ep,ev,re,r,rp)
	local cont=e:GetHandler():GetControler()
	local atk=e:GetHandler():GetBaseAttack()
	return atk>=Duel.GetLP(1-cont)
end