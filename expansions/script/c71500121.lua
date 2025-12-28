--治愈真言
function c71500121.initial_effect(c)
	aux.AddSetNameMonsterList(c,0x78f1)
	--act in h
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(71500121,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(c71500121.aihcost)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DICE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,71500121+EFFECT_COUNT_CODE_OATH) 
	e1:SetCost(c71500121.cost)
	e1:SetTarget(c71500121.target)
	e1:SetOperation(c71500121.activate)
	c:RegisterEffect(e1)
	--sort decktop
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c71500121.thtg)
	e2:SetOperation(c71500121.thop)
	c:RegisterEffect(e2)
end 
function c71500121.pbfil(c)  
	return not c:IsPublic() and c:IsSetCard(0x837) and c:IsType(TYPE_MONSTER) 
end 
function c71500121.aihcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71500121.pbfil,tp,LOCATION_HAND,0,1,nil) end
	local pg=Duel.SelectMatchingCard(tp,c71500121.pbfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,pg) 
	Duel.ShuffleHand(tp) 
end
function c71500121.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x78f1,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x78f1,1,REASON_COST)
end 
function c71500121.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c71500121.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chk=true 
	while chk do 
		local x=Duel.TossDice(tp,1) 
		Duel.Recover(tp,x*500,REASON_EFFECT) 
		Duel.BreakEffect()
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.IsCanRemoveCounter(tp,1,1,0x78f1,3,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(71500121,1)) then 
			Duel.RemoveCounter(tp,1,1,0x78f1,3,REASON_EFFECT)
		else 
			chk=false 
		end 
	end 
end 
function c71500121.sthfil(c) 
	return c:IsAbleToHand() and (aux.IsSetNameMonsterListed(c,0x78f1) and c:IsType(TYPE_MONSTER)) 
end 
function c71500121.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71500121.sthfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end
function c71500121.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.SelectMatchingCard(tp,c71500121.sthfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	if tc then 
		Duel.SendtoHand(tc,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,tc) 
	end 
end 



