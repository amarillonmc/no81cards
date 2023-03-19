--次元的煌闪
function c11560311.initial_effect(c)
	--redirect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e0)	
	--remove 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCondition(c11560311.rmcon) 
	e1:SetCost(c11560311.rmcost)
	e1:SetTarget(c11560311.rmtg)
	e1:SetOperation(c11560311.rmop)
	c:RegisterEffect(e1) 
	--skip 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_BATTLED) 
	e2:SetRange(LOCATION_REMOVED) 
	e2:SetCountLimit(1,11560311+EFFECT_COUNT_CODE_DUEL) 
	e2:SetCondition(c11560311.rmcon) 
	e2:SetCost(c11560311.skcost)
	e2:SetTarget(c11560311.sktg)
	e2:SetOperation(c11560311.skop)
	c:RegisterEffect(e2)
end
c11560311.SetCard_XdMcy=true 
function c11560311.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a:IsControler(1-tp) 
end 
function c11560311.ctfil(c)  
	return c:IsAbleToDeckAsCost() and c.SetCard_XdMcy   
end 
function c11560311.rmcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11560311.ctfil,tp,LOCATION_REMOVED,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c11560311.ctfil,tp,LOCATION_REMOVED,0,1,1,nil)  
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end 
function c11560311.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_MZONE)
end
function c11560311.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end 
end 
function c11560311.skcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end 
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end 
function c11560311.sktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c11560311.skop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
end 


