--迷 之 森 的 相 伴
local m=22348415
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348415,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c22348415.spcost)
	e2:SetTarget(c22348415.sptg)
	e2:SetOperation(c22348415.spop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348415,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,22348415)
	e3:SetCondition(c22348415.thcon)
	e3:SetTarget(c22348415.thtg)
	e3:SetOperation(c22348415.thop)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22348415,2))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,22349415)
	e4:SetCondition(c22348415.drcon)
	e4:SetTarget(c22348415.drtg)
	e4:SetOperation(c22348415.drop)
	c:RegisterEffect(e4)
	if not c22348415.global_check then
		c22348415.global_check=true
		c22348415[0]=0
		c22348415[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_RELEASE)
		ge1:SetOperation(c22348415.count)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c22348415.resetcount)
		Duel.RegisterEffect(ge2,0)
	end
	
end
function c22348415.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c22348415[0]=0
	c22348415[1]=0
end
function c22348415.count(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetPreviousTypeOnField()&TYPE_NORMAL>0 and tc:IsPreviousLocation(LOCATION_MZONE) then
			c22348415[rp]=c22348415[rp]+1
		end
		tc=eg:GetNext()
	end
end
function c22348415.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,TYPE_NORMAL) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,nil,TYPE_NORMAL)
	Duel.Release(g,REASON_COST)
end
function c22348415.spfilter(c,e,tp)
	return c:IsCode(22348402,22348401) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348415.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22348415.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22348415.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22348415.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22348415.thfilter(c)
	return c:IsType(TYPE_NORMAL) and ((c:IsType(TYPE_MONSTER) and not c:IsPreviousLocation(LOCATION_SZONE)) or c:IsPreviousLocation(LOCATION_MZONE))
end
function c22348415.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348415.thfilter,1,nil)
end
function c22348415.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c22348415.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c22348415.drcon(e,tp,eg,ep,ev,re,r,rp)
	return c22348415[tp]>0
end
function c22348415.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,c22348415[tp]) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,c22348415[tp])
end
function c22348415.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,c22348415[tp],REASON_EFFECT)
end