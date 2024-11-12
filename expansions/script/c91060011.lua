--拉比林斯的聚会
local m=91060011
local cm=c91060011
function c91060011.initial_effect(c)
		local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33407125,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetCondition(cm.handcon)
	c:RegisterEffect(e3)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(91020022,2))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,m+1)
	e6:SetCost(aux.bfgcost)

	e6:SetTarget(cm.tgf)
	e6:SetOperation(cm.opf)
	c:RegisterEffect(e6)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(cm.acop)

end
function cm.filter(c)
	return c:IsSetCard(0x17e) and c:IsFaceup()
end
function cm.handcon(e)
	return Duel.IsExistingMatchingCard(cm.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	if re:GetHandler()~=e:GetHandler() and e:GetHandler():GetFlagEffect(FLAG_ID_CHAINING)>0 then
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	if eg==nil then
	local eg=Group.CreateGroup()
	eg:AddCard(re:GetHandler())
	elseif eg~=nil then
	eg:AddCard(re:GetHandler())
end
		Duel.RaiseEvent(eg,EVENT_CUSTOM+m,e,0,0,0,0)		
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return  Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.spfilter(c,e,tp)
	return (c:IsSetCard(0x17e)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and  Duel.IsPlayerCanDiscardDeck(tp,3)
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
			and Duel.IsPlayerCanDiscardDeck(tp,1) then
			Duel.BreakEffect()
			Duel.DiscardDeck(tp,3,REASON_EFFECT)
		end
			local te=Duel.IsPlayerAffectedByEffect(tp,33407125)
			if c:IsStatus(STATUS_LEAVE_CONFIRMED) and te and c:IsSetCard(0x17e)
			and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
			and Duel.SelectYesNo(tp,Auxiliary.Stringid(33407125,0)) then
			Duel.BreakEffect() 
			Duel.Hint(HINT_CARD,0,33407125)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
			te:UseCountLimit(tp)
			end

	end
end
function cm.fit1(c,tp,re)
	return  c:GetType()==TYPE_TRAP and not c:IsForbidden()
end
function cm.fit0(c,tp,re)
	return  c:IsSetCard(0x17e) and c:IsAbleToDeck()
end
function cm.tgf(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.fit0),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c) end
end
function cm.opf(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.fit0),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,c)
	if #g>0 then 
	local n=Duel.SendtoDeck(g,nil,3,REASON_EFFECT)
	if n>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.fit1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,n,nil)
	if Duel.SSet(tp,tg)~=0 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.actcon)
	e1:SetTarget(cm.acttg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function cm.actcon(e)
	return Duel.IsExistingMatchingCard(cm.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.acttg(e,c)
	return c:GetType()==TYPE_TRAP
end