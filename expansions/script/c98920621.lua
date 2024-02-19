--淘气仙星·邦波妮
function c98920621.initial_effect(c)
	c:SetUniqueOnField(1,0,98920621)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_FAIRY),2,2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920621,0))
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_F)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c98920621.discon)
	e4:SetTarget(c98920621.distg)
	e4:SetOperation(c98920621.disop)
	c:RegisterEffect(e4)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920621,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+98920621)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c98920621.destg)
	e2:SetOperation(c98920621.desop)
	c:RegisterEffect(e2)
end
function c98920621.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c98920621.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end
function c98920621.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or c:GetAttack()<200 or not c:IsRelateToEffect(e) or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-200)
	c:RegisterEffect(e1)
	Duel.Damage(1-tp,200,REASON_EFFECT)
	if c:IsAttack(0) then Duel.RaiseEvent(re:GetHandler(),EVENT_CUSTOM+98920621,re,r,rp,ep,ev) end
end
function c98920621.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920621.filter2(c)
	return c:IsSetCard(0xfb) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98920621.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		g:AddCard(c)
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		   local g=Duel.SelectMatchingCard(tp,c98920621.filter2,tp,LOCATION_DECK,0,1,1,nil)
		   if g:GetCount()>0 then
			  Duel.SendtoHand(g,nil,REASON_EFFECT)
			  Duel.ConfirmCards(1-tp,g)
		   end
		end
	end
end