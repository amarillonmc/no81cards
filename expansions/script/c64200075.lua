--漂浮泡沫之魔眼 巴丝莉
local s,id,o=GetID()
function s.initial_effect(c)
	--手卡特召
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--送去墓地    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--回到卡组    
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
    e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetTarget(s.tdtg)
	e4:SetOperation(s.tdop)
	c:RegisterEffect(e4)        
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetTurnPlayer()==1-tp
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
    	Duel.BreakEffect()
    	Duel.Recover(tp,ev,REASON_EFFECT)
    end 
end    
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
end
function s.tdfilter(c)
	return c:IsCode(id) and c:IsAbleToDeck()
end    
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
    	and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end    
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tdfilter),tp,LOCATION_GRAVE,0,1,1,c)
	if g:GetCount()>0 then
    	g:AddCard(c)
        Duel.HintSelection(g)
        if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
        	local oc=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
        	if oc<=0 then return end
            Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
			local sg=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_MZONE,0,1,1,nil)
			if sg:GetCount()>0 then            
            	Duel.HintSelection(sg)
                Duel.Destroy(sg,REASON_EFFECT)
            end
        end
    end
end