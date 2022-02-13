--伤心的大锁
function c79029170.initial_effect(c)
	--public
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029170,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,79029170)
	e1:SetCost(c79029170.pbcost) 
	e1:SetTarget(c79029170.pbtg)
	e1:SetOperation(c79029170.pbop)
	c:RegisterEffect(e1)   
	--to hand 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029170,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,19029170)
	e2:SetCost(c79029170.thcost) 
	e2:SetTarget(c79029170.thtg)
	e2:SetOperation(c79029170.thop)
	c:RegisterEffect(e2)	
	--skip 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,29029170)
	e3:SetTarget(c79029170.sktg)   
	e3:SetOperation(c79029170.skop)
	c:RegisterEffect(e3)
end
function c79029170.pbcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function c79029170.pbtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end
end
function c79029170.pbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029170,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,3)
	e1:SetCondition(c79029170.spcon)
	e1:SetOperation(c79029170.spop)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
	c79029170[e:GetHandler()]=e1
	c:RegisterFlagEffect(1082946,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,EFFECT_FLAG_CLIENT_HINT,3,0,aux.Stringid(79029170,0))
	Duel.Hint(24,0,aux.Stringid(79029170,10))
end
function c79029170.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():IsPublic()
end
function c79029170.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local ct=e:GetLabel()
	c:SetTurnCounter(ct+1)
	Duel.Hint(24,0,aux.Stringid(79029170,ct*3+1))
	Duel.Hint(24,0,aux.Stringid(79029170,ct*3+2))
	Duel.Hint(24,0,aux.Stringid(79029170,ct*3+3))
	if ct+1==3 then
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029170,11))
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.Damage(1-tp,c:GetDefense(),REASON_EFFECT)
	Duel.Recover(tp,c:GetDefense(),REASON_EFFECT)
	else e:SetLabel(ct+1) end
end
function c79029170.thcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.CheckLPCost(tp,1000) end 
	Duel.PayLPCost(tp,1000)
end
function c79029170.thfil(c)
	return c:IsRace(RACE_FIEND) and c:IsLevel(10) and c:IsAbleToHand() 
end
function c79029170.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c79029170.thfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and e:GetHandler():IsPublic() end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c79029170.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029170.thfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil)  
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	end
end
function c79029170.sktg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsPublic() and e:GetHandler():GetFlagEffect(1082946)~=0 and ep==tp end 
end
function c79029170.skop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:GetFlagEffect(1082946)~=0 then 
	local turne=c[c]
	local op=turne:GetOperation()
	op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0) 
	end   
end











