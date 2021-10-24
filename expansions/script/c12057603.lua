--月夜龙 恶魔之主
function c12057603.initial_effect(c)
   --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsDefenseAbove,2800),aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON+RACE_WARRIOR+RACE_WYRM+RACE_SPELLCASTER+RACE_MACHINE),2,2,true)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)   
	--def atk 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c12057603.datg)
	e3:SetOperation(c12057603.daop)
	c:RegisterEffect(e3) 
	--remove 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CHAIN_NEGATED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,12057603)
	e4:SetCondition(c12057603.rmcon1)
	e4:SetTarget(c12057603.rmtg)
	e4:SetOperation(c12057603.rmop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_CHAIN_DISABLED)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c12057603.rmcon2)
	c:RegisterEffect(e6)
end
function c12057603.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c12057603.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_DEFENSE) 
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(1500)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-1500)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c12057603.rmcon1(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsControler(tp) and re:GetActivateLocation()==LOCATION_MZONE 
end
function c12057603.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c12057603.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,2,nil)
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c12057603.ckfil(c,tp)
	return c:GetReasonPlayer()~=tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp 
end
function c12057603.rmcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12057603.ckfil,1,nil,tp) 
end


