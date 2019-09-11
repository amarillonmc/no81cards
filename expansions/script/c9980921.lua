--亚马逊骑士·New Omega
function c9980921.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x4),1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980921,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,9980921)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c9980921.tg)
	e1:SetOperation(c9980921.op)
	c:RegisterEffect(e1)
	--extra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980921,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,99809210)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c9980921.excost)
	e1:SetOperation(c9980921.exop)
	c:RegisterEffect(e1)
	 --to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980921,2))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,99809211)
	e1:SetCondition(c9980921.con)
	e1:SetTarget(c9980921.tg2)
	e1:SetOperation(c9980921.op2)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980921.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980921.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980921,2))
end
function c9980921.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980921.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9980921.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9980921.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9980921.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9980921.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA+LOCATION_DECK)
	if ct>3 then ct=3 end
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,ct,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c9980921.exop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA+LOCATION_DECK)
	local ct=e:GetLabel()
	if g:GetCount()<ct then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_EXTRA+LOCATION_DECK,ct,ct,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980921,3))
end
function c9980921.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_DESTROY)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9980921.filter2(c)
	return c:IsSetCard(0x4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9980921.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9980921.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980921.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9980921.filter2,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c9980921.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980921,3))
	end
end
