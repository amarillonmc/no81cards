--Re:CREATORS 阿尔泰尔
local m=33403500
local cm=_G["c"..m]
function cm.initial_effect(c)
		c:SetUniqueOnField(1,0,m)
 --atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))   
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(cm.val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(cm.val)
	c:RegisterEffect(e2)
 --th
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.thcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
   --spsummon proc
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_HAND+LOCATION_DECK)
	e4:SetCondition(cm.spcon)
	e4:SetOperation(cm.spop)
	e4:SetValue(1)
	c:RegisterEffect(e4)
 --draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.tgcon)
	e5:SetCost(cm.tgcost)
	e5:SetTarget(cm.tgtg)
	e5:SetOperation(cm.tgop)
	c:RegisterEffect(e5)
 --inactivatable
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,4))
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EFFECT_CANNOT_INACTIVATE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(cm.efcon)
	e7:SetValue(cm.effectfilter)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(EFFECT_CANNOT_DISEFFECT)
	e8:SetRange(LOCATION_MZONE) 
	e8:SetCondition(cm.efcon)
	e8:SetValue(cm.effectfilter)
	c:RegisterEffect(e8)
  
end
function cm.val(e,c)
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,33403501)*500
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,33403501)>4 
end
function cm.thfilter(c)
	return c:IsSetCard(0x5349)  and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.spfilter1(c)
	return c:IsFacedown()  and c:IsAbleToGraveAsCost()   
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,33403501)>7 and ( (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_SZONE,0,2,nil))
	or (Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_ONFIELD,0,2,nil)
	 and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_MZONE,0,1,nil) ))  
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_ONFIELD,0,2,2,nil,tp)  
	Duel.SendtoGrave(g1,REASON_COST)
	Duel.ShuffleDeck(tp)
	local e12=Effect.CreateEffect(c)	 
		e12:SetType(EFFECT_TYPE_SINGLE)
		e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e12:SetRange(LOCATION_MZONE)
		e12:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e12:SetValue(1)
		e12:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e12)
		local e13=e12:Clone()
		e13:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e13)
	  local e14=Effect.CreateEffect(c)
		e14:SetType(EFFECT_TYPE_SINGLE)
		e14:SetCode(EFFECT_IMMUNE_EFFECT)
		e14:SetRange(LOCATION_MZONE)
		e14:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e14:SetValue(cm.efilter2)
		e14:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e14)
 e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(m,3))
end
function cm.efilter2(e,te)
	return  e:GetHandlerPlayer()~=te:GetOwnerPlayer() or ((not te:GetHandler():IsSetCard(0x5349)) and (not te:GetHandler()==e:GetHandler())) 
end

function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,33403501)>10
end
function cm.cfilter(c)
	return c:IsSetCard(0x5349) and c:IsAbleToDeckAsCost()
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return true end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

function cm.efcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,33403501)>22
end
function cm.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and (te:GetHandler():IsSetCard(0x5349) or  te:GetHandler():IsCode(m)) 
end