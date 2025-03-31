--祭礼魔道士 拉弥亚·月海
function c3057.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c3057.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3057,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,3057)
	e2:SetCondition(c3057.spcon)
	e2:SetOperation(c3057.spop)
	c:RegisterEffect(e2)
	--destroy and draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3057,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,3058)
	e3:SetCost(c3057.descost)
	e3:SetTarget(c3057.destg)
	e3:SetOperation(c3057.desop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(3057,2))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,3059)
	e4:SetCost(c3057.thcost)
	e4:SetTarget(c3057.thtg)
	e4:SetOperation(c3057.thop)
	c:RegisterEffect(e4)
end 
function c3057.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x851)
end
function c3057.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,c)
end
function c3057.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c3057.desfilter(c)
	return c:IsSetCard(0x851) and c:IsAbleToDeckAsCost() and c:IsType(TYPE_MONSTER)
end
function c3057.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c3057.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3057.desfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c3057.desfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c3057.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c3057.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c3057.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c3057.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c3057.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(tp,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
	sg=Duel.GetOperatedGroup()
	local d1=tp
	local tc=sg:GetFirst()
	while tc do
		if tc then
			if tc:GetPreviousControler()==tp then 
				d1=d1+1 
			end
		end
		tc=sg:GetNext()
	end
	if d1>0 then 
		Duel.Draw(tp,d1,REASON_EFFECT) 
	end
end
function c3057.afilter(c)
	return c:IsSetCard(0x851) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c3057.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c3057.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3057.afilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c3057.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c3057.afilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end