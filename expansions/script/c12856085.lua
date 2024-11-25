--*塔尔塔罗斯 女神祈愿
function c12856085.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12856085.target)
	e1:SetOperation(c12856085.activate)
	c:RegisterEffect(e1)
end
function c12856085.thfilter(c)
	return c:IsSetCard(0x3a7d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c12856085.rarity(c)>0
end
function c12856085.rarity(c)
	if c.SetRarity_SR then
		return 1
	elseif c.SetRarity_SSR then
		return 2
	elseif c.SetRarity_UR then
		return 3
	elseif c.SetRarity_UTR then
		return 4
	else
		return 0
	end
end
function c12856085.fselect(g)
	return g:GetClassCount(c12856085.rarity)==g:GetCount()
end
function c12856085.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c12856085.thfilter,tp,LOCATION_DECK,0,nil)
	local ct=math.max(1,4-Duel.GetFlagEffect(tp,12856085))
	if chk==0 then return g:CheckSubGroup(c12856085.fselect,ct,ct) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12856085.activate(e,tp,eg,ep,ev,re,r,rp,op)
	local g=Duel.GetMatchingGroup(c12856085.thfilter,tp,LOCATION_DECK,0,nil)
	local ct=math.max(1,4-Duel.GetFlagEffect(tp,12856085))
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12856085,0))
	local sg=g:SelectSubGroup(tp,c12856085.fselect,false,ct,ct)
	Duel.ConfirmCards(1-tp,sg)
	local tg=sg:RandomSelect(tp,1):GetFirst()
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,12856085,RESET_PHASE+PHASE_END,0,1)
end
