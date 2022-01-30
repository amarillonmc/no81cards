local m=53728015
local cm=_G["c"..m]
cm.name="战时领空"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(m)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetTurnPlayer()~=e:GetHandler():GetControler()end)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(cm.adjustop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLED)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.descon)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetTurnPlayer()==e:GetHandler():GetControler()end)
	e5:SetOperation(cm.chainop)
	c:RegisterEffect(e5)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c,tp)return c:IsFaceup() and c:IsType(TYPE_UNION) and Duel.GetFlagEffect(tp,m+c:GetOriginalCode())==0 end,tp,LOCATION_ONFIELD,0,nil,tp)
	if #g==0 then return end
	local cp={}
	local reg=Card.RegisterEffect
	Card.RegisterEffect=function(sc,se,bool)
		if se:GetType()&EFFECT_TYPE_IGNITION>0 and sc:GetType()&TYPE_UNION>0 then table.insert(cp,se:Clone()) end
		return reg(sc,se,bool)
	end
	for tc in aux.Next(g) do
		local code=tc:GetOriginalCode()
		if Duel.GetFlagEffect(tp,m+code)==0 then
			Duel.RegisterFlagEffect(tp,m+code,0,0,0)
			Duel.CreateToken(tp,code)
			for i,v in ipairs(cp) do
				v:SetCode(EVENT_FREE_CHAIN)
				v:SetType(EFFECT_TYPE_QUICK_O)
				v:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
				e1:SetTargetRange(LOCATION_ONFIELD,0)
				e1:SetLabel(code)
				e1:SetTarget(function(e,c)return c:IsOriginalCodeRule(e:GetLabel()) and c:IsHasEffect(m)end)
				e1:SetLabelObject(v)
				Duel.RegisterEffect(e1,tp)
			end
		end
		Card.RegisterEffect=reg
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local ac,bc=Duel.GetAttacker(),Duel.GetAttackTarget()
	if not bc then return false end
	if not ac:IsControler(tp) then ac,bc=bc,ac end
	e:SetLabelObject(bc)
	return ac:IsFaceup() and ac:IsControler(tp) and ac:IsType(TYPE_UNION) and bc:IsControler(1-tp)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetLabelObject()
	if not bc then return false end
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc and bc:IsRelateToBattle() and bc:IsControler(1-tp) then Duel.Destroy(bc,REASON_EFFECT) end
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:GetOriginalType()&TYPE_UNION>0 and rc:IsOnField() and rc:IsControler(tp) then Duel.SetChainLimit(function(e,rp,tp)return tp==rp and not (e:GetHandler():IsType(TYPE_MONSTER) and e:GetHandler():IsOnField())end) end
end
