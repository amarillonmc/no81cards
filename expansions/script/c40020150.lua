--假面骑士 空我/全能形态
local s,id=GetID()

s.named_with_Kuuga=1
function s.Kuuga(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Kuuga
end

if not s.summon_count then s.summon_count={0,0} end

function s.initial_effect(c)



	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_LEVEL)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.lvlval)
	c:RegisterEffect(e4)

	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetCondition(s.checkcon)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function s.checkfilter(c)
	return s.Kuuga(c) and c:IsType(TYPE_MONSTER) 
end
function s.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.checkfilter,1,nil)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.checkfilter,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetControler(),id,0,0,0) 
		tc=g:GetNext()
	end
end

function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0
end

function s.thfilter(c)
	return s.Kuuga(c) and c:IsAbleToHand() and not c:IsCode(id)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.lvlval(e,c)
	local tp=c:GetControler()
	local ct=Duel.GetFlagEffect(tp,id)
	if ct>4 then
		ct=4
	end
	return ct
end
