--闪耀的迷光 命定的对手
function c28360113.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c28360113.matfilter,3)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28360113,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c28360113.ctcon)
	e1:SetOperation(c28360113.ctop)
	c:RegisterEffect(e1)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetCondition(c28360113.atkcon)
	e2:SetLabel(2)
	e2:SetValue(c28360113.atklimit)
	c:RegisterEffect(e2)
	--attack indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c28360113.atkcon)
	e3:SetLabel(4)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c28360113.indcon)
	e4:SetValue(c28360113.efilter)
	c:RegisterEffect(e4)
end
function c28360113.matfilter(c)
	return c:GetCounter(0x1283)>0 or c:IsLinkSetCard(0x288)
end
function c28360113.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c28360113.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x288):GetClassCount(Card.GetCode)
	if c:IsFaceup() and c:IsRelateToEffect(e) and ct>0 then
		c:AddCounter(0x1283,ct)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(400*ct)
		c:RegisterEffect(e1)
	end
end
function c28360113.atkcon(e)
	return e:GetHandler():GetCounter(0x1283)>=e:GetLabel()
end
function c28360113.atklimit(e,c)
	return c~=e:GetHandler()
end
function c28360113.indcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x1283)>=6 and Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c28360113.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
