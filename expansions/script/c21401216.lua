--正义之魔导书
local s,id=GetID()
local SET_MAGIDO=0x6e
local SET_SPELLBOOK=0x106e

function s.initial_effect(c)
	--①：送墓，堆墓，然后回收或特召
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--自己墓地有「魔导书」卡存在的场合，盖放的回合也能发动
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e2:SetCondition(s.setcon)
	c:RegisterEffect(e2)
end

function s.setcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.sbfilter,tp,LOCATION_GRAVE,0,1,nil)
end

function s.sbfilter(c)
	return c:IsSetCard(SET_SPELLBOOK)
end

function s.costfilter(c,tp)
	local lv=c:GetLevel()
	return c:IsSetCard(SET_MAGIDO) and c:IsType(TYPE_MONSTER)
		and c:IsHasLevel() and lv>0
		and c:IsAbleToGraveAsCost()
		and Duel.IsPlayerCanDiscardDeck(tp,lv)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetLevel())
	Duel.SendtoGrave(g,REASON_COST)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lv=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,lv)
end

function s.thfilter(c)
	return c:IsSetCard(SET_MAGIDO) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(SET_MAGIDO) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	if lv<=0 then return end
	local ct=Duel.DiscardDeck(tp,lv,REASON_EFFECT)
	if ct==0 then return end
	local thf=aux.NecroValleyFilter(s.thfilter)
	local spf=aux.NecroValleyFilter(s.spfilter)
	local b1=Duel.IsExistingMatchingCard(thf,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(spf,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	if not (b1 or b2) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then return end
	Duel.BreakEffect()
	local op
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	elseif b1 then
		op=0
	else
		op=1
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,thf,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,spf,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
