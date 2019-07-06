--动物朋友 PPP×动物饼干
function c33700062.initial_effect(c)
	 c:EnableUnsummonable()
 --special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c33700062.limit)
	c:RegisterEffect(e1)
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700062,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCondition(c33700062.condition)
	e2:SetCost(c33700062.cost)
	e2:SetTarget(c33700062.target)
	e2:SetOperation(c33700062.operation)
	c:RegisterEffect(e2)
end
function c33700062.confilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c33700062.limit(e,c)
   local g=Duel.GetMatchingGroup(c33700062.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=8 
end
function c33700062.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	 return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and   Duel.GetTurnPlayer()==tp 
end
function c33700062.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (e:GetHandler():GetAttackAnnouncedCount()==0  and Duel.GetActivityCount(tp,ACTIVITY_ATTACK)==0) or (e:GetHandler():GetAttackAnnouncedCount()==1  and Duel.GetActivityCount(tp,ACTIVITY_ATTACK)==1)  end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c33700062.ftarget)
	e1:SetLabel(e:GetHandler():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33700062.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c33700062.tgfilter(c)
	return not c:IsPublic()
end
function c33700062.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsExistingMatchingCard(c33700062.tgfilter,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c33700062.filter(c)
	return c:IsSetCard(0x442)
end
function c33700062.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if not Duel.IsExistingMatchingCard(c33700062.tgfilter,tp,LOCATION_HAND,0,1,nil) then return end
	Duel.ConfirmCards(g,1-tp)
	Duel.ShuffleHand(tp)
	local c=e:GetHandler()
	local ct=g:FilterCount(c33700062.filter,nil)
	if ct>0 and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
