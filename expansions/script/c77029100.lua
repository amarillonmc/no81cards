--闪刀姬-黎明
function c77029100.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,77029100+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c77029100.hspcon)
	e1:SetOperation(c77029100.hspop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)  
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,17029100)
	e2:SetTarget(c77029100.intg)
	e2:SetOperation(c77029100.inop)
	c:RegisterEffect(e2) 
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--to hand 
	--local e4=Effect.CreateEffect(c)
	--e4:SetDescription(aux.Stringid(77029100,0))
	--e4:SetCategory(CATEGORY_TOHAND)
	--e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	--e4:SetCode(EVENT_SUMMON_SUCCESS)
	--e4:SetProperty(EFFECT_FLAG_DELAY)
	--e4:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	--e4:SetCountLimit(1,27029100)
	--e4:SetCondition(c77029100.thcon)
   -- e4:SetTarget(c77029100.thtg)
   -- e4:SetOperation(c77029100.thop)
   -- c:RegisterEffect(e4)
  --  local e5=e4:Clone()
   -- e5:SetCode(EVENT_SPSUMMON_SUCCESS)
   -- c:RegisterEffect(e5)
end
function c77029100.spfilter(c,ft)
	return c:IsFaceup() and c:IsSetCard(0xa991,0x115) and c:IsAbleToHandAsCost()
		and (((ft>0 or c:GetSequence()<5) and c:IsLocation(LOCATION_MZONE)) or c:IsLocation(LOCATION_SZONE))
end
function c77029100.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return Duel.IsExistingMatchingCard(c77029100.spfilter,tp,LOCATION_ONFIELD,0,1,nil,ft) 
end
function c77029100.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c77029100.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,ft)
	Duel.SendtoHand(g,nil,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(3)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c77029100.intg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c77029100.inop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		--inactivatable
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_INACTIVATE)
		e1:SetValue(c77029100.efilter)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp) 
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_DISABLE)
		Duel.RegisterEffect(e2,tp)
end
function c77029100.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:IsActiveType(TYPE_MONSTER) and te:GetOwner():IsSetCard(0xa991,0x115) 
end
--function c77029100.cfilter1(c)
	--return c:IsFaceup() and c:IsSetCard(0x1115) and not c:IsCode(77029100)
--end
--function c77029100.thcon(e,tp,eg,ep,ev,re,r,rp)
   -- return eg:IsExists(c77029100.cfilter1,1,nil)
--end
--function c77029100.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	--local c=e:GetHandler()
	--if chk==0 then return c:IsAbleToHand() and Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end 
   -- Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil) 
   -- Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_GRAVE+LOCATION_REMOVED)
--end
--function c77029100.thop(e,tp,eg,ep,ev,re,r,rp)
	--local c=e:GetHandler()
	--local tc=Duel.GetFirstTarget()
	--if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then 
	--local g=Group.FromCards(c,tc) 
   -- Duel.SendtoHand(g,nil,REASON_EFFECT) 
	--Duel.ConfirmCards(1-tp,g)
   -- end
--end




