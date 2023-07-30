--我 推 的 孩 子
local m=43990013
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,43990016)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,43990016+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c43990013.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c43990013.decon)
	e2:SetTarget(c43990013.detg)
	e2:SetOperation(c43990013.deop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c43990013.thcon)
	e3:SetTarget(c43990013.thtg)
	e3:SetOperation(c43990013.thop)
	c:RegisterEffect(e3)
	
end
function c43990013.tgfilter(c)
	return c:IsCode(43990016) and c:IsAbleToGrave()
end
function c43990013.spfilter(c,e,tp)
	return c:IsCode(43990016) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c43990013.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c43990013.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c43990013.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if b1 or b2 then
			local s=0
			if b1 and not b2 then
				s=Duel.SelectOption(tp,aux.Stringid(43990013,1))
			end
			if not b1 and b2 then
				s=Duel.SelectOption(tp,aux.Stringid(43990013,2))+1
			end
			if b1 and b2 then
				s=Duel.SelectOption(tp,aux.Stringid(43990013,1),aux.Stringid(43990013,2))
			end
			if s==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,c43990013.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				Duel.SendtoGrave(tc,nil,REASON_EFFECT)
			end
			end
			if s==1 then

			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c43990013.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			local tc=g:GetFirst()
			if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
			end
			end
	end
end
function c43990013.defilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsCode(43990016)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c43990013.decon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c43990013.defilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c43990013.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c43990013.deop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c43990013.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c43990013.thfilter(c)
	return aux.IsCodeListed(c,43990016) and not c:IsCode(43990013) and c:IsAbleToHand()
end
function c43990013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990013.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c43990013.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c43990013.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
