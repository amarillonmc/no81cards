--狱卵之封龙
function c40009440.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009440,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c40009440.target)
	e2:SetOperation(c40009440.activate)
	c:RegisterEffect(e2) 
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009440,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c40009440.target)
	e1:SetOperation(c40009440.activate)
	c:RegisterEffect(e1)   
end
function c40009440.thfilter(c)
	return c:IsSetCard(0x3f1d) and not c:IsCode(40009440) and c:IsAbleToHand()
end
function c40009440.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c40009440.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil) 
		and Duel.IsExistingMatchingCard(c40009440.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and ct>0 and g:GetCount()>0 end
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,dg:GetCount(),tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c40009440.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
	local ct=dg:GetClassCount(Card.GetCode)
	local g=Duel.GetMatchingGroup(c40009440.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if ct>0 and g:GetCount()>0 then
		Duel.Destroy(dg,REASON_EFFECT)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end


	   
	--if ct==0 or g:GetCount()==0 then return end
	--if ct>g:GetClassCount(Card.GetCode) then return end
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	--local g1=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	--Duel.SendtoHand(g1,nil,REASON_EFFECT)
	--Duel.ConfirmCards(1-tp,g1)
end
