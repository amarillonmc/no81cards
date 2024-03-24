--噩梦回廊复归
function c67200757.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c67200757.target)
	e1:SetOperation(c67200757.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,67200757)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c67200757.lktg)
	e2:SetOperation(c67200757.lkop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200755,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,67200757)
	e3:SetTarget(c67200757.lktg)
	e3:SetOperation(c67200757.lkop)
	c:RegisterEffect(e3)
end
function c67200757.filter(c)
	return c:IsSetCard(0x367d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c67200757.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200757.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c3285551.setfilter(c)
	return c:IsCode(39568067) and not c:IsForbidden()
end
function c67200757.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local gg=Duel.SelectMatchingCard(tp,c67200757.filter,tp,LOCATION_DECK,0,1,1,nil)
	local g=Duel.GetMatchingGroup(c3285551.setfilter,tp,LOCATION_DECK,0,nil)
	if gg:GetCount()>0 then
		Duel.SendtoHand(gg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,gg)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetCurrentChain()>2 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67200757,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg=g:Select(tp,1,1,nil)
			Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		end
	end
end
--
function c67200757.matfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x367d)
end
function c67200757.lkfilter(c,mg)
	return c:IsLinkSummonable(mg)
end
function c67200757.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c67200757.matfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c67200757.lkfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c67200757.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c67200757.matfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c67200757.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
	local tc=tg:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,mg)
	end
end