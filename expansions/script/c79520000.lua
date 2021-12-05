--暗怨忆刹 巨蟹
function c79520000.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,79520000+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c79520000.hspcon)
	e1:SetOperation(c79520000.hspop)
	e1:SetValue(c79520000.hspval)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79520000.negcon)
	e2:SetOperation(c79520000.negop)
	c:RegisterEffect(e2)
	--xx
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,19520000)
	e3:SetCost(c79520000.xxcost)
	e3:SetTarget(c79520000.xxtg)
	e3:SetOperation(c79520000.xxop)
	c:RegisterEffect(e3)
	if not c79520000.global_check then
		c79520000.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c79520000.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
c79520000.named_with_Constellation=true 
function c79520000.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,79520000,RESET_PHASE+PHASE_END,0,1)
end
function c79520000.spfilter(c,ft)
	return c:IsAbleToGraveAsCost() and c:GetSequence()==3
end
function c79520000.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c79520000.spfilter,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c79520000.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79520000.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79520000.hspval(e,c)
	return 0,8
end
function c79520000.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetFlagEffect(tp,79520000)~=0 and Duel.GetFlagEffect(tp,09520000)==0
end
function c79520000.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(79520000,0)) then return end
	Duel.Hint(HINT_CARD,0,79520000)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
	Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,09520000,RESET_PHASE+PHASE_END,0,1)
	end
end
function c79520000.xxcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c79520000.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4 end
end
function c79520000.ckfil(c,x)
	return x-c:GetSequence()+1==4 
end
function c79520000.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if x<4 then return end
	local g=Duel.GetMatchingGroup(c79520000.ckfil,tp,LOCATION_DECK,0,nil,x)
	g:Select(tp,0,1,nil)
	g:Select(1-tp,0,1,nil)
	local tc=g:GetFirst()
	if tc.named_with_Constellation then
	op=Duel.SelectOption(tp,aux.Stringid(79520000,1),aux.Stringid(79520000,2)) 
		if op==0 then 
		Duel.SendtoHand(tc,tp,REASON_EFFECT+REASON_REVEAL)
		Duel.ConfirmCards(1-tp,tc)
		else 
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL) 
		end
	end
end





