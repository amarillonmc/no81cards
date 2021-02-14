--后巴别塔·塞雷娅
function c79035107.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_RECOVER)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,79035107)
	e1:SetCost(c79035107.spcost)
	e1:SetTarget(c79035107.sptg)
	e1:SetOperation(c79035107.spop)
	c:RegisterEffect(e1)   
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,214019)
	e2:SetCost(c79035107.incost)
	e2:SetTarget(c79035107.intg)
	e2:SetOperation(c79035107.inop)
	c:RegisterEffect(e2) 
	--Recover
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,314019)
	e4:SetTarget(c79035107.rectg)
	e4:SetOperation(c79035107.recop)
	c:RegisterEffect(e4)  
end
function c79035107.thfil(c)
	return c:IsSetCard(0xca3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c79035107.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,Duel.GetLP(tp)/2) end
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
end
function c79035107.spfil(c,e,tp)
	return c:IsSetCard(0xca3) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c79035107.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c79035107.thfil,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c79035107.spfil,tp,LOCATION_DECK,0,1,nil,e,tp)
	if chk==0 then return (b1 or b2) and ep==tp end
	local op=0
	if b1 and b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(79035107,0),aux.Stringid(79035107,1))
	elseif b1 then
	op=Duel.SelectOption(tp,aux.Stringid(79035107,0))
	else
	op=Duel.SelectOption(tp,aux.Stringid(79035107,1))+1
	end
	e:SetLabel(op)
	if op==0 then 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function c79035107.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==0 then 
	local g=Duel.GetMatchingGroup(c79035107.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	local tg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(tg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	else
	local g=Duel.GetMatchingGroup(c79035107.spfil,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()<=0 then return end
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c79035107.incost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c79035107.intg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c79035107.inop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xca3))
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	Duel.RegisterEffect(e2,tp)
end
function c79035107.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and e:GetHandler():IsReason(REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c79035107.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp,tp,nil,c)<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
	Duel.BreakEffect()
	local atk=c:GetAttack()
	Duel.Recover(tp,atk,REASON_EFFECT)
	end
end








