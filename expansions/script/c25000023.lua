--音击龙 舞甲响鬼
function c25000023.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c25000023.ffilter,3,false)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)   
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c25000023.splimit)
	c:RegisterEffect(e1)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0xfe,0xff)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetTarget(c25000023.rmtg2)
	c:RegisterEffect(e1)  
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25000023,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c25000023.condition)
	e2:SetOperation(c25000023.operation)
	c:RegisterEffect(e2) 
	--Remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,25000023)
	e3:SetCondition(c25000023.rmcon)
	e3:SetTarget(c25000023.rmtg)
	e3:SetOperation(c25000023.rmop)
	c:RegisterEffect(e3)
end
function c25000023.ffilter(c,fc,sub,mg,sg)
	return ( not sg or sg:GetClassCount(Card.GetLevel)==1) and c:IsRace(RACE_ZOMBIE)
end
function c25000023.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c25000023.rmtg2(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c25000023.filter(c,tp)
	return not c:IsType(TYPE_TOKEN) and c:IsPreviousControler(1-tp)
end
function c25000023.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c25000023.filter,1,nil,tp)
end
function c25000023.operation(e,tp,eg,ep,ev,re,r,rp)
   local ct=eg:FilterCount(c25000023.filter,nil,tp)
   Duel.Damage(1-tp,ct*300,REASON_EFFECT)
end
function c25000023.rmcon(e,tp,eg,ep,ev,re,r,rp) 
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
	end
end
function c25000023.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c25000023.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local tc=g:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x17a0000)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x17a0000)
	tc:RegisterEffect(e2)
	end
end





