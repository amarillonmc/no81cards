--明日的方舟·罗德岛
c29065510.named_with_Arknight=1
function c29065510.initial_effect(c)
	c:EnableCounterPermit(0x10ae)
	c:SetCounterLimit(0x10ae,9)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c29065510.target)
	e1:SetOperation(c29065510.activate)
	c:RegisterEffect(e1)
	--search
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(29065510,0))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c29065510.thtg)
	e6:SetOperation(c29065510.thop)
	--c:RegisterEffect(e6)
	--Add Counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c29065510.counter)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	--cannot disable summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTarget(c29065510.cdstg)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e4)
end
function c29065510.thfilter(c)
	return aux.IsCodeListed(c,29065500) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c29065510.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065510.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29065510.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29065510.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c29065510.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_MONSTER)
end
function c29065510.counter(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c29065510.cfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x10ae,ct)
	end
end
function c29065510.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanAddCounter(tp,0x10ae,1,c) end
end
function c29065510.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x10ae,1)
	end
end
function c29065510.cdstg(e,c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end