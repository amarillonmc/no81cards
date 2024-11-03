--盛夏回忆·蜜蜂
function c65810065.initial_effect(c)
	--灵摆
	aux.EnablePendulumAttribute(c)
	--开摆
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,65810065+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c65810065.target2)
	e2:SetOperation(c65810065.activate2)
	c:RegisterEffect(e2)
	--攻宣无效
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c65810065.condition3)
	e3:SetCost(c65810065.cost3)
	e3:SetOperation(c65810065.activate3)
	c:RegisterEffect(e3)
	local e1=e3:Clone()
	e1:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e1)
	--灵摆自诉
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c65810065.splimit)
	c:RegisterEffect(e4)
end




function c65810065.pcfilter(c,tp)
	return(c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsCode(65810065) and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function c65810065.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and (Duel.IsExistingMatchingCard(c65810065.pcfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,tp))  
	end
end
function c65810065.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c65810065.pcfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		c:RegisterEffect(e2)
	end
end


function c65810065.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c65810065.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() 
	end
	Duel.SendtoHand(e:GetHandler(),tp,REASON_COST)
end
function c65810065.activate3(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end


function c65810065.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_INSECT) and bit.band(sumtp,SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end

