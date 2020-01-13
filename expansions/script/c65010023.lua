--漆黑的名侦探 弦卷心
function c65010023.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c65010023.matfilter,2,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE+LOCATION_HAND,0,Duel.Release,REASON_COST)
	 --spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
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
	 --negate / banish
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c65010023.disrmcon)
	e3:SetCost(c65010023.disrmcost)
	e3:SetTarget(c65010023.disrmtg)
	e3:SetOperation(c65010023.disrmop)
	c:RegisterEffect(e3)
end
function c65010023.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and not c:IsType(TYPE_EFFECT)
end
function c65010023.disrmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(65010023)==0 end
	c:RegisterFlagEffect(65010023,RESET_CHAIN,0,1)
end
function c65010023.disrmcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandlerPlayer()~=tp
end
function c65010023.disrmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsChainDisablable(ev) and Duel.GetFlagEffect(tp,65010023)==0
	local b2=Duel.GetFlagEffect(tp,65010024)==0
	local b3=Duel.GetFlagEffect(tp,65010025)==0
	if chk==0 then return b1 or b2 or b3 end
end
function c65010023.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c65010023.disrmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsChainDisablable(ev) and Duel.GetFlagEffect(tp,65010023)==0
	local b2=Duel.GetFlagEffect(tp,65010024)==0
	local b3=c:IsRelateToEffect(e) and c:IsFaceup() and Duel.GetFlagEffect(tp,65010025)==0
	local op=0
	if b1 and b2 and b3 then op=Duel.SelectOption(tp,aux.Stringid(65010023,0),aux.Stringid(65010023,1),aux.Stringid(65010023,2))
	elseif b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(65010023,0),aux.Stringid(65010023,1))
	elseif b1 and b3 then 
		op=Duel.SelectOption(tp,aux.Stringid(65010023,0),aux.Stringid(65010023,2))
		if op==1 then op=2 end
	elseif b2 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(65010023,1),aux.Stringid(65010023,2))+1
	elseif b1 then op=0
	elseif b2 then op=1
	elseif b3 then op=2
	else return end
	if op==0 then
		if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(tp,65010023,RESET_PHASE+PHASE_END,0,1)
	elseif op==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_CHAIN)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,65010024,RESET_PHASE+PHASE_END,0,1)
	elseif op==2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		Duel.RegisterFlagEffect(tp,65010025,RESET_PHASE+PHASE_END,0,1)
	end
end