--疾速骑士鲁邦
function c9980908.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c9980908.lcheck)
	c:EnableReviveLimit()
	 --hand adjust
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980908,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c9980908.handcon)
	e1:SetOperation(c9980908.handop)
	c:RegisterEffect(e1)
	 --tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980908,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,9980908)
	e3:SetCondition(c9980908.thcon)
	e3:SetTarget(c9980908.thtg)
	e3:SetOperation(c9980908.thop)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980908.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980908.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980908,0))
end
function c9980908.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x9bc2)
end
function c9980908.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=5 or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=5
end
function c9980908.handop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local ht1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ht1>=5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,ht1-4,ht1-4,nil)
		g:Merge(sg)
	end
	local ht2=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	if ht2>=5 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_HAND,0,ht2-4,ht2-4,nil)
		g:Merge(sg)
	end
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c9980908.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9980908.thfilter(c)
	return c:IsSetCard(0x9bc2) and not c:IsCode(9980908) and c:IsAbleToHand()
end
function c9980908.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980908.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9980908.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9980908.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end