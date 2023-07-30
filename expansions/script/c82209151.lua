--光子幻蝶刺客
local m=82209151
local cm=c82209151
function cm.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),4,2)  
	c:EnableReviveLimit()   
	--search  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCondition(cm.thcon1)  
	e1:SetTarget(cm.thtg1)  
	e1:SetOperation(cm.thop1)  
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))   
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCondition(cm.thcon2)  
	e2:SetTarget(cm.thtg2)  
	e2:SetOperation(cm.thop2)  
	c:RegisterEffect(e2) 
	--Change position  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,2))  
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1)  
	e3:SetCode(EVENT_CHANGE_POS)  
	e3:SetCondition(cm.spcon)  
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.sptg)  
	e3:SetOperation(cm.spop)  
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)  
end  
function cm.counterfilter(c)  
	return c:IsType(TYPE_XYZ) or c:GetSummonLocation()~=LOCATION_EXTRA 
end 
function cm.thcon1(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ) and c:GetMaterial():IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT)
end  
function cm.thfilter1(c)  
	return (c:IsSetCard(0x55) or c:IsSetCard(0x7b)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()  
end  
function cm.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,0))
end  
function cm.thop1(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ) and c:GetMaterial():IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK)
end  
function cm.thfilter2(c)  
	return c:IsCode(52497105) and c:IsSSetable() 
end 
function cm.thfilter3(c)  
	return c:IsCode(75987257) and c:IsSSetable() 
end  
function cm.thfilter4(c)  
	return c:IsCode(63630268) and c:IsSSetable() 
end  
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>2 and Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(cm.thfilter3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(cm.thfilter4,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end 
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1)) 
end  
function cm.thop2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)  
	--select
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)  
	if g1:GetCount()<=0 then return end
	local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter3),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)  
	if g2:GetCount()<=0 then return end
	local g3=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter4),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)  
	if g3:GetCount()<=0 then return end
	--set
	g1:Merge(g2)
	g1:Merge(g3)
	if Duel.SSet(tp,g1)==0 then return end  
	local tc=g1:GetFirst()  
	while tc do  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)  
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1)  
		local e2=e1:Clone() 
		e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)  
		tc:RegisterEffect(e2)  
		tc=g1:GetNext()  
	end  
end
function cm.spcfilter(c)  
	local np=c:GetPosition()  
	local pp=c:GetPreviousPosition()  
	return ((np<3 and pp>3) or (pp<3 and np>3))  
end  
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(cm.spcfilter,1,nil)  
end  
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end  
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
end   
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)  
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_XYZ)  
end  
function cm.spfilter(c,e,tp)  
	return c:IsRace(RACE_WARRIOR) and c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT)
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,2))  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()  
	if tc then  
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  