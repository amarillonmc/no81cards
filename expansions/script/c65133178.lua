--幻叙从者 希尔伯特·让·昂热
--幻叙从者 希尔伯特·让·昂热
local s,id,o=GetID()
function s.initial_effect(c)
	--Effect 1: Special Summon from Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--Effect 2: Search Level 5+ Talespace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e2c=e2:Clone()
	e2c:SetCode(EVENT_BATTLE_DESTROYING)
	e2c:SetCondition(aux.bdocon)
	c:RegisterEffect(e2c)
	--Effect 3: Search "Time Zero" & Protection
	--Trigger: Battle Phase Start
	local e3a=Effect.CreateEffect(c)
	e3a:SetDescription(aux.Stringid(id,2))
	e3a:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3a:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3a:SetRange(LOCATION_MZONE)
	e3a:SetCountLimit(1,id+o*2)
	e3a:SetTarget(s.tzthtg)
	e3a:SetOperation(s.tzthop)
	c:RegisterEffect(e3a)
	--Trigger: Opponent activates effect (Quick)
	local e3b=Effect.CreateEffect(c)
	e3b:SetDescription(aux.Stringid(id,2))
	e3b:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3b:SetType(EFFECT_TYPE_QUICK_O)
	e3b:SetCode(EVENT_CHAINING)
	e3b:SetRange(LOCATION_MZONE)
	e3b:SetCountLimit(1,id+o*2)
	e3b:SetCondition(s.tzthcon)
	e3b:SetTarget(s.tzthtg)
	e3b:SetOperation(s.tzthop)
	c:RegisterEffect(e3b)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsRace,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,RACE_DRAGON)
end
function s.chainlm(e,rp,tp)
	return not (e:IsActiveType(TYPE_MONSTER) and e:GetHandler():IsRace(RACE_DRAGON))
end
function s.thfilter(c)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetChainLimit(s.chainlm)
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
function s.tzthcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.tzfilter(c)
	return c:IsCode(65133181) and c:IsAbleToHand()
end
function s.tzthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tzfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetChainLimit(s.chainlm)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.efilter(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_DRAGON)
end
function s.tzthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.tzfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
	end
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		--Immune to Dragon effects
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(s.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		--Indestructible by effects
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
