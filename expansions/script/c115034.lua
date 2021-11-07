--方舟骑士-清流
c115034.named_with_Arknight=1
function c115034.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,c115034.lcheck)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(115034,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,115034)
	e1:SetCondition(c115034.thcon)
	e1:SetTarget(c115034.thtg)
	e1:SetOperation(c115034.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c115034.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--to extra
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(115035,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,115035)
	e3:SetTarget(c115034.destg)
	e3:SetOperation(c115034.desop)
	c:RegisterEffect(e3)
end
function c115034.mfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c115034.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c115034.mfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c115034.lmfilter(c)
	return c:IsSetCard(0x87af) or _G["c"..c:GetCode()].named_with_Arknight
end
function c115034.lcheck(g)
	return g:IsExists(c115034.lmfilter,1,nil)
end
function c115034.thfilter(c)
	return (c:IsSetCard(0x87af) or _G["c"..c:GetCode()].named_with_Arknight) and c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end
function c115034.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function c115034.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c115034.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c115034.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c115034.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c115034.desfilter(c)
	return c:IsFaceup()
end
function c115034.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsSetCard(0x87af) or _G["c"..c:GetCode()].named_with_Arknight)
end
function c115034.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c115034.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c115034.tefilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingTarget(c115034.desfilter,tp,LOCATION_PZONE,0,1,nil)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c115034.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(24094258,3))
		local g=Duel.SelectMatchingCard(tp,c115034.tefilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoExtraP(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end