--百千抉择的城邦
function c67201128.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67201128,3))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c67201128.sptg)
	e1:SetOperation(c67201128.spop)
	c:RegisterEffect(e1)   
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67201128,0))
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CUSTOM+67201128)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,67201128)
	e3:SetCondition(c67201128.opcon)
	e3:SetTarget(c67201128.optg)
	e3:SetOperation(c67201128.opop)
	c:RegisterEffect(e3) 
	if not c67201128.global_check then
		c67201128.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetCondition(c67201128.regcon)
		ge1:SetOperation(c67201128.regop)
		Duel.RegisterEffect(ge1,0)
	end  
end
function c67201128.regfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c67201128.regcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==0 then return false end
	local v=0
	if eg:IsExists(c67201128.regfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(c67201128.regfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c67201128.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+67201128,re,r,rp,ep,e:GetLabel())
end
--
function c67201128.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
end
function c67201128.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
--
function c67201128.opcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==1-tp or ev==tp or ev==PLAYER_ALL
end
function c67201128.filter(c)
	return c:IsSetCard(0x3670) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c67201128.filter2(c)
	return c:IsAbleToDeck()
end
function c67201128.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c67201128.filter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c67201128.filter2,tp,LOCATION_GRAVE,0,2,nil)
	if chk==0 then return b1 or b2 end
end
function c67201128.opop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c67201128.filter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c67201128.filter2,tp,LOCATION_GRAVE,0,2,nil)
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(67201128,1),aux.Stringid(67201128,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(67201128,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(67201128,2))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c67201128.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67201128.filter2),tp,LOCATION_GRAVE,0,2,2,nil)
		if g1:GetCount()>0 then
			Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
		end
	end
end