--末氏空骨的转化
function c33330512.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,33330512)
	e1:SetCost(c33330512.cost)
	e1:SetOperation(c33330512.op)
	c:RegisterEffect(e1)
	--tohand2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetTarget(c33330512.thtg)
	e2:SetOperation(c33330512.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e3)
end
function c33330512.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_REMOVED,0,1,nil) end
	local num=Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)
	Duel.ConfirmDecktop(tp,num)
	local gc=Duel.GetDecktopGroup(tp,1):GetFirst()
	e:SetLabel(num)
	e:SetLabelObject(gc)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToDeckAsCost,tp,LOCATION_REMOVED,0,nil)
	Duel.SendtoDeck(sg,nil,1,REASON_COST)
end
function c33330512.opfil(c)
	return c:IsSetCard(0x5552) and c:IsAbleToHand()
end
function c33330512.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local gc=e:GetLabelObject()
	local num=e:GetLabel()
	local sg=Duel.GetDecktopGroup(tp,num)
	local sgc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if sgc~=gc then return end
	if sg:IsExists(c33330512.opfil,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33330512,0)) then
		local thg=sg:FilterSelect(tp,c33330512.opfil,1,1,nil)
		Duel.SendtoHand(thg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,thg)
		sg:RemoveCard(thg:GetFirst())
		Duel.SendtoGrave(sg,REASON_EFFECT)
	else
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end


function c33330512.filter(c)
	return c:IsSetCard(0x5552) and c:IsAbleToHand()
end
function c33330512.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33330512.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33330512.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33330512.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end