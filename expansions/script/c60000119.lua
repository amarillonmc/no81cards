--游 戏 人 生
function c60000119.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1,60000119+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c60000119.recon)
	e1:SetOperation(c60000119.reop)
	c:RegisterEffect(e1)
	--sigle
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e3)
end
function c60000119.recon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x36a0)
	return g:GetClassCount(Card.GetCode)>=10 and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)<=0 
end
function c60000119.gcheck(g)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c60000119.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(60000119,0)) 
	Duel.RegisterFlagEffect(tp,60000119,0,0,0)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x36a0)
	local sg=g:SelectSubGroup(tp,c60000119.gcheck,false,1,10)
	Duel.ConfirmCards(1-tp,sg)
	if c:IsPreviousLocation(LOCATION_HAND) then
	Duel.Draw(tp,1,REASON_RULE)
	end
end







