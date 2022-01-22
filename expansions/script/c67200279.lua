--封缄的灾怨之门
function c67200279.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200279,0))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c67200279.target)
	e1:SetOperation(c67200279.activate)
	c:RegisterEffect(e1)  
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200279,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,67200279)
	e2:SetCondition(c67200279.drcon)
	e2:SetTarget(c67200279.drtg)
	e2:SetOperation(c67200279.drop)
	c:RegisterEffect(e2)  
end
function c67200279.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x674)
end
function c67200279.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200279.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c67200279.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200279,0))
	local g=Duel.SelectMatchingCard(tp,c67200279.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,tp,REASON_EFFECT)
	end
end
--
function c67200279.drconfil(c)
	return c:IsSetCard(0x674) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_PENDULUM)
	--or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_FUSION) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))
end
function c67200279.drcon(e,tp,eg,ep,ev,re,r,rp)
	local eeg=eg:Filter(c67200279.drconfil,nil)
	return eeg:GetCount()>0 and eeg:FilterCount(Card.IsAbleToHand,nil)==eeg:GetCount()
end
function c67200279.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local eeg=eg:Filter(c67200279.drconfil,nil)
	local eeeg=eeg:GetFirst()
	while eeeg do
		if eeeg:IsType(TYPE_TOKEN) or eeeg:IsType(TYPE_FUSION) or eeeg:IsType(TYPE_SYNCHRO) or eeeg:IsType(TYPE_XYZ) or eeeg:IsType(TYPE_LINK) then
			Group.RemoveCard(eeg,eeeg)
		end
		eeeg=eeg:GetNext()
	end
	if chk==0 then return eeg:IsExists(Card.IsAbleToHand,1,nil) and eeg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eeg,eeg:GetCount(),0,0)
end
function c67200279.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local eeg=eg:Filter(c67200279.drconfil,nil)
	local eeeg=eeg:GetFirst()
	while eeeg do
		if eeeg:IsType(TYPE_TOKEN) or eeeg:IsType(TYPE_FUSION) or eeeg:IsType(TYPE_SYNCHRO) or eeeg:IsType(TYPE_XYZ) or eeeg:IsType(TYPE_LINK) then
			Group.RemoveCard(eeg,eeeg)
		end
		eeeg=eeg:GetNext()
	end
	if eeg:GetCount()<1 then return end
	Duel.SendtoHand(eeg,nil,REASON_EFFECT)
end
