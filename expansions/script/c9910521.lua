--桃绯斥候 伊那子柚
function c9910521.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910521)
	e1:SetCondition(c9910521.spcon)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LVCHANGE+CATEGORY_ATKCHANGE+CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c9910521.cost)
	e2:SetTarget(c9910521.target)
	e2:SetOperation(c9910521.operation)
	c:RegisterEffect(e2)
end
function c9910521.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c9910521.cfilter(c,tp)
	return not c:IsPublic() and (bit.band(c:GetType(),0x81)==0x81 or c:IsSetCard(0xa950) or c9910521.tdfilter(c,tp))
end
function c9910521.tdfilter(c,tp)
	return c:IsAbleToDeck() and Duel.IsExistingMatchingCard(c9910521.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c9910521.thfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910521.thfilter(c)
	return c:IsSetCard(0xa950) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c9910521.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c9910521.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c9910521.cfilter,tp,LOCATION_HAND,0,1,nil,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c9910521.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
	Duel.SetTargetCard(tc)
	local lab=0
	local cate=0
	if bit.band(tc:GetType(),0x81)==0x81 then
		lab=lab+1
		cate=cate+CATEGORY_LVCHANGE 
	end
	if tc:IsSetCard(0xa950) then
		lab=lab+2
		cate=cate+CATEGORY_ATKCHANGE 
	end
	if bit.band(tc:GetType(),0x81)~=0x81 and not tc:IsSetCard(0xa950) and c9910521.tdfilter(tc,tp) then
		lab=lab+4
		cate=cate+CATEGORY_TODECK+CATEGORY_TOHAND 
		Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
	end
	e:SetLabel(lab)
	e:SetCategory(cate)
end
function c9910521.fselect(g)
	return g:GetClassCount(Card.GetLocation)==g:GetCount()
end
function c9910521.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local lab=e:GetLabel()
	if bit.band(lab,1)~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	if bit.band(lab,2)~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(700)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
	if bit.band(lab,4)~=0 and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_DECK) then
		local g=Duel.GetMatchingGroup(c9910521.thfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,c9910521.fselect,false,2,2)
		if sg and #sg==2 then
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
