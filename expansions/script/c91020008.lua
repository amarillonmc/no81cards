--真神 神力释放
local m=91020008
local cm=c91020008
function c91020008.initial_effect(c)
	aux.AddCodeList(c,10000010)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(cm.val)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(cm.tg4)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.drcon)
	e5:SetTarget(cm.drtg)
	e5:SetOperation(cm.drop)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(cm.tg6)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,1))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,m)
	e7:SetCost(cm.descost)
	e7:SetTarget(cm.destg)
	e7:SetOperation(cm.desop)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e8:SetRange(LOCATION_SZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(cm.tg8)
	e8:SetLabelObject(e7)
	c:RegisterEffect(e8)
end
function cm.fit0(c,eg)
	return (c:IsCode(10000010) and eg:IsExists(aux.FilterBoolFunction(Card.IsCode,91020014),1,nil)) 
end
function cm.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and  (c:IsCode(91020014) and Duel.IsExistingMatchingCard(aux.FilterBoolFunction(Card.IsCode,10000010),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil)) 
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end

function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(cm.fit0,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,nil,eg)
	local ft=dg:GetCount()
	local b=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local a=math.min(ft,b) 
	local ng=dg:SelectSubGroup(tp,aux.dncheck,flase,1,a,nil)
	local tc2=ng:GetFirst()
	while tc2 do 
	Duel.SpecialSummonStep(tc2,0,tp,tp,true,false,POS_FACEUP) 
	if  tc2:IsCode(10000010) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(4000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		tc2:RegisterEffect(e2)
	end
	tc2=ng:GetNext()
	end
  Duel.SpecialSummonComplete()  
end
--e2
function cm.tg4(e,c)
return c:IsAttribute(ATTRIBUTE_DIVINE)
end
function cm.val(e,te)
return  te:IsActiveType(TYPE_MONSTER) and (te:GetHandler():IsLevelBelow(10) or te:GetHandler():IsRankBelow(10)) and te:GetOwner()~=e:GetOwner() 
end
function cm.tg6(e,c)
return c:IsCode(91020010)
end
function cm.fitl(c,e)
return c:GetReason()&REASON_EFFECT~=0 and c:GetReasonEffect():GetHandler()==e:GetHandler()
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
return  eg:IsExists(cm.fitl,1,nil,e)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.tg8(e,c)
return c:IsCode(91020011)
end
function cm.desfit(c)
	return c:IsReleasable() and c:IsFaceup()
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.SelectMatchingCard(tp,cm.desfit,tp,LOCATION_ONFIELD,0,3,3,nil)
	Duel.Release(g,REASON_COST)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end