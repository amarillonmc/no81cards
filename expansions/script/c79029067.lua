--啸岚寒域 雪境讯使
function c79029067.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c79029067.spcon)
	c:RegisterEffect(e1)	
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c79029067.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79029067,0))
	e4:SetCategory(CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c79029067.thcon)
	e4:SetTarget(c79029067.thtg)
	e4:SetOperation(c79029067.thop)
	c:RegisterEffect(e4)
	if not c79029067.global_check then
		c79029067.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCondition(c79029067.checkcon)
		ge1:SetOperation(c79029067.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
c79029067.named_with_KarlanTrade=true 
function c79029067.checkfil(c)
	return (c:IsAttribute(ATTRIBUTE_WATER) and not c:IsCode(79029067)) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c.named_with_KarlanTrade)
end
function c79029067.checkcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c79029067.checkfil,1,nil)
end
function c79029067.checkop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.RegisterFlagEffect(tp,79029067,RESET_PHASE+PHASE_END,0,1)
end
function c79029067.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and 
	Duel.GetFlagEffect(tp,79029067)~=0 
end
function c79029067.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(79029067,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c79029067.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(79029067)~=0
end
function c79029067.srfil(c,tp)
	return c:IsCode(79029065) and c:GetActivateEffect():IsActivatable(tp)
end
function c79029067.thfil(c,tp)
	return c.named_with_KarlanTrade and (c:IsAbleToHand() or c:IsAbleToGrave())
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_FZONE,0,1,nil,79029065)
end
function c79029067.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029067.thfil,tp,LOCATION_DECK,0,1,nil,tp) or Duel.IsExistingMatchingCard(c79029067.srfil,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029067.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c79029067.thfil,tp,LOCATION_DECK,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(79029067,0)) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c79029067.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end 
	else
	local g=Duel.SelectMatchingCard(tp,c79029067.srfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
end



