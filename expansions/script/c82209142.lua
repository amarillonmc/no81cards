--堕天使 埃里斯
local m=82209142
local cm=c82209142
function cm.initial_effect(c)
	--cannot special summon  
	local e0=Effect.CreateEffect(c)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetRange(0xef)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	c:RegisterEffect(e0)  
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,m)  
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCondition(cm.spcon)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)  
	--special summon 2  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)  
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,m+10000)  
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCondition(cm.spcon2)
	e2:SetTarget(cm.sptg2)  
	e2:SetOperation(cm.spop2)  
	c:RegisterEffect(e2)  
	if cm.counter==nil then  
		cm.counter=true  
		cm[0]=0  
		cm[1]=0  
		local e3=Effect.CreateEffect(c)  
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)  
		e3:SetCode(EVENT_PHASE_START+PHASE_DRAW)  
		e3:SetOperation(cm.resetcount)  
		Duel.RegisterEffect(e3,0)  
		local e4=Effect.CreateEffect(c)  
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)  
		e4:SetCode(EVENT_DISCARD)  
		e4:SetOperation(cm.addcount)  
		Duel.RegisterEffect(e4,0)  
	end 
end

--add count
function cm.resetcount(e,tp,eg,ep,ev,re,r,rp)  
	cm[0]=0  
	cm[1]=0  
end  
function cm.addcount(e,tp,eg,ep,ev,re,r,rp)  
	local tc=eg:GetFirst()  
	while tc do  
		local pl=tc:GetPreviousLocation()  
		if pl==LOCATION_HAND and tc:IsOriginalSetCard(0xef) then
		local p=tc:GetPreviousControler()  
			cm[p]=cm[p]+1  
		end  
		tc=eg:GetNext()  
	end  
end  

--spsummon 1
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==1-tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.cfilter(c,tp)  
	return c:IsSetCard(0xef) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()   
end  
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp)  
	Duel.SendtoGrave(g,REASON_COST)  
end  
function cm.spfilter(c,e,tp)  
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  

--spsummon 2
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():GetTurnID()==Duel.GetTurnCount() and not e:GetHandler():IsReason(REASON_RETURN)  
end  
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	local ct=math.floor(cm[tp]/2)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) 
		and ct>0 and Duel.IsPlayerCanDraw(tp,ct) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct) 
end  
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then 
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)  
		e1:SetValue(LOCATION_DECKBOT)  
		c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
		local ct=math.floor(cm[tp]/2)
		if ct>0 and Duel.IsPlayerCanDraw(tp,ct) then
			Duel.Draw(tp,ct,REASON_EFFECT)
		end
	end 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e2:SetTargetRange(1,0)  
	e2:SetTarget(cm.splimit)  
	e2:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e2,tp) 
end  
function cm.splimit(e,c)  
	return not c:IsRace(RACE_FAIRY)
end  