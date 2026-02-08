--愉快
local s, id = GetID()

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 目标卡定义
s.target_code = 58844135 -- 人攻智能 救-思-主

function s.checkfield(c)
	return c:IsFaceup() and c:IsCode(s.target_code)
end

function s.penfilter(c)
	return c:IsCode(s.target_code) and (c:IsLocation(LOCATION_DECK) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end

function s.thfilter(c)
	return c:IsLevel(1) and c:IsAttribute(ATTRIBUTE_LIGHT) 
		and c:IsRace(RACE_CYBERSE) and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local can_pendulum = Duel.IsExistingMatchingCard(s.penfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil)
	local has_monster = Duel.IsExistingMatchingCard(s.checkfield,tp,LOCATION_ONFIELD,0,1,nil)
	local can_search = Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	
	if chk==0 then
		return can_pendulum or (has_monster and can_search)
	end	
end

-- 操作处理
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local has_monster = Duel.IsExistingMatchingCard(s.checkfield,tp,LOCATION_ONFIELD,0,1,nil)
	
	if has_monster then
		if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			s.search_effect(e,tp,eg,ep,ev,re,r,rp)
		else
			s.pendulum_effect(e,tp,eg,ep,ev,re,r,rp)
		end
	else
		s.pendulum_effect(e,tp,eg,ep,ev,re,r,rp)
	end
end

function s.pendulum_effect(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.penfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end

function s.search_effect(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end