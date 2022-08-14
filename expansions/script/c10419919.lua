--暗金教
local m=10419919
local cm=_G["c"..m]
cm.named_with_Kabal=1
function cm.Kabal(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Kabal
end
function cm.Potion(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Potion
end

function cm.initial_effect(c)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	e0:SetCost(cm.spcost)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
	--spsummon2
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function cm.chainlm(e,ep,tp)
	return tp==ep
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.spfilter(c,e,tp)
	return cm.Kabal(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(Duel.GetTurnCount())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)==g:GetCount() and Duel.GetTurnCount()>=7
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.thcon2)
	e1:SetOperation(cm.thop2)
	Duel.RegisterEffect(e1,tp)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and cm.Kabal(c) and c:IsFaceup()
end
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil,e,tp)
		if ft<=0 or g:GetCount()==0 then return end
		if Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
			if sg and #sg>0 then
				local ct=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

