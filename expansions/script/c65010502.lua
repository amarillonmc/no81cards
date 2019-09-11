--URBEX-观测者
function c65010502.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65010502)
	e1:SetCost(c65010502.cost)
	e1:SetTarget(c65010502.tg)
	e1:SetOperation(c65010502.op)
	c:RegisterEffect(e1)
	--wudidehuishou
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,65010503)
	e2:SetTarget(c65010502.wdtg)
	e2:SetOperation(c65010502.wdop)
	c:RegisterEffect(e2)
end
c65010502.setname="URBEX"
function c65010502.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==3
	 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c65010502.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function c65010502.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
	local g=Duel.GetDecktopGroup(tp,5)
	Duel.ConfirmCards(tp,g)
	local sg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
	if sg:GetCount()>=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end

function c65010502.wdfil(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function c65010502.wdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65010502.wdfil(chkc) and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) end
	if chk==0 then return Duel.IsExistingTarget(c65010502.wdfil,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_REMOVED,0,1,1,nil)
end
function c65010502.wdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc.setname=="URBEX" then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end