function c82228498.initial_effect(c)  
	--summon with no tribute  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228498,0))  
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_SUMMON_PROC)  
	e1:SetCondition(c82228498.ntcon)  
	e1:SetOperation(c82228498.ntop)  
	c:RegisterEffect(e1)
	--search  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228498,2))  
	e2:SetCountLimit(1,82228498)	  
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_HAND)  
	e2:SetCost(c82228498.cost)  
	e2:SetTarget(c82228498.target)  
	e2:SetOperation(c82228498.operation)  
	c:RegisterEffect(e2) 
end
function c82228498.ntcon(e,c,minc)  
	if c==nil then return true end  
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0  
end  
function c82228498.ntop(e,tp,eg,ep,ev,re,r,rp,c)  
	--to grave  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228498,1))  
	e1:SetCategory(CATEGORY_TOGRAVE)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1)  
	e1:SetCode(EVENT_PHASE+PHASE_END)  
	e1:SetTarget(c82228498.tgtg)  
	e1:SetOperation(c82228498.tgop)  
	e1:SetReset(RESET_EVENT+0xc6e0000)  
	c:RegisterEffect(e1)  
end  
function c82228498.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)  
end  
function c82228498.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and c:IsFaceup() then  
		Duel.SendtoGrave(c,REASON_EFFECT)  
	end  
end  
function c82228498.filter(c)  
	return c:IsSetCard(0x291) and not c:IsCode(82228498) and c:IsAbleToHand()
end  
function c82228498.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end  
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)  
end  
function c82228498.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228498.filter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82228498.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c82228498.filter,tp,LOCATION_DECK,0,1,1,nil)  
	if tg:GetCount()>0 then  
		Duel.SendtoHand(tg,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,tg)  
	end  
end  