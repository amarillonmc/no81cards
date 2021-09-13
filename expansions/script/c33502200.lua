--冰汽时代 家园
local m=33502200
local cm=_G["c"..m]
syu=syu or {}
function syu.turnup(c,code,count,tg,op,cate)
	local tc=c
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(code,0))
	if cate~=nil then
		e1:SetCategory(cate)
	end
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	if count~=nil then
		e1:SetCountLimit(count,code)
	end
	if tg~=nil then
		e1:SetTarget(tg)
	end
	e1:SetOperation(op)
	tc:RegisterEffect(e1)
	return e1
end
function syu.tograve(c,code,count,tg,op,cate)
	local tc=c
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(code,1))
	if cate~=nil then
		e1:SetCategory(cate)
	end
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	if count~=nil then
		e1:SetCountLimit(count,code)
	end
	if tg~=nil then
		e1:SetTarget(tg)
	end
	e1:SetOperation(op)
	tc:RegisterEffect(e1)
	return e1
end
-------------------------------
if not cm then return end
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(cm.reptg)
	e1:SetValue(cm.repval)
	e1:SetOperation(cm.repop)
	c:RegisterEffect(e1)
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCost(cm.costchk)
	e2:SetOperation(cm.costop)
	c:RegisterEffect(e2)
	--accumulate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(0x10000000+m)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(cm.acop)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.reccon)
	e5:SetTarget(cm.atktg)
	e5:SetOperation(cm.recop)
	c:RegisterEffect(e5)
end
--e1
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x1a81) 
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),95)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)-1000)
end
--e2
function cm.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,m)
	return Duel.CheckLPCost(tp,ct*500)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end
--e4
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	 local sc=eg:GetFirst()
	 while sc do
		  local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_CANNOT_TRIGGER)
		  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		  sc:RegisterEffect(e1)
		  sc=eg:GetNext()
	 end
end
--e5
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.IsPlayerCanDraw(tp,1)
end
function cm.filter2(c)
	return c:IsAbleToGrave()
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local cg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_ONFIELD,0,nil)
	local sel=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if cg:GetCount()==0 then
		sel=Duel.SelectOption(tp,aux.Stringid(m,3))
	else sel=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4)) end
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=cg:Select(tp,1,1,nil)
		Duel.SetTargetCard(sg)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	end
	e:SetLabel(sel)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if op==1 then
		Duel.SendtoGrave(tc,tp,REASON_EFFECT)
	else
		Duel.SetLP(tp,Duel.GetLP(tp)-1000)
	end
	Duel.Draw(tp,1,REASON_EFFECT)
end