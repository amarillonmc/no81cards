--暴力之心罪·小红帽
function c29010414.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP_ATTACK,1)
	e1:SetCondition(c29010414.spcon)
	e1:SetOperation(c29010414.spop)
	c:RegisterEffect(e1)
	--th 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29010414,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c29010414.thcon)
	e2:SetTarget(c29010414.thtg)
	e2:SetOperation(c29010414.thop)
	c:RegisterEffect(e2)   
	c29010414.battle_effect=e2
end
function c29010414.spfilter(c,tp)
	return c:IsAbleToGrave() and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function c29010414.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c29010414.spfilter,tp,0,LOCATION_MZONE,1,nil,tp)
end
function c29010414.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c29010414.spfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(g:GetFirst():GetAttack())
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c29010414.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c29010414.thfil(c) 
	return c:IsSetCard(0x7a1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() 
end 
function c29010414.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)  
end 
function c29010414.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c29010414.thfil,1-tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end 
	local sg=g:Select(1-tp,1,1,nil) 
	Duel.SendtoHand(sg,1-tp,REASON_EFFECT) 
	Duel.ConfirmCards(tp,sg) 
end 






