local m=15000260
local cm=_G["c"..m]
cm.name="永寂之王神：赛农"
function cm.initial_effect(c)
	--synchro summon  
	c:EnableReviveLimit()
	--special summon rule  
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(m,0)) 
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	e1:SetCondition(cm.sprcon)  
	e1:SetOperation(cm.sprop)  
	c:RegisterEffect(e1)
	--immune  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCode(EFFECT_IMMUNE_EFFECT) 
	e2:SetCondition(cm.tncon)
	e2:SetValue(cm.efilter)  
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)   
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)   
	e3:SetTarget(cm.discost)  
	e3:SetOperation(cm.disop)  
	c:RegisterEffect(e3)
	--SynchroSummon 
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e4:SetOperation(cm.regop)  
	c:RegisterEffect(e4)
end
function cm.filter1(c)
	return c:IsSynchroType(TYPE_TUNER)
end
function cm.filter2(c)
	return not c:IsSynchroType(TYPE_TUNER)
end
function cm.sprfilter(c,sc,tp)  
	return (c:IsSetCard(0xf37) or c:IsSynchroType(TYPE_TUNER)) and c:GetLevel()~=0 and c:IsFaceup() and c:IsCanBeSynchroMaterial(sc) and Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_MZONE,0,1,c,c:GetLevel(),sc)
end  
function cm.xyzfilter(c,x,sc)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and c:IsRank(sc:GetLevel()-x)
end
function cm.sprcon(e)
	local c=e:GetHandler()
	if c==nil then return true end
	local tp=c:GetControler()  
	return Duel.IsExistingMatchingCard(cm.sprfilter,tp,LOCATION_MZONE,0,1,nil,c,tp)
end  
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local tp=c:GetControler()  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g1=Duel.SelectMatchingCard(tp,cm.sprfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	local x=g1:GetFirst():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g2=Duel.SelectMatchingCard(tp,cm.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,x,c)
	g1:Merge(g2)
	c:SetMaterial(g1) 
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_SYNCHRO+REASON_COST)
end
function cm.tncon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetHandler():GetMaterial():IsExists(Card.IsType,1,nil,TYPE_XYZ)
end
function cm.efilter(e,te)  
	local c=te:GetHandler()  
	return (c:IsType(TYPE_TRAP) or te:IsActiveType(TYPE_TRAP)) or ((c:IsType(TYPE_MONSTER) or te:IsActiveType(TYPE_MONSTER)) and c~=e:GetHandler())
end
function cm.disfilter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf37) and c:IsAbleToGraveAsCost() and not c:IsCode(m)
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	local tp=c:GetControler() 
	if chk==0 then return Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_ONFIELD,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.disfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)  
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(cm.dis2con)
	e1:SetOperation(cm.dis2op)
	Duel.RegisterEffect(e1,tp)
end
function cm.dis2con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and (loc==LOCATION_MZONE or loc==LOCATION_GRAVE)
end
function cm.dis2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)  
	if e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) then
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)  
		e1:SetValue(LOCATION_DECKBOT)  
		e:GetHandler():RegisterEffect(e1,true)
	end
end