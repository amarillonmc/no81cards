--三和弦歌手 凛
function c9910053.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9910053.splimit)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910053)
	e2:SetCondition(c9910053.thcon)
	e2:SetTarget(c9910053.thtg)
	e2:SetOperation(c9910053.thop)
	c:RegisterEffect(e2)
	c9910053.triad_onfield_effect=e2
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,9910093)
	e3:SetCost(c9910053.thcost2)
	e3:SetTarget(c9910053.thtg2)
	e3:SetOperation(c9910053.thop2)
	c:RegisterEffect(e3)
	if not c9910053.global_check then
		c9910053.global_check=true
		TRIAD_ACT_CHECK={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge1:SetTargetRange(1,1)
		ge1:SetTarget(c9910053.chktg)
		ge1:SetOperation(c9910053.chkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c9910053.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c9910053.chktg(e,te,tp)
	e:SetLabelObject(te)
	return true
end
function c9910053.chkop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local code,code2=te:GetHandler():GetCode()
	table.insert(TRIAD_ACT_CHECK,code)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_NEGATED)
	e1:SetLabel(Duel.GetCurrentChain()+1,#TRIAD_ACT_CHECK)
	e1:SetOperation(c9910053.reset)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,0)
	if code2 then
		table.insert(TRIAD_ACT_CHECK,code2)
		local e2=e1:Clone()
		e2:SetLabel(Duel.GetCurrentChain()+1,#TRIAD_ACT_CHECK)
		Duel.RegisterEffect(e2,0)
	end
end
function c9910053.reset(e,tp,eg,ep,ev,re,r,rp)
	local ev0,loc=e:GetLabel()
	if ev==ev0 then table.remove(TRIAD_ACT_CHECK,loc) end
end
function c9910053.clear(e,tp,eg,ep,ev,re,r,rp)
	TRIAD_ACT_CHECK={}
end
function c9910053.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(9910626)
end
function c9910053.thcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and (LOCATION_HAND+LOCATION_GRAVE)&loc~=0
end
function c9910053.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=9 end
end
function c9910053.thfilter(c)
	return c:IsSetCard(0x6957) and c:IsAbleToHand()
end
function c9910053.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return false end
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.ConfirmDecktop(tp,9)
	local g=Duel.GetDecktopGroup(tp,9)
	if #g~=9 then return end
	local ct=g:FilterCount(Card.IsCode,nil,9910051)
	if ct>0 and g:IsExists(Card.IsAbleToHand,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9910053,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g:FilterSelect(tp,Card.IsAbleToHand,1,ct,nil)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.ShuffleHand(tp)
	end
	if ct==0 and Duel.IsExistingMatchingCard(c9910053.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9910053,1)) then
		Duel.BreakEffect()
		local sg2=Duel.SelectMatchingCard(tp,c9910053.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg2)
	end
	Duel.ShuffleDeck(tp)
end
function c9910053.thcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKTOP,REASON_COST)
end
function c9910053.thfilter2(c,tp)
	if not c:IsFaceupEx() or not c:IsAbleToHand(tp) then return false end
	for i=1,#TRIAD_ACT_CHECK do
		local code=TRIAD_ACT_CHECK[i]
		if c:IsCode(code) then return true end
	end
	return false
end
function c9910053.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910053.thfilter2,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c9910053.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910053,2))
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910053.thfilter2),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil,tp)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end
