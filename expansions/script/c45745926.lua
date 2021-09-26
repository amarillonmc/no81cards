--极翼灵兽 疾风之翼
function c45745926.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45745926,0))  
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c45745926.batg)
	e1:SetOperation(c45745926.baop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(45745926,1))  
	e2:SetCategory(CATEGORY_TODECK)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,45745926)  
	e2:SetCost(aux.bfgcost)  
	e2:SetTarget(c45745926.thtg)  
	e2:SetOperation(c45745926.thop)  
	c:RegisterEffect(e2)  
end
--e1
function c45745926.bafilter1(c)
	return c:IsAttackable() and c:IsSetCard(0x881) and c:IsFaceup()
end
function c45745926.batg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c45745926.bafilter1,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,c45745926.bafilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end
function c45745926.baop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()~=2 then return end
	local ac=tg:Filter(Card.IsControler,nil,tp):GetFirst()
	local at=tg:Filter(Card.IsControler,nil,1-tp):GetFirst()
	Duel.CalculateDamage(ac,at)
end
--e2
function c45745926.filter(c)  
	return c:IsSetCard(0x881) and c:IsFaceup() and not c:IsCode(45745926) and c:IsAbleToGrave()
end  
function c45745926.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c45745926.filter,tp,LOCATION_REMOVED,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)  
end  
function c45745926.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,c45745926.filter,tp,LOCATION_REMOVED,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)  
	end  
end  