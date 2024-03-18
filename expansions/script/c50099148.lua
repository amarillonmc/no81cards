--仗剑走天涯 小镜子
function c50099148.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c50099148.spcon)
	e1:SetCountLimit(1,50099148+EFFECT_COUNT_CODE_OATH) 
	c:RegisterEffect(e1) 
	--remove 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10099148) 
	e1:SetTarget(c50099148.rmtg)
	e1:SetOperation(c50099148.rmop)
	c:RegisterEffect(e1)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,20099148) 
	e1:SetCondition(c50099148.thcon)
	e1:SetTarget(c50099148.thtg)
	e1:SetOperation(c50099148.thop)
	c:RegisterEffect(e1)
end
function c50099148.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x998) 
end
function c50099148.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c50099148.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end 
function c50099148.rmfilter(c)
	return c:IsSetCard(0x998) and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function c50099148.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50099148.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c50099148.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.SelectMatchingCard(tp,c50099148.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT) 
	end
end
function c50099148.thcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return ((c:IsReason(REASON_COST) and re:IsActivated()) or c:IsReason(REASON_EFFECT)) and rc:IsSetCard(0x998)  
end 
function c50099148.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c50099148.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SendtoHand(c,nil,REASON_EFFECT) 
	end 
end 




