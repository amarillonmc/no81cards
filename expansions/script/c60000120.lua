--侬娜·杰尔
function c60000120.initial_effect(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,60000120)
	e1:SetTarget(c60000120.aptg)
	e1:SetOperation(c60000120.apop)
	c:RegisterEffect(e1)
	--Tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60000120,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10000120)
	e2:SetTarget(c60000120.tgtg)
	e2:SetOperation(c60000120.tgop)
	c:RegisterEffect(e2)
end
function c60000120.aptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c60000120.apop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x36a0)
	if g:GetCount()>0 then 
	local tc=g:GetFirst()
	while tc do
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	tc=g:GetNext()
	end
	end
end
function c60000120.tgfilter(c)
	return c:IsLevel(1) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToGrave()
end
function c60000120.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60000120.tgfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsPreviousLocation(LOCATION_GRAVE) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c60000120.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60000120.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end




