--邪骨团 杀手
local m=64800137
local cm=_G["c"..m]
Duel.LoadScript("c64800135.lua")
function cm.initial_effect(c)
	local e0=Suyu_02_x.gi(c,m)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.regcon)
	e1:SetOperation(cm.regop)
	e1:SetCost(cm.discost)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(function(e,c)
	local seq=e:GetHandler():GetSequence()
	local tp=e:GetHandlerPlayer()
	return c:IsType(TYPE_EFFECT) and c.setname=="Zx02"
		and aux.GetColumn(c,tp)==seq
	end)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
end
cm.setname="Zx02"
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,code)==0 end
	Duel.RegisterFlagEffect(tp,code,RESET_PHASE+PHASE_END,0,1)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=c:GetBattleTarget()
	e:SetLabelObject(ac)
	return ac and ac:IsFaceup() and ac:IsControler(1-tp) and ac:IsAbleToRemove()
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=e:GetLabelObject()
	if ac:IsFaceup() and ac:IsRelateToBattle() and not ac:IsImmuneToEffect(e) and ac:IsControler(1-tp) then
		Duel.Remove(ac,POS_FACEUP,REASON_EFFECT)
	end
end