--爱妮慕丝的玩偶 普尔缇
local s,id,o=GetID()
function s.initial_effect(c)
	--等级改变
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED+LOCATION_SZONE)
	e1:SetCondition(s.lvcon)
	e1:SetValue(7)
	c:RegisterEffect(e1)
	--盲堆    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3) 
	--抽卡    
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetTarget(s.drtg)
	e4:SetOperation(s.drop)
	c:RegisterEffect(e4)   
end    
function s.lvcon(e)
	return Duel.IsExistingMatchingCard(nil,e:GetHandlerPlayer(),LOCATION_GRAVE,0,8,nil)
    	and e:GetHandler():IsFaceupEx()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function s.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and not (c:IsAttribute(ATTRIBUTE_DARK) or c:IsLevel(7))
    	and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    local tg=g:Filter(aux.NecroValleyFilter(s.cfilter),nil)
    if tg:GetCount()>0 then
    	Duel.BreakEffect()     	
        Duel.ConfirmCards(tp,tg)
        Duel.HintSelection(tg)
        Duel.SendtoDeck(tg,nil,1,REASON_EFFECT)
    end
end
function s.disfilter(c)
	return c:IsLevel(3,7) and c:IsDiscardable(REASON_EFFECT)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)    
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,s.disfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)~=0 then
    	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)  
    end
end