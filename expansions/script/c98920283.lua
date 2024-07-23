--机甲黑暗司令官
function c98920283.initial_effect(c)
	 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c98920283.spcon)
	e1:SetOperation(c98920283.spop)
	c:RegisterEffect(e1)
	 --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920283,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,98920283)
	e3:SetTarget(c98920283.destg)
	e3:SetOperation(c98920283.desop)
	c:RegisterEffect(e3)
	local e2=e3:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c98920283.immtg)
	e1:SetValue(c98920283.immval)
	c:RegisterEffect(e1)
end
function c98920283.spfilter(c)
	return c:IsSetCard(0x36) and c:IsAbleToGraveAsCost()
end
function c98920283.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920283.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,nil)
end
function c98920283.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920283.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c98920283.desfilter(c,g)
	return g:IsContains(c)
end
function c98920283.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local cg=e:GetHandler():GetColumnGroup()
	local g=Duel.GetMatchingGroup(c98920283.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,cg)
	local ct=g:FilterCount(Card.IsControler,nil,1-tp)
	local ct1=g:FilterCount(Card.IsControler,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*200)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct1,tp,LOCATION_DECK)
end
function c98920283.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(c98920283.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,cg)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
			local rg=Duel.GetOperatedGroup()
			local ct=rg:FilterCount(Card.IsControler,nil,1-tp)
			local ct1=rg:FilterCount(Card.IsControler,nil,tp)
			if ct>0 then
				Duel.Damage(1-tp,ct*500,REASON_EFFECT)
			end
			local g2=Duel.GetMatchingGroup(c98920283.thfilter,tp,LOCATION_DECK,0,nil)
			if ct1>0 and g2:GetCount()>=ct1 then 
			   local sg=Duel.SelectMatchingCard(tp,c98920283.thfilter,tp,LOCATION_DECK,0,ct1,ct1,nil)
			   Duel.SendtoHand(sg,nil,REASON_EFFECT)
			   Duel.ConfirmCards(1-tp,sg)
		   end
		end
	end
end
function c98920283.thfilter(c)
	return c:IsSetCard(0x36) and c:IsAbleToHand()
end
function c98920283.immtg(e,c)
	return c:IsSetCard(0x36) and c~=e:GetHandler()
end
function c98920283.immval(e,re)
	return re:IsActivated() and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end