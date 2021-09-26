--AK-孤岛危机
function c82568067.initial_effect(c)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c82568067.con)
	c:RegisterEffect(e2)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,82568067)
	e4:SetTarget(c82568067.cttg)
	e4:SetOperation(c82568067.ctop)
	c:RegisterEffect(e4)
end
function c82568067.akfilter(c)
	return  c:IsSetCard(0x825) and c:IsFaceup()
end
function c82568067.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c82568067.akfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,2,nil)
end
function c82568067.filter(c)
	return c:IsFaceup()
end
function c82568067.filter2(c)
	return c:IsFaceup() and c:GetCounter(0x5825)>0
end
function c82568067.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c82568067.filter(chkc,e,tp) end
	if chk==0 then return  
		Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c82568067.filter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	local ct=Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c82568067.filter,tp,0,LOCATION_MZONE,1,ct,nil,e,tp)
end
function c82568067.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=g:GetFirst()
	while tc  do	
	  tc:AddCounter(0x5825,1)
	 tc=g:GetNext()
	end
	if Duel.GetMatchingGroupCount(c82568067.filter2,tp,0,LOCATION_MZONE,nil)>0 then
	local g2=Duel.GetMatchingGroup(c82568067.filter2,tp,0,LOCATION_MZONE,nil)
	if g2:GetCount()==0 then return end
	local tc2=g2:GetFirst()
	while tc2  do 
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e1)
	  tc2=g2:GetNext()
	end
	end
end