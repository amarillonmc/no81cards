--爱妮慕丝的玩偶 莉洁尔
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	--盲堆
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TODECK+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.tgcon)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--特殊召唤    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabelObject(e0)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
    local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3) 
end    
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function s.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and not (c:IsAttribute(ATTRIBUTE_DARK) or c:IsLevel(7))
    	and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    local tg=g:Filter(aux.NecroValleyFilter(s.cfilter),nil)
    if tg:GetCount()>0 then
    	Duel.BreakEffect()
        Duel.ConfirmCards(tp,tg)
        Duel.HintSelection(tg)
        Duel.SendtoDeck(tg,nil,1,REASON_EFFECT) 
    end    
    if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) 
       	and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
       	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
        	Duel.BreakEffect()
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)	           
		end            
    end                
end
function s.spfilter(c,tp,se)
	return c:IsSummonPlayer(tp) and c:IsSetCard(0x64a) and c:IsLevel(7) and c:IsFaceup()
		and (se==nil or c:GetReasonEffect()~=se)
end
function s.filter(c)
	return c:IsFaceup() and c:IsCode(id)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(s.spfilter,1,nil,tp,se)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
        and not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) 
        and Duel.GetFlagEffect(tp,id)==0 end
    Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)     
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
    	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end        
end