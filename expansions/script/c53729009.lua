local m=53729009
local cm=_G["c"..m]
cm.name="无上净土根绝神 尼奥阿日阿·心化"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCondition(cm.spcon)
	e5:SetOperation(cm.spop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_BATTLED)
	e6:SetTarget(cm.destg)
	e6:SetOperation(cm.desop)
	c:RegisterEffect(e6)
	if not cm.check then
		cm.check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_MOVE)
		ge2:SetOperation(cm.regop)
		Duel.RegisterEffect(ge2,0)
		cm[0]=Card.SetEntityCode
		Card.SetEntityCode=function(card,code,bool)
			if card:GetFlagEffect(53729059)==0 then
				cm[0](card,code,bool)
				card:RegisterFlagEffect(53729059,0,0,0,card:GetOriginalCode())
			else cm[0](card,code,bool) end
		end
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c)return c:IsFaceup() and c:GetFlagEffect(53729098)==0 end,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(53729098,RESET_EVENT+0x7e0000,0,0)
		tc:RegisterFlagEffect(53729099,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)>0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function(e,c)return c:GetOriginalCode()==c:GetFlagEffectLabel(53729059)end)
	e1:SetValue(2000)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetOperation(cm.imop)
	Duel.RegisterEffect(e3,tp)
	Duel.RegisterFlagEffect(tp,m,0,0,0)
end
function cm.rfilter(c,tp,sc)
	return c:GetOriginalCode()==53729007 and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and (c:IsControler(tp) or c:IsFaceup())
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(REASON_SPSUMMON,tp,cm.rfilter,1,nil,tp,c) and Duel.GetTurnCount()>9
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(REASON_SPSUMMON,tp,cm.rfilter,1,1,nil,tp,c)
	Duel.Release(g,REASON_SPSUMMON)
end
function cm.imfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(53729099)>0 and (c:GetFlagEffect(m)==0 or c:GetFlagEffectLabel(m)~=c:GetOriginalCode()) and (c:IsType(TYPE_SPELL+TYPE_TRAP) or (c:IsSetCard(0x5533) and c:IsType(TYPE_FUSION)))
end
function cm.imop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.imfilter,tp,LOCATION_ONFIELD,0,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(function(e,te)return not te:GetOwner():IsSetCard(0x5533)end)
		e1:SetReset(RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc:ResetFlagEffect(m)
		tc:RegisterFlagEffect(m,RESET_EVENT+0x7e0000,0,1,tc:GetOriginalCode())
	end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then Duel.Destroy(g,REASON_EFFECT) end
end
