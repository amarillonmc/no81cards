--奈莉德-冥河代理人
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x61e)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,2,2)
	--cannot target/indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCondition(cm.imcon)
	e2:SetTarget(cm.immtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.ptcost)
	e1:SetTarget(cm.pttg)
	e1:SetOperation(cm.ptop)
	c:RegisterEffect(e1)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(cm.efilter)
	e5:SetCondition(cm.effcon)
	e5:SetLabel(3)
	c:RegisterEffect(e5)
	local e4=e5:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(cm.efilter)
	c:RegisterEffect(e4)
	--negate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_DISABLE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(cm.discon)
	e6:SetCost(cm.discost)
	e6:SetTarget(cm.distg)
	e6:SetOperation(cm.disop)
	e6:SetLabel(6)
	c:RegisterEffect(e6)
	--atk up
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,2))
	e7:SetCategory(CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(cm.effcon)
	e7:SetTarget(cm.atktg)
	e7:SetOperation(cm.atkop)
	e7:SetLabel(9)
	c:RegisterEffect(e7)
end
function cm.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function cm.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function cm.immtg(e,c)
	return c:IsSetCard(0x61e) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.ptcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.pttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x61e,3) end
end
function cm.ptop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		c:AddCounter(0x61e,3)
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x61e)>=e:GetLabel()
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x61e,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x61e,3,REASON_COST)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsChainNegatable(ev) and Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x61e)>=e:GetLabel()
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetCategory(CATEGORY_DISABLE)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local cont=Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x61e)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x61e,1,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,cont,0,0)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x61e)
	if ct>0 then
		local count=math.min(ct,ct)
		if count>1 then
			local num={}
			local i=1
			while i<=count do
				num[i]=i
				i=i+1
			end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
			count=Duel.AnnounceNumber(tp,table.unpack(num))
			e:SetLabel(count)
		end
		repeat
			Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x61e,1,REASON_EFFECT)
			count=count-1
		until count==0
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-e:GetLabel()*300)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end