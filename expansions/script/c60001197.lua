--天象点灯灵 澪
function c60001197.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCountLimit(1,60001197+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c60001197.hspcon)
	e1:SetOperation(c60001197.hspop)
	c:RegisterEffect(e1)	
	--to hand and draw 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(60001197,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,10001197) 
	e2:SetTarget(c60001197.thdtg) 
	e2:SetOperation(c60001197.thdop) 
	c:RegisterEffect(e2)  
	--discard and to hand 
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(60001197,1))
	e3:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,10001197) 
	e3:SetCondition(c60001197.ddcon)
	e3:SetTarget(c60001197.ddtg) 
	e3:SetOperation(c60001197.ddop) 
	c:RegisterEffect(e3)  
	if not c60001197.global_check then
		c60001197.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c60001197.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c60001197.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
	if tc:IsSetCard(0x3622) then 
	Duel.RegisterFlagEffect(tc:GetSummonPlayer(),60001197,RESET_PHASE+PHASE_END,0,1) 
	end 
	tc=eg:GetNext()
	end
end
function c60001197.rlfil(c) 
	return c:IsReleasable() and c:IsSetCard(0x3622) 
end 
function c60001197.rlgck(g,tp) 
	return Duel.GetMZoneCount(tp,g)>0   
end 
function c60001197.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c60001197.rlfil,tp,LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(c60001197.rlgck,3,3,tp) and Duel.GetFlagEffect(tp,60001197)>=3 
end
function c60001197.xthfil(c) 
	return c:IsSetCard(0x3622) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
end 
function c60001197.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c60001197.rlfil,tp,LOCATION_ONFIELD,0,nil)
	local sg=g:SelectSubGroup(tp,c60001197.rlgck,false,3,3,tp)
	Duel.Release(sg,REASON_COST) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(c:GetBaseAttack()*10)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(c:GetBaseDefense()*10)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c60001197.hthop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function c60001197.hthfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x3622)   
end 
function c60001197.hthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60001097)
	local g=Duel.GetMatchingGroup(c60001197.hthfil,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>=2 then 
		local sg=g:Select(tp,2,2,nil) 
		Duel.SendtoHand(sg,nil,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
	end
end
function c60001197.thdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,tp,1) 
end 
function c60001197.thdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,1) then 
	Duel.Draw(tp,1,REASON_EFFECT) 
	end 
end 
function c60001197.dckfil(c) 
	return c:IsFaceup() and c:IsCode(60001198)  
end 
function c60001197.ddcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c60001197.dckfil,tp,LOCATION_SZONE,0,1,nil) 
end 
function c60001197.dthfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x3622)  
end 
function c60001197.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) and Duel.IsExistingMatchingCard(c60001197.dthfil,tp,LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,LOCATION_HAND) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE) 
end 
function c60001197.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil,REASON_EFFECT)
	if g:GetCount()<=0 then return end 
	local dg=g:Select(tp,1,1,nil)  
	if Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)~=0 and Duel.IsExistingMatchingCard(c60001197.dthfil,tp,LOCATION_GRAVE,0,1,nil) then 
	local sg=Duel.SelectMatchingCard(tp,c60001197.dthfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
	end 
end 









