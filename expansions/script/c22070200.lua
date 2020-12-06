--智慧的引导
function c22070200.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c22070200.spcon)
	e2:SetOperation(c22070200.spop)
	c:RegisterEffect(e2)
	--coin
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22070200,0))
	e3:SetCategory(CATEGORY_COIN+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c22070200.cost)
	e3:SetCountLimit(1)
	e3:SetTarget(c22070200.damtg)
	e3:SetOperation(c22070200.damop)
	c:RegisterEffect(e3)
end
c22070200.toss_coin=true
function c22070200.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local g=Duel.GetDecktopGroup(tp,18)
	return g:GetCount()>=18 and (ft>0 or g:IsExists(Card.IsLocation,ct,nil,LOCATION_MZONE))
end
function c22070200.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,c,POS_FACEDOWN)
	local rg=nil
	if ft<=0 then
		rg=g:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
		if ct<18 then
			g:Sub(rg)
			rg:Merge(g1)
		end
	else
		rg=Duel.GetDecktopGroup(tp,18)
	end
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
end
function c22070200.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22070200,0))
	Duel.SelectOption(1-tp,aux.Stringid(22070200,0))
end
function c22070200.filter(c)
	return c:IsAbleToHand()
end
function c22070200.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22070200.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c22070200.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local coin=Duel.TossCoin(tp,1)
	if coin==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c22070200.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SelectOption(tp,aux.Stringid(22070200,1))
			Duel.SelectOption(1-tp,aux.Stringid(22070200,1))
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.SelectOption(tp,aux.Stringid(22070200,2))
		Duel.SelectOption(1-tp,aux.Stringid(22070200,2))
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
