local m=82206082
local cm=_G["c"..m]
cm.name="我太帅了"
function cm.initial_effect(c)
	--pendulum summon  
	aux.EnablePendulumAttribute(c) 
	--debuff  
	local e0=Effect.CreateEffect(c)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e0:SetValue(cm.plimit)  
	c:RegisterEffect(e0) 
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)  
	e1:SetRange(LOCATION_PZONE)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)  
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)  
	e2:SetRange(LOCATION_PZONE)  
	e2:SetTarget(cm.rmtarget)  
	e2:SetTargetRange(0xff,0xff)  
	e2:SetValue(LOCATION_REMOVED)  
	c:RegisterEffect(e2)  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetCode(m)  
	e3:SetRange(LOCATION_PZONE)  
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)  
	e3:SetTargetRange(0xff,0xff)  
	e3:SetTarget(cm.checktg)  
	c:RegisterEffect(e3) 
	--recover
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0)) 
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)  
	e4:SetRange(LOCATION_PZONE)  
	e4:SetCountLimit(1,m)  
	e4:SetCost(cm.cost)  
	e4:SetTarget(cm.rectg)  
	e4:SetOperation(cm.recop)   
	c:RegisterEffect(e4)
	--remove
	local e5=Effect.CreateEffect(c)  
	e5:SetDescription(aux.Stringid(m,1))  
	e5:SetCategory(CATEGORY_REMOVE)  
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e5:SetProperty(EFFECT_FLAG_DELAY)  
	e5:SetCode(EVENT_TO_HAND)  
	e5:SetRange(LOCATION_MZONE)  
	e5:SetCountLimit(1)  
	e5:SetCondition(cm.hdcon)
	e5:SetCost(cm.cost)
	e5:SetTarget(cm.hdtg)  
	e5:SetOperation(cm.hdop)  
	c:RegisterEffect(e5)   
	--spsummon  
	local e6=Effect.CreateEffect(c)  
	e6:SetDescription(aux.Stringid(m,2))  
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e6:SetCode(EVENT_REMOVE)  
	e6:SetProperty(EFFECT_FLAG_DELAY)  
	e6:SetCountLimit(1,82216082)  
	e6:SetCost(cm.cost)
	e6:SetTarget(cm.sptg)  
	e6:SetOperation(cm.spop)  
	c:RegisterEffect(e6)	
end
function cm.plimit(e,se,sp,st)  
	return bit.band(st,SUMMON_TYPE_PENDULUM)~=SUMMON_TYPE_PENDULUM
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=800
	if Duel.IsPlayerAffectedByEffect(tp,82206075) then lp=400 end
	if chk==0 then return Duel.CheckLPCost(tp,lp) end  
	Duel.PayLPCost(tp,lp)  
end  
function cm.splimit(e,c,tp,sumtype,sumpos,targetp)   
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM or not c:IsAttribute(ATTRIBUTE_DARK)
end  
function cm.rmtarget(e,c)  
	return not c:IsLocation(0x80) and not c:IsType(TYPE_SPELL+TYPE_TRAP)  and c:GetOwner()==e:GetHandlerPlayer()  
end  
function cm.checktg(e,c)  
	return not c:IsPublic()  
end  
function cm.recfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x29c)
end  
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.recfilter,tp,LOCATION_MZONE,0,1,nil) end  
	local ct=Duel.GetMatchingGroupCount(cm.recfilter,tp,LOCATION_MZONE,0,nil)  
	Duel.SetTargetPlayer(tp)  
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*800)  
end  
function cm.recop(e,tp,eg,ep,ev,re,r,rp)  
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)  
	local ct=Duel.GetMatchingGroupCount(cm.recfilter,p,LOCATION_MZONE,0,nil)  
	if ct>0 then  
		Duel.Recover(p,ct*800,REASON_EFFECT)  
	end  
end
function cm.cfilter(c,tp)  
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)  
end  
function cm.hdcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(cm.cfilter,1,nil,1-tp)  
end  
function cm.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)  
end  
function cm.hdop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)  
	if g:GetCount()>0 then  
		local sg=g:RandomSelect(tp,1)  
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)  
	end  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end  