--个人行动·如你所愿
function c79029472.initial_effect(c)
	--to hand 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029472)
	e1:SetCost(c79029472.thcost)
	e1:SetTarget(c79029472.thtg)
	e1:SetOperation(c79029472.thop)
	c:RegisterEffect(e1)
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,79029472)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79029472.datg)
	e2:SetOperation(c79029472.daop)
	c:RegisterEffect(e2)
end
function c79029472.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c79029472.thfil1(c)
	return c:IsCode(79029347) and c:IsAbleToHand()
end
function c79029472.thfil2(c)
	return c:IsCode(79029346) and c:IsAbleToHand()
end
function c79029472.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029472.thfil1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c79029472.thfil2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c79029472.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c79029472.thfil1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c79029472.thfil2,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()<=0 or g2:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg2=g2:Select(tp,1,1,nil) 
	sg1:Merge(sg2)
	Debug.Message("你们站远一些好了，不喜欢接下来的事情的话，就不要看这边。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029472,0))
	Duel.SendtoHand(sg1,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg1) 
end
function c79029472.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetFirst():IsSetCard(0xa900) and eg:GetFirst():IsType(TYPE_RITUAL) and eg:GetFirst():IsType(TYPE_MONSTER) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,eg:GetFirst():GetBaseAttack())   
end
function c79029472.daop(e,tp,eg,ep,ev,re,r,rp,chk)
	Debug.Message("痛的话就叫出来，会好受些的。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029472,1))
	Duel.Damage(1-tp,eg:GetFirst():GetBaseAttack(),REASON_EFFECT)   
end




