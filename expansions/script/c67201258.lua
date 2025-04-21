--翠帘开幕-“LAYER”
function c67201258.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(677201258,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,67201259)
	e1:SetTarget(c67201258.thtg)
	e1:SetOperation(c67201258.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	 --disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67201258,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+67201258)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,67201258)
	e3:SetCondition(c67201258.spcon)
	e3:SetTarget(c67201258.sptg)
	e3:SetOperation(c67201258.spop)
	c:RegisterEffect(e3)
	if not c67201258.global_check then
		c67201258.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetCondition(c67201258.regcon)
		ge1:SetOperation(c67201258.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c67201258.disfilter(c,tp)
	local b1=c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
	local b2=c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
	return c:IsSetCard(0xa67b) and (b1 or b2) and c:IsControler(tp)
end
function c67201258.regcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g==0 then return false end
	local v=0
	if g:IsExists(c67201258.disfilter,1,nil,0) then v=v+1 end
	if g:IsExists(c67201258.disfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c67201258.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+67201258,re,r,rp,ep,e:GetLabel())
end
--
function c67201258.thfilter(c)
	return c:IsSetCard(0xa67b) and not c:IsCode(67201258) and c:IsAbleToHand()
end
function c67201258.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67201258.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67201258.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67201258.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c67201258.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==tp or ev==PLAYER_ALL
end
function c67201258.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67201258.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end

