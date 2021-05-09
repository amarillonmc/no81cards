--方舟骑士-阿
--21.04.29
local m=11451529
local cm=_G["c"..m]
function cm.initial_effect(c) 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.cacon)
	e1:SetCost(cm.cacost)
	e1:SetTarget(cm.catg)
	e1:SetOperation(cm.caop)
	c:RegisterEffect(e1)
end
function cm.cacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.cacost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsControlerCanBeChanged() and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL) and c:IsAttackable() end
	Duel.GetControl(c,1-tp)
end
function cm.catg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function cm.caop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e0)
	local _,res=c:GetAttackableTarget()
	if not c:IsRelateToEffect(e) or not c:IsAttackable() or not res or c:IsControler(tp) or c:IsImmuneToEffect(e) then e0:Reset() return end
	e0:Reset()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BATTLE_ATTACK)
	e1:SetValue(500)
	c:RegisterEffect(e1,true)
	for i=1,15 do Duel.CalculateDamage(c,nil,true) end
	e1:Reset()
	Duel.BreakEffect()
	Duel.GetControl(c,tp)
	--battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(cm.rdcon)
	e2:SetOperation(cm.rdop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(cm.reptg)
	e3:SetValue(cm.repval)
	e3:SetOperation(cm.repop)
	e3:SetOwnerPlayer(tp)
	Duel.RegisterEffect(e3,tp)
	--extra active
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetOperation(cm.adjustop)
	Duel.RegisterEffect(e4,tp)
end
function cm.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	return ep==tp and (a:IsControler(tp) or (b and b:IsControler(tp)))
end
function cm.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
	Duel.ChangeBattleDamage(1-tp,ev*2,false)
end
function cm.rfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return eg:IsExists(cm.rfilter,1,nil,tp) and tg and #tg==3 end
	return true
end
function cm.repval(e,c)
	return cm.rfilter(c,e:GetOwnerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetDecktopGroup(tp,3)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Destroy(tg,REASON_EFFECT+REASON_REPLACE)
end
function cm.ncfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(m+1)==0
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.ncfilter,tp,LOCATION_MZONE,0,nil)
	if #g>0 then
		for tc in aux.Next(g) do
			tc:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			Duel.MajesticCopy(tc,tc)
		end
		Duel.Readjust()
	end
end