--方舟骑士·密林药师 嘉维尔
function c82567873.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--plimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c82567873.pcon)
	e2:SetTarget(c82567873.splimit)
	c:RegisterEffect(e2)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCountLimit(1,82567873+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c82567873.spcon)
	c:RegisterEffect(e1)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82567873,0))
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCost(c82567873.cost)
	e3:SetTarget(c82567873.target)
	e3:SetOperation(c82567873.operation)
	c:RegisterEffect(e3)
	--add setname
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(0x825)
	c:RegisterEffect(e9)
end
function c82567873.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c82567873.pcon(e,c,tp,sumtp,sumpos)
	return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x5825)==0
end
function c82567873.bwfilter(c,e,tp)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsFaceup()
end
function c82567873.ntbwfilter(c,e,tp)
	return not c:IsRace(RACE_BEASTWARRIOR) and c:IsFaceup()
end
function c82567873.spcon(e,c,tp)
	if c==nil then return true end
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c82567873.bwfilter,tp,LOCATION_MZONE,0,1,nil) and not Duel.IsExistingMatchingCard(c82567873.ntbwfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c82567873.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAttackAbove(800) end 
	if c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-800)
		c:RegisterEffect(e1)
		end
	end
function c82567873.thfilter(c)
	return c:IsSetCard(0xa827)  and c:IsAbleToHand()
		   and not c:IsCode(82567873)
	end
function c82567873.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	local ac=c:GetAttack()
	local abc=bc:GetAttack()
	if chk==0 then return  (Duel.GetAttacker()==c and Duel.GetAttackTarget()~=nil) and ac<abc end
end
function c82567873.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)  then
		local a=Duel.GetAttackTarget()
		if not a:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		e1:SetValue(1)
		c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_REVERSE_DAMAGE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
			e2:SetRange(LOCATION_MZONE)
			e2:SetTargetRange(1,0)
			e2:SetValue(c82567873.rev)
			e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
			c:RegisterEffect(e2)
	 local aa=a:GetAttack()
	 local ca=c:GetAttack()
	 local val=aa-ca
	 if c:IsLocation(LOCATION_MZONE) and val>=1000 and c:IsFaceup() and Duel.IsExistingMatchingCard(c82567873.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(82567873,0)) then
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82567873.thfilter,tp,LOCATION_DECK,0,0,1,nil)
	if g:GetCount()>0 then
		 Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_DECK)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	 end
	 end
	end
end
function c82567873.rev(e,re,r,rp,rc)
	return bit.band(r,REASON_BATTLE)~=0 
end
function c82567873.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	local ac=c:GetAttack()
	local abc=bc:GetAttack()
	 if Duel.NegateAttack()~=0 and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) then
	if ac>=abc then
	 local val=ac-abc 
	else 
	 local val=abc-ac 
	 end
	if val>0 then
	  Duel.Recover(tp,val,REASON_EFFECT) 
	if c:IsLocation(LOCATION_MZONE) and val>=1000 and c:IsFaceup() and Duel.IsExistingMatchingCard(c82567873.thfilter,tp,LOCATION_DECK,0,1,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82567873.thfilter,tp,LOCATION_DECK,0,0,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	end
	end
	end
end