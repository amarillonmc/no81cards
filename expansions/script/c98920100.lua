--极星神兽 亚斯维德
function c98920100.initial_effect(c)
		  --synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x42),aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
 --spsummon token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920100,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98920100)	
	e1:SetCondition(c98920100.tdcon)
	e1:SetTarget(c98920100.sptg)
	e1:SetOperation(c98920100.spop)
	c:RegisterEffect(e1)  
  --
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c98920100.synlimit)
	c:RegisterEffect(e3)	
--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920100,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c98920100.tcon)
	e2:SetTarget(c98920100.ttg)
	e2:SetOperation(c98920100.top)
	c:RegisterEffect(e2)	
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(61777313)
	c:RegisterEffect(e3)  
  --search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920100,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98930100)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c98920100.thtg)
	e2:SetOperation(c98920100.thop)
	c:RegisterEffect(e2)
end
function c98920100.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98920100.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,98920189,0x42,TYPES_TOKEN_MONSTER,0,0,2,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c98920100.spop(e,tp,eg,ep,ev,re,r,rp)	
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)	
	local ct=c:GetMaterial():FilterCount(Card.IsSetCard,nil,0x42)	
	if ft>ct then ft=ct end
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,98920189,0x42,TYPES_TOKEN_MONSTER,0,0,2,RACE_FAIRY,ATTRIBUTE_LIGHT) then return end
	local ctn=true
	while ft>0 and ctn do
		local token=Duel.CreateToken(tp,98920189)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		ft=ft-1
		if ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(98920100,2)) then ctn=false end
	end
	Duel.SpecialSummonComplete()
end
function c98920100.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x4b)
end
function c98920100.tcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return c:IsLocation(LOCATION_GRAVE) and (rc:IsSetCard(0x4b) or rc:IsSetCard(0x42)) and r&REASON_SYNCHRO+REASON_LINK~=0
end
function c98920100.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,98920189,0x42,TYPES_TOKEN_MONSTER,0,0,2,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c98920100.top(e,tp,eg,ep,ev,re,r,rp)
   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,98920189,0x42,TYPES_TOKEN_MONSTER,0,0,2,RACE_FAIRY,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,98920189)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c98920100.thfilter(c)
	return c:IsSetCard(0x5042) and c:IsAbleToHand()
end
function c98920100.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920100.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920100.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920100.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end