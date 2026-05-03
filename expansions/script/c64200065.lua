--精神愿望
local s,id,o=GetID()
function s.initial_effect(c)
	--盖放回合发动
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(s.actcon)
	e0:SetCost(s.actcost)
	c:RegisterEffect(e0)
	--发动
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.dktg)
	e1:SetOperation(s.dkop)
	c:RegisterEffect(e1)
	--复制    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.bkcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.dktg)
	e2:SetOperation(s.dkop)
	c:RegisterEffect(e2)
	--场上送墓回合    
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
end
function s.cfilter1(c,tp)
	return (c:IsSetCard(0x64a) or c:IsLevel(7)) and Duel.IsPlayerCanDiscardDeck(tp,5)
    	and not c:IsPublic() and c:IsType(TYPE_MONSTER)
end        
function s.cfilter2(c,tp)
	return (c:IsSetCard(0x64a) or c:IsLevel(7)) and Duel.IsPlayerCanDiscardDeck(tp,5)
    	and c:IsDiscardable() and c:IsType(TYPE_MONSTER)
end        
function s.actcon(e)
	return e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_HAND,0,1,nil,tp)
    local b2=Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_HAND,0,1,nil,tp)
	if chk==0 then return (b1 or b2) end
    local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,5),0},
		{b2,aux.Stringid(id,6),1})
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_HAND,0,1,1,nil,tp)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
    else   
        Duel.DiscardHand(tp,s.cfilter2,1,1,REASON_COST+REASON_DISCARD,nil,tp)
    end    
end
function s.dktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5)
		and Duel.GetDecktopGroup(tp,5):FilterCount(Card.IsAbleToGrave,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function s.tgfilter(c)
	return c:IsLevel(7) or c:IsSetCard(0x64a) and c:IsAbleToGrave()
end
function s.dkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,5) then
		Duel.ConfirmDecktop(tp,5)
		local g=Duel.GetDecktopGroup(tp,5)
		if g:GetCount()>0 then
			if g:IsExists(s.tgfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
            	local tg=g:Filter(s.tgfilter,nil)
				Duel.DisableShuffleCheck()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=g:FilterSelect(tp,s.tgfilter,1,tg:GetCount(),nil)
				Duel.SendtoGrave(sg,REASON_EFFECT)
                local og=Duel.GetOperatedGroup()	
                local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
                if og:Filter(Card.IsType,nil,TYPE_MONSTER):GetCount()>=2 
                	and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
                	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
                    local sg=dg:Select(tp,1,1,nil)
            		if sg:GetCount()>0 then
                    	Duel.BreakEffect()
						Duel.HintSelection(sg)
						Duel.Destroy(sg,REASON_EFFECT)
            		end 
                end		
			end
        	Duel.ShuffleDeck(tp)
		end
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_ONFIELD) then
    	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
    end
end    
function s.bkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)==0
end