--囚笼的图书馆
function c29010407.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,29010407+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--must attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x7a1))
	c:RegisterEffect(e2)	
	--excavate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29010407,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c29010407.thtg)
	e3:SetOperation(c29010407.thop)
	c:RegisterEffect(e3)
end
function c29010407.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=10 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK) 
end 
function c29010407.thfilter(c)
	return c:IsSetCard(0x7a1) and c:IsAbleToHand()
end
function c29010407.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,10)
	local g=Duel.GetDecktopGroup(tp,10)
	if g:GetCount()>0 then
		if g:IsExists(c29010407.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(29010407,2)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c29010407.thfilter,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		end
		Duel.ShuffleDeck(tp)
	end
end









