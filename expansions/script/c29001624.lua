--方舟骑士-但书
c29001624.named_with_Arknight=1
function c29001624.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c29001624.matfilter,2,2)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29001624,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,29001624)
	e1:SetCondition(c29001624.thcon)
	e1:SetTarget(c29001624.thtg)
	e1:SetOperation(c29001624.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c29001624.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--Double attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Double attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c29001624.tgtg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c29001624.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c29001624.matfilter(c)
	return c:IsLinkSetCard(0x87af) or (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29001624.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c29001624.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c29001624.mfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c29001624.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL) and c.kinkuaoi_LightAK
end
function c29001624.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function c29001624.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29001624.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29001624.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29001624.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end