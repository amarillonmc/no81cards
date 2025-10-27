local m=15004434
local cm=_G["c"..m]
cm.name="织炎鸟-星火之王 荣光"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--des
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.des1tg)
	e4:SetOperation(cm.des1op)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,m)
	e5:SetCondition(cm.des1con)
	e5:SetTarget(cm.des1tg)
	e5:SetOperation(cm.des1op)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,m+1)
	e6:SetCondition(cm.spcon)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
end
function cm.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(15004400)
end
function cm.des1con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE)
end
function cm.des1filter(c)
	return c:IsSetCard(0xaf31) and c:IsType(TYPE_MONSTER)
end
function cm.des1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.des1filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.des1filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.des1op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cm.des1filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	local sg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 and sg:GetCount()>0
		and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(tg)
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function cm.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsType(TYPE_MONSTER) and (c:IsPreviousLocation(LOCATION_MZONE) or c:IsPreviousLocation(LOCATION_HAND) or c:IsPreviousLocation(LOCATION_DECK))
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xaf31) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end