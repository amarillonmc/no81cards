--后巴别塔·嘉维尔
function c79035104.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to hand 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,79035104)
	e1:SetCost(c79035104.thcost)
	e1:SetTarget(c79035104.thtg)
	e1:SetOperation(c79035104.thop)
	c:RegisterEffect(e1)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCost(c79035104.atkcost)
	e3:SetOperation(c79035104.atkop)
	c:RegisterEffect(e3)
end
function c79035104.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c79035104.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0xca3) and c:IsType(TYPE_SPELL)
end
function c79035104.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79035104.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler(),0xca3) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function c79035104.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler(),0xca3)
	if g:GetCount()<=0 then return end
	local dg=g:Select(tp,1,1,nil)
	Duel.Destroy(dg,REASON_EFFECT)
	local g1=Duel.GetMatchingGroup(c79035104.thfil,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()<=0 then return end
	local tg=g1:Select(tp,1,1,nil)
	Duel.SendtoHand(tg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
end
function c79035104.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return c:GetFlagEffect(79035104)==0 and bc  end
	c:RegisterFlagEffect(79035104,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1) 
end
function c79035104.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(1500)
		c:RegisterEffect(e1)
	Duel.Recover(tp,100,REASON_EFFECT)
	end
end






