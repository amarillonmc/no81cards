--方舟骑士-华法琳
c115025.named_with_Arknight=1
function c115025.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--XDestroy 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,115025)
	e2:SetTarget(c115025.xdtg)
	e2:SetOperation(c115025.xdop)
	c:RegisterEffect(e2) 
	--SpecialSummon P 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1,115026) 
	e3:SetCondition(c115025.pspcon)
	e3:SetTarget(c115025.psptg) 
	e3:SetOperation(c115025.pspop) 
	c:RegisterEffect(e3)

end
function c115025.pspcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler()) 
end   
function c115025.psptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler()) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetTargetCard(sc) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sc,1,0,0) 
end 
function c115025.pthfil(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_PENDULUM) and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))  
end 
function c115025.pspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then 
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	if Duel.IsExistingMatchingCard(c115025.pthfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(115025,0)) then 
	local sg=Duel.SelectMatchingCard(tp,c115025.pthfil,tp,LOCATION_DECK,0,1,1,nil) 
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg)
	end
	end 
	end 
	end 
end 
function c115025.xdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end 
function c115025.xdop(e,tp,eg,ep,ev,re,r,rp,chk) 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c115025.atkcon)
	e1:SetOperation(c115025.atkop) 
	if Duel.GetTurnPlayer()==tp and Duel.IsAbleToEnterBP() then 
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN) 
	else 
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)   
	end 
	Duel.RegisterEffect(e1,tp)
end
function c115025.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetTurnCount()~=e:GetLabel() or Duel.IsAbleToEnterBP()) and Duel.GetTurnPlayer()==tp and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function c115025.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,115025)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
	local tc=g:GetFirst() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(tc:GetAttack()*2) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
	tc:RegisterEffect(e1) 
	end
end


