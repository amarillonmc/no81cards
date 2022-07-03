--方舟骑士-凯尔希
c29065501.named_with_Arknight=1
function c29065501.initial_effect(c)
	aux.AddCodeList(c,29065500,29065501)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29065501,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,29065502)
	e3:SetTarget(c29065501.pctg)
	e3:SetOperation(c29065501.pcop)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e1:SetCountLimit(1,29065504+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c29065501.spcon)
	e1:SetOperation(c29065501.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065501,0))
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,29065501)
	e2:SetTarget(c29065501.thtg)
	e2:SetOperation(c29065501.thop)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	c29065501.summon_effect=e2
end
function c29065501.pcfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM) and not c:IsCode(29065501) and not c:IsForbidden()
end
function c29065501.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c29065501.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c29065501.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c29065501.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c29065501.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsCanRemoveCounter(c:GetControler(),1,1,0x10ae,2,REASON_COST)
end
function c29065501.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,1,0x10ae,2,REASON_RULE)
end
function c29065501.xthfilter(c)
	return aux.IsCodeListed(c,29065500) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c29065501.xthfilter1(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c29065501.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,29065500) then
			return Duel.IsExistingMatchingCard(c29065501.xthfilter,tp,LOCATION_DECK,0,1,nil) end
		return Duel.IsExistingMatchingCard(c29065501.xthfilter1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29065501.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	if not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,29065500) then
		g=Duel.SelectMatchingCard(tp,c29065501.xthfilter,tp,LOCATION_DECK,0,1,1,nil)
	else g=Duel.SelectMatchingCard(tp,c29065501.xthfilter1,tp,LOCATION_DECK,0,1,1,nil) end
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end