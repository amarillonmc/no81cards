--闪耀的舞台
function c28390175.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--select
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,28390175)
	e1:SetTarget(c28390175.target)
	e1:SetOperation(c28390175.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28390175,4))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,38390175)
	e2:SetCondition(c28390175.thcon)
	e2:SetTarget(c28390175.thtg)
	e2:SetOperation(c28390175.thop)
	c:RegisterEffect(e2)
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c28390175.splimit)
	c:RegisterEffect(e3)
	--cannot disable summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTarget(c28390175.cdstg)
	c:RegisterEffect(e4)
end
function c28390175.tgfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c28390175.thfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28390175.spfilter(c,e,tp)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c28390175.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c28390175.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c28390175.thfilter,tp,LOCATION_GRAVE,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(c28390175.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(28390175,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(28390175,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(28390175,2)
		opval[off-1]=3
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	elseif sel==2 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	elseif sel==3 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
end
function c28390175.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c28390175.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c28390175.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	elseif sel==3 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c28390175.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c28390175.exfilter(c,tp)
	return c:IsSummonLocation(LOCATION_HAND) and c:GetPreviousControler()==tp
end
function c28390175.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c28390175.exfilter,1,nil,tp)
end
function c28390175.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c28390175.cfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28390175.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if g:IsExists(c28390175.cfilter,1,nil) and Duel.SelectYesNo(p,aux.Stringid(28390175,3)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(p,c28390175.cfilter,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-p,sg)
		Duel.ShuffleHand(p)
	end
	Duel.ShuffleDeck(p)
end
function c28390175.splimit(e,c)
	return not c:IsSetCard(0x283)
end
function c28390175.cdstg(e,c)
	return true
end
