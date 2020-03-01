--丛雨
function c9910376.initial_effect(c)
	aux.AddCodeList(c,9910376)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9910376.splimit)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,9910376)
	e2:SetTarget(c9910376.thtg)
	e2:SetOperation(c9910376.thop)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9910377)
	e3:SetCost(c9910376.sumcost)
	e3:SetTarget(c9910376.sumtg)
	e3:SetOperation(c9910376.sumop)
	c:RegisterEffect(e3)
	--change effect type
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(9910376)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	if c9910376.counter==nil then
		c9910376.counter=true
		c9910376[0]=0
		c9910376[1]=0
		local e21=Effect.CreateEffect(c)
		e21:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e21:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e21:SetOperation(c9910376.resetcount)
		Duel.RegisterEffect(e21,0)
		local e22=Effect.CreateEffect(c)
		e22:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e22:SetCode(EVENT_RELEASE)
		e22:SetOperation(c9910376.addcount)
		Duel.RegisterEffect(e22,0)
	end
end
function c9910376.splimit(e,se,sp,st)
	return aux.IsCodeListed(se:GetHandler(),9910376)
end
function c9910376.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c9910376[0]=0
	c9910376[1]=0
end
function c9910376.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local pl=tc:GetPreviousLocation()
		if pl==LOCATION_MZONE and aux.IsCodeListed(tc,9910376) then
			local p=tc:GetReasonPlayer()
			c9910376[p]=c9910376[p]+1
		end
		tc=eg:GetNext()
	end
end
function c9910376.thfilter(c)
	return aux.IsCodeListed(c,9910376) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910376.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=c9910376[tp]
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c9910376.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910376.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=c9910376[tp]
	local g=Duel.GetMatchingGroup(c9910376.thfilter,tp,LOCATION_DECK,0,nil)
	if ct>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c9910376.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9910376.filter(c)
	return aux.IsCodeListed(c,9910376) and c:IsSummonable(true,nil)
end
function c9910376.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910376.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9910376.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910376.filter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
