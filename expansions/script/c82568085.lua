--AK-黑翼的羽毛笔
function c82568085.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82568085,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,82568085)
	e1:SetCost(c82568085.cost)
	e1:SetTarget(c82568085.target)
	e1:SetOperation(c82568085.operation)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82568085,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetRange(LOCATION_MZONE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,82568085+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c82568085.thcost)
	e2:SetTarget(c82568085.thtg)
	e2:SetOperation(c82568085.thop)
	c:RegisterEffect(e2)
end
function c82568085.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82568085.desfilter(c,atk,e)
	return c:IsFacedown()
end
function c82568085.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	if chk==0 then return Duel.IsExistingMatchingCard(c82568085.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c82568085.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c82568085.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c82568085.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c82568085.costfilter(c)
	local lv=c:GetLevel()
	local code=c:GetCode()
	if c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
		   and Duel.IsExistingMatchingCard(c82568085.thfilter,tp,LOCATION_DECK,0,2,nil,lv,code)
	then local g=Duel.GetMatchingGroup(c82568085.thfilter,tp,LOCATION_DECK,0,nil,lv,code) 
	return g:GetClassCount(Card.GetCode)>=2
	else return false end
end
function c82568085.thfilter(c,lv,code)
	return c:IsLevel(lv) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsSetCard(0x825)
		   and not c:IsCode(code)
end
function c82568085.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568085.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c82568085.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
end
function c82568085.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c82568085.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local lv=tc:GetLevel()
	local code=tc:GetCode()
	local g=Duel.GetMatchingGroup(c82568085.thfilter,tp,LOCATION_DECK,0,nil,lv,code)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.SendtoHand(tg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg1)
end