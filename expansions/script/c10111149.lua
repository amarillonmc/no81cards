function c10111149.initial_effect(c)
	 --fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c10111149.ffilter,3,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_ONFIELD+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--Cannot activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c10111149.tgcon)
	e1:SetValue(c10111149.aclimit)
	c:RegisterEffect(e1)
    	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111149,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCountLimit(1)
	e2:SetOperation(c10111149.atkop)
	c:RegisterEffect(e2)
end
c10111149.has_text_type=TYPE_UNION
function c10111149.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionType(TYPE_NORMAL) and c:IsLevelAbove(4)
end
function c10111149.tgcon(e)
	return e:GetHandler():IsDefensePos()
end
function c10111149.aclimit(e,re,tp)
	local tc=re:GetHandler()
	return tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsAttackPos() and re:IsActiveType(TYPE_MONSTER)
end
function c10111149.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e1:SetValue(c:GetDefense()*3)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
	end
end