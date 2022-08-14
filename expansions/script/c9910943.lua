--匪魔追缉者 夜幕审判人
function c9910943.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,c9910943.lcheck)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910943)
	e1:SetCondition(c9910943.discon)
	e1:SetCost(c9910943.discost)
	e1:SetTarget(c9910943.distg)
	e1:SetOperation(c9910943.disop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,9910944)
	e2:SetCondition(c9910943.thcon)
	e2:SetTarget(c9910943.thtg)
	e2:SetOperation(c9910943.thop)
	c:RegisterEffect(e2)
end
function c9910943.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3954)
end
function c9910943.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.IsChainDisablable(ev)
end
function c9910943.cfilter(c)
	return c:IsFacedown() and c:IsAbleToGraveAsCost()
end
function c9910943.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910943.cfilter,tp,LOCATION_ONFIELD,0,nil)
	if e:GetHandler():IsAbleToGraveAsCost() then g:AddCard(e:GetHandler()) end
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c9910943.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9910943.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c9910943.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c9910943.filter(c,e,tp,check)
	return c:IsSetCard(0x3954) and c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e)
		and (c:IsAbleToHand() or check and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE))
end
function c9910943.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9910943.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp,check) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9910943.filter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp,check)
end
function c9910943.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if aux.NecroValleyNegateCheck(tg) then return end
	local res=false
	if tg:GetCount()>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local b1=tg:FilterCount(Card.IsAbleToHand,nil)==#tg
		local ct=tg:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false,POS_FACEUP_DEFENSE)
		local b2=ct==#tg and ft>=ct and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
		local opt=-1
		if b1 and not b2 then
			opt=Duel.SelectOption(tp,1190)
		elseif not b1 and b2 then
			opt=Duel.SelectOption(tp,1152)+1
		elseif b1 and b2 then
			opt=Duel.SelectOption(tp,1190,1152)
		end
		if opt==0 then
			res=Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 and tg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND)
		elseif opt==1 then
			res=Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0
		end
	end
	if res then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetValue(c9910943.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910943.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
