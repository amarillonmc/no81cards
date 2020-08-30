local m=82224071
local cm=_G["c"..m]
cm.name="连接之黑魔导师"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,nil,3,3,cm.lcheck)  
	c:EnableReviveLimit() 
	--base atk  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetOperation(cm.atkop)  
	c:RegisterEffect(e1) 
	--destroy  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)  
	e2:SetCode(EVENT_LEAVE_FIELD)  
	e2:SetCondition(cm.descon)  
	e2:SetTarget(cm.destg)  
	e2:SetOperation(cm.desop)  
	c:RegisterEffect(e2)  
	--spsummon  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))  
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e4:SetType(EFFECT_TYPE_IGNITION)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetCountLimit(1,m)  
	e4:SetCost(cm.spcost)  
	e4:SetTarget(cm.sptg)  
	e4:SetOperation(cm.spop)  
	c:RegisterEffect(e4)   
end
function cm.lcheck(g,lc)  
	return g:IsExists(cm.matfilter,1,nil)  
end  
function cm.matfilter(c)  
	return c:IsLinkRace(RACE_SPELLCASTER) and c:IsLinkAttribute(ATTRIBUTE_DARK)
end  
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local lg=c:GetMaterial()
	if not (c:IsSummonType(SUMMON_TYPE_LINK) and lg:IsExists(Card.IsLinkCode,1,nil,46986414)) then return end  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_SET_BASE_ATTACK)  
	e1:SetValue(4000)  
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)  
	c:RegisterEffect(e1)  
end 
function cm.desfilter(c)  
	return c:IsType(TYPE_SPELL+TYPE_TRAP) 
end  
function cm.descon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsPreviousPosition(POS_FACEUP)  
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD,0,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD,0,nil)  
	Duel.Destroy(g,REASON_EFFECT)  
end  
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end  
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_DISCARD+REASON_COST,nil)  
end  
function cm.spfilter(c,e,tp)  
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK) and (c:IsLevel(6) or c:IsLevel(7)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)   
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)  
	if g:GetCount()>0 and Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP) then
		if g:GetFirst():IsCode(46986414) then
			return Duel.SpecialSummonComplete()
		end
		g:GetFirst():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		e1:SetCode(EVENT_PHASE+PHASE_END)  
		e1:SetCountLimit(1)  
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)   
		e1:SetLabelObject(g:GetFirst())  
		e1:SetCondition(cm.tdcon)  
		e1:SetOperation(cm.tdop)  
		e1:SetReset(RESET_PHASE+PHASE_END)  
		Duel.RegisterEffect(e1,tp)  
	end  
	Duel.SpecialSummonComplete()
end  
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)  
	local tc=e:GetLabelObject()  
	return tc:GetFlagEffect(m)~=0  
end  
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=e:GetLabelObject()  
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)  
end  