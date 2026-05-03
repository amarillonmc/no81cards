--魔狼的霸者亲卫队壹号 摩诺诺
local s,id,o=GetID()
function s.initial_effect(c)
	--盲堆
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.tgcost)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--特殊召唤
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function s.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and not (c:IsAttribute(ATTRIBUTE_DARK) or c:IsLevel(7))
    	and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function s.spfilter(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelBelow(3)
    	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()    
    local sg=g:Filter(aux.NecroValleyFilter(s.spfilter),nil,e,tp)
    if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end    
    local tg=g:Filter(aux.NecroValleyFilter(s.cfilter),nil)
    if tg:GetCount()>0 then
    	Duel.BreakEffect()
        Duel.ConfirmCards(tp,tg)
        Duel.HintSelection(tg)
        Duel.SendtoDeck(tg,nil,1,REASON_EFFECT)
    end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetTurnPlayer()==1-tp
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 
		and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then		 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end		
	end	
end