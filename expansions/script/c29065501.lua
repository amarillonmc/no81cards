--方舟骑士-凯尔希
c29065501.named_with_Arknight=1
function c29065501.initial_effect(c)
	aux.AddCodeList(c,29065500)
	c:EnableCounterPermit(0x10ae)
	--to hand 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065501,0))
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,29065501)
	e2:SetTarget(c29065501.thtg1)
	e2:SetOperation(c29065501.thop1)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	c29065501.summon_effect=e2
	--tohand	
	local e4=Effect.CreateEffect(c)   
	e4:SetDescription(aux.Stringid(29065501,3))  
	e4:SetCategory(CATEGORY_COUNTER)	
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)	
	e4:SetProperty((EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL))   
	e4:SetCode(EVENT_LEAVE_FIELD)  
	e4:SetCondition(c29065501.thcon)	
	e4:SetTarget(c29065501.thtg)	
	e4:SetOperation(c29065501.thop)  
	c:RegisterEffect(e4)	
	--set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(29065501,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,29065502)
	e5:SetCondition(c29065501.condition)
	e5:SetTarget(c29065501.stg)
	e5:SetOperation(c29065501.sop)
	c:RegisterEffect(e5)
end
function c29065501.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) 
end 
function c29065501.thfilter(c)
	return c:IsSetCard(0x87af) or _G["c"..c:GetCode()].named_with_Arknight
end 
function c29065501.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return Duel.IsExistingMatchingCard(c29065501.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end 
end
 function c29065501.thop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP) 
	local tc=Duel.SelectMatchingCard(tp,c29065501.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()	
	local n=1 
	if Duel.IsPlayerAffectedByEffect(tp,29065580) then
	n=n+1
	end
	tc:AddCounter(0x10ae,n)
end
function c29065501.xthfilter(c)
	return aux.IsCodeListed(c,29065500) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c29065501.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065501.xthfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29065501.athfilter(c,tp)
	return c:IsSetCard(0x87af) and c:GetType()==0x20002
end
function c29065501.cfilter(c)
	return c:IsFaceup() and c:IsCode(29065500)
end
function c29065501.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29065501.xthfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	end
end
function c29065501.stfilter(c,tp)
	return c:IsSetCard(0x87af) and c:GetType()==0x20002 and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c29065501.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c29065501.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c29065501.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065501.stfilter,tp,LOCATION_DECK,0,1,1,nil,tp) end
end
function c29065501.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c29065501.stfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end