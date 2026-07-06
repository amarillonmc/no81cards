--归心剑 枭雄·武帝
function c88888322.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c88888322.matfilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0x8907),true)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(88888322,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCountLimit(1,88888322+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c88888322.spcon)
	e0:SetTarget(c88888322.sptg)
	e0:SetOperation(c88888322.spop)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88888322,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,18888322)
	e1:SetCondition(c88888322.thcon)
	e1:SetTarget(c88888322.thtg)
	e1:SetOperation(c88888322.thop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88888322,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c88888322.descon)
	e2:SetCost(c88888322.descost)
	e2:SetTarget(c88888322.destg)
	e2:SetOperation(c88888322.desop)
	c:RegisterEffect(e2)
end
function c88888322.matfilter(c)
	return c:IsLevelAbove(7) and c:IsFusionSetCard(0x8907)
end
function c88888322.spfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x8907) and c:GetOriginalType()&TYPE_MONSTER~=0 
		and (c:IsAbleToHandAsCost() or c:IsAbleToExtraAsCost()) and Duel.GetMZoneCount(tp,c)>0
end
function c88888322.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c88888322.spfilter,tp,LOCATION_ONFIELD,0,2,nil,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88888322.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c88888322.spfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:SelectSubGroup(tp,aux.mzctcheck,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c88888322.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoHand(g,nil,REASON_SPSUMMON)
end
function c88888322.thfilter(c)
	return c:IsSetCard(0x8907) and c:IsAbleToHand()
end
function c88888322.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c88888322.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88888322.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88888322.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88888322.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c88888322.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c88888322.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8907) and c:GetOriginalType()&TYPE_MONSTER~=0 
		and (c:IsAbleToHandAsCost() or c:IsAbleToExtraAsCost())
end
function c88888322.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88888322.costfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local tg=Duel.SelectMatchingCard(tp,c88888322.costfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoHand(tg,nil,REASON_COST)
end
function c88888322.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c88888322.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT) end
end