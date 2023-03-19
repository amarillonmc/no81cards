--次元追放
function c11560310.initial_effect(c)
	--redirect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e0)	   
	--Activate   
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,11560310)  
	e1:SetTarget(c11560310.actg) 
	e1:SetOperation(c11560310.acop) 
	c:RegisterEffect(e1) 
	--remove  
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_REMOVED) 
	e2:SetHintTiming(0,TIMING_STANDBY_PHASE) 
	e2:SetCountLimit(1,21560310)
	e2:SetCost(c11560310.stcost) 
	e2:SetTarget(c11560310.sttg) 
	e2:SetOperation(c11560310.stop) 
	c:RegisterEffect(e2)
end
c11560310.SetCard_XdMcy=true   
function c11560310.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end 
function c11560310.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:GetCount() 
	local rg=g:Filter(Card.IsAbleToRemove,nil) 
	if rg:GetCount()<=0 then return end  
	local srg=rg:Select(1-tp,1,1,nil) 
	Duel.Remove(srg,POS_FACEUP,REASON_EFFECT) 
	local tg=g:Filter(Card.IsAbleToHand,srg) 
	local stg=tg:Select(tp,1,1,nil) 
	Duel.SendtoHand(stg,tp,REASON_EFFECT)  
	Duel.ConfirmCards(1-tp,stg)
	Duel.ShuffleDeck(tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11560310.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11560310.splimit(e,c)
	return not c.SetCard_XdMcy 
end 
function c11560310.stcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end 
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST) 
end 
function c11560310.stfil(c)
	return c.SetCard_XdMcy and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c11560310.sttg(e,tp,eg,ep,ev,re,r,rp,chk)   
	if chk==0 then return true end 
end 
function c11560310.stop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	--
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(11560310,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(11560310)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)  
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end 







