--逆之天驱
local m=40010088
local cm=_G["c"..m]
cm.named_with_Drive=1
cm.named_with_Reverse=1
function cm.Drive(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Drive
end
function cm.Reverse(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Reverse
end
function cm.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)   
	--to deck top
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.dtcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.dttg)
	e2:SetOperation(cm.dtop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3) 
end
function cm.thfilter(c)
	return cm.Drive(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.spfilter(c,e,tp)
	return (c:IsRace(RACE_PYRO) or cm.Reverse(c)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	   if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		   Duel.ConfirmCards(1-tp,g)
			local tg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
			if tg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tc=tg:Select(tp,1,1,nil)
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and cm.Reverse(c) and c:IsSummonPlayer(tp)
end
function cm.dtcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.dtfilter(c)
	return (cm.Drive(c) or cm.Reverse(c)) and c:IsType(TYPE_MONSTER) 
end
function cm.dttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1
		and Duel.IsExistingMatchingCard(cm.dtfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.dtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local g=Duel.SelectMatchingCard(tp,cm.dtfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end