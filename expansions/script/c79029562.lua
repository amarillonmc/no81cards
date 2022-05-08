--CiNo.73 激泷泫神 渊爖
function c79029562.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,4)
	c:EnableReviveLimit()   
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(96864105,2))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c79029562.atkcon)
	e1:SetCost(c79029562.atkcost)
	e1:SetOperation(c79029562.atkop)
	c:RegisterEffect(e1)
	--atk up2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(96864105,2))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c79029562.atcost)
	e2:SetTarget(c79029562.attg)
	e2:SetOperation(c79029562.atop)
	c:RegisterEffect(e2)
	--remove overlay replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(96864105,2))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c79029562.rcon)
	e3:SetOperation(c79029562.rop)
	c:RegisterEffect(e3)
end
aux.xyz_number[79029562]=73
function c79029562.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d and a:GetControler()~=d:GetControler()
end
function c79029562.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(79029562)==0 end
	c:RegisterFlagEffect(79029562,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c79029562.atkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or a:IsFacedown() or not d:IsRelateToBattle() or d:IsFacedown() then return end
	if a:IsControler(1-tp) then a,d=d,a end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetOwnerPlayer(tp)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(d:GetAttack())
	a:RegisterEffect(e1)
	if not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,TYPE_SPELL+TYPE_TRAP) then return end  
	if Duel.SelectYesNo(tp,aux.Stringid(79029562,3)) then
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SSet(tp,g)
end
end
function c79029562.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029562.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetTargetCard(g)
end
function c79029562.atop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local e1=Effect.CreateEffect(c)
	op=Duel.SelectOption(tp,aux.Stringid(79029562,0),aux.Stringid(79029562,1))
	if op==0 then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	tc:RegisterEffect(e1)
	else 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetValue(tc:GetAttack()*2)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	tc:RegisterEffect(e2)
end
end
function c79029562.fil(c)
	return c:GetOverlayCount()>=1
end
function c79029562.rcon(e,tp,eg,ep,ev,re,r,rp)
   return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:GetHandler()==e:GetHandler() and re:GetHandler():GetOverlayCount()>=ev-1 and re:GetHandler():IsControler(tp) and Duel.IsExistingMatchingCard(c79029562.fil,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) and Duel.CheckLPCost(tp,1000)
end
function c79029562.rop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.PayLPCost(tp,1000)  
	local g=Duel.SelectMatchingCard(tp,c79029562.fil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	return g:GetFirst():RemoveOverlayCard(tp,1,1,REASON_REPLACE+REASON_COST)
end





