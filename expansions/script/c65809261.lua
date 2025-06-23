local m=65809261
local cm=_G["c"..m]
cm.name="策略 BOSS 资本家"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetCost(cm.spellcost)
	e2:SetTarget(cm.spelltg)
	e2:SetOperation(cm.spellop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+2)
	e3:SetCost(cm.rmcost)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
end
function cm.spfilter(c)
	return c:IsSetCard(0xaa30) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.spellcostfilter(c,tp)
	return c:GetOwner()~=tp
end
function cm.spellcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spellcostfilter,tp,LOCATION_HAND,0,3,nil,tp) end
	local g=Duel.SelectMatchingCard(tp,cm.spellcostfilter,tp,LOCATION_HAND,0,3,3,nil,tp)
	Duel.ConfirmCards(1-tp,g)
end
function cm.spelltgfilter(c)
	return c:IsSetCard(0xca30) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function cm.spelltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and cm.spelltgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.spelltgfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
	local max=2
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE)==1 then max=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.spelltgfilter,tp,LOCATION_ONFIELD,0,1,max,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cm.spellopfilter(c)
	local check1=c:IsLocation(LOCATION_GRAVE)
	local check2=c:IsLocation(LOCATION_REMOVED) and c:IsPosition(POS_FACEUP)
	local check3=c:IsReason(REASON_DESTROY)
	return (check1 or check2) and check3
end
function cm.spellop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(g,REASON_EFFECT)==0 then return end
	local tg=g:Filter(cm.spellopfilter,nil)
	local zone=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	if #tg>zone then return end
	for tc in aux.Next(tg) do
		Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function cm.rmcostfilter(c,tp)
	return c:GetOwner()~=tp and c:IsDiscardable()
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmcostfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.DiscardHand(tp,cm.rmcostfilter,1,1,REASON_COST+REASON_DISCARD,nil,tp)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_MZONE)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end