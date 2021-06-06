--刹那芳华 樱吹雪
function c10700743.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c10700743.lcheck)
	c:EnableReviveLimit()   
	--use baseattack
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e0:SetCondition(c10700743.atkcon)
	e0:SetOperation(c10700743.atkop)
	c:RegisterEffect(e0) 
	--atk damage 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700743,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c10700743.adtg)
	e1:SetOperation(c10700743.adop)
	c:RegisterEffect(e1)
	--spirit return
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c10700743.retreg)
	c:RegisterEffect(e4) 
	--tohand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10700740,3))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetCondition(c10700743.thcon)
	e6:SetTarget(c10700743.thtg)
	e6:SetOperation(c10700743.thop)
	c:RegisterEffect(e6)
end
function c10700743.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x7cc)
end
function c10700743.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c or Duel.GetAttackTarget()==c
end
function c10700743.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL+RESET_LEAVE)
	e1:SetValue(c:GetBaseAttack())
	c:RegisterEffect(e1)
end
function c10700743.adfilter(c,e)
	return c:IsCanBeBattleTarget(e:GetHandler())
end
function c10700743.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700743.adfilter,tp,0,LOCATION_MZONE,1,nil,e) and e:GetHandler():IsAttackable() end
end
function c10700743.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
	local g=Duel.SelectMatchingCard(tp,c10700743.adfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	if g:GetCount()>0 then
	local e1=Effect.CreateEffect(c)
		 e1:SetType(EFFECT_TYPE_SINGLE)
		 e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
		 e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL+RESET_LEAVE)
		 e1:SetValue(c:GetBaseAttack())
		 c:RegisterEffect(e1)
		 Duel.CalculateDamage(e:GetHandler(),g:GetFirst(),true)
	end
end
function c10700743.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(c10700743.retcon)
	e1:SetTarget(c10700743.rettg)
	e1:SetOperation(c10700743.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(c10700743.retcon2)
	e2:SetTarget(c10700743.rettg2)
	c:RegisterEffect(e2)
end
function c10700743.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) and not Duel.IsPlayerAffectedByEffect(tp,10700738)
end
function c10700743.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10700743.thfilter(c)
	return c:IsSetCard(0x7cc) and c:IsAbleToHand()
end
function c10700743.retop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,10700738) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		 local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10700743.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		 if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10700743,1)) then
			 Duel.BreakEffect()
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			 local sg=g:Select(tp,1,1,nil)
			 Duel.SendtoHand(sg,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,sg)
		 end
	end
end
function c10700743.retcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) and c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) and not Duel.IsPlayerAffectedByEffect(tp,10700738)
end
function c10700743.rettg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10700743.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,10700738)
end
function c10700743.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and e:GetHandler():GetFlagEffect(10700744)==0 end
	e:GetHandler():RegisterFlagEffect(10700744,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10700743.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		 local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10700743.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		 if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10700743,1)) then
			 Duel.BreakEffect()
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			 local sg=g:Select(tp,1,1,nil)
			 Duel.SendtoHand(sg,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,sg)
		 end
	end
end