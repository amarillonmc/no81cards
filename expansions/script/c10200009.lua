--渊灵-幽光水母
function c10200009.initial_effect(c)
    aux.EnablePendulumAttribute(c)
	--战破抗性
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200009,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c10200009.targt)
	e1:SetValue(1)
	c:RegisterEffect(e1)
    --双召检索
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200009,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,10200009)
	e2:SetTarget(c10200009.tg1)
	e2:SetOperation(c10200009.op1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
    --遗言检索
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10200009,2))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,10200010)
	e4:SetTarget(c10200009.tg2)
	e4:SetOperation(c10200009.op2)
	c:RegisterEffect(e4)
end
function c10200009.targt(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0xe21)
end
-- 1
function c10200009.filter1(c)
	return c:IsSetCard(0xe21) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c10200009.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10200009.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200009.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10200009.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
-- 2
function c10200009.filter2(c)
	return c:IsSetCard(0xe21) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10200009.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10200009.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200009.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10200009.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end