--九纹龙伊丽莎
function c77096001.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77096001,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c77096001.ntcon)
	e1:SetOperation(c77096001.ntop)
	c:RegisterEffect(e1) 
	--search
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,77096001)
	e2:SetTarget(c77096001.thtg)
	e2:SetOperation(c77096001.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c77096001.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) 
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c77096001.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(1500)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	c:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(3) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	c:RegisterEffect(e1) 
end
function c77096001.thfilter(c)
	return c:IsSetCard(0x79,0x7c) and c:IsAbleToHand()
end
function c77096001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77096001.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77096001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77096001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end




