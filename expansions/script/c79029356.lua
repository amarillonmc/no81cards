--红·瑟谣浮收藏-猎狼人
function c79029356.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa900),4,2)
	c:EnableReviveLimit()
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029038)
	c:RegisterEffect(e2) 
	--th
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029356)
	e1:SetTarget(c79029356.thtg)
	e1:SetOperation(c79029356.thop)
	c:RegisterEffect(e1)   
	--tg
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,09029356)
	e2:SetCost(c79029356.tgcost)
	e2:SetTarget(c79029356.tgtg)
	e2:SetOperation(c79029356.tgop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(aux.bdocon)
	e3:SetTarget(c79029356.thtg1)
	e3:SetOperation(c79029356.thop1)
	c:RegisterEffect(e3)
end
function c79029356.thfil(c) 
	return c:IsAbleToHand() and (c:IsSetCard(0xb90d) or c:IsSetCard(0xc90e))
end
function c79029356.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029356.thfil,tp,LOCATION_DECK,0,1,nil) end
	Debug.Message("红该做什么？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029356,0))
	local g=Duel.SelectMatchingCard(tp,c79029356.thfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_DECK)
end
function c79029356.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end
function c79029356.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029356.tgfil(c) 
	return c:IsAbleToGrave() and c:IsSetCard(0xa904)
end
function c79029356.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_ONFIELD,0,nil,0xa900)
	local xct=lg:GetClassCount(Card.GetCode)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029356.tgfil,tp,LOCATION_DECK,0,1,nil) and xct>=1 end
	Debug.Message("只要对狩猎有利。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029356,1))
	local g=Duel.SelectMatchingCard(tp,c79029356.tgfil,tp,LOCATION_DECK,0,1,xct,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,tp,LOCATION_DECK)
end
function c79029356.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c79029356.thfil1(c)  
	return c:IsAbleToHand() and c:IsSetCard(0xa904)
end
function c79029356.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029356.thfil1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Debug.Message("全灭。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029356,2))
	local g=Duel.SelectMatchingCard(tp,c79029356.thfil1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,0)
end
function c79029356.thop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end








