local m=53796063
local cm=_G["c"..m]
cm.name="皇极惊世、惊世无悔"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local f=Card.GetReasonCard
		Card.GetReasonCard=function(c)
			if c:GetFlagEffect(m)>0 then
				local a=Duel.GetAttacker()
				local d=Duel.GetAttackTarget()
				if a==c then return d end
				if d==c then return a end
				return nil
			end
			return f(c)
		end
	end
end
function cm.cfilter(c,tp)
	return c:IsPreviousControler(tp) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	for i=0,1 do
		local g=eg:Filter(cm.cfilter,nil,i)
		local atk=g:GetSum(Card.GetTextAttack)
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,i,LOCATION_MZONE,0,nil)
		for tc in aux.Next(mg) do
			if tc:GetFlagEffect(m+500)==0 then tc:RegisterFlagEffect(m+500,RESET_EVENT+RESETS_STANDARD,0,0,0) end
			local flag=tc:GetFlagEffectLabel(m+500)
			tc:SetFlagEffectLabel(m+500,flag+atk)
		end
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg1,tg2=g:GetMaxGroup(Card.GetAttack),g:GetMaxGroup(Card.GetBaseAttack)
	local label=a:GetFlagEffectLabel(m+500)
	return d and a:IsControler(tp) and label and label>0 and tg1:IsContains(d) and tg2:IsContains(d)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,at=at,a end
	if not a:IsRelateToBattle() or a:IsFacedown() or not at:IsRelateToBattle() or at:IsFacedown() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	e1:SetValue(a:GetFlagEffectLabel(m+500))
	a:RegisterEffect(e1)
	local e2=Effect.CreateEffect(at)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLED)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetOperation(cm.op)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	at:RegisterEffect(e2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:GetAttack()>=bc:GetAttack() then return end
	if bc:GetEffectCount(EFFECT_INDESTRUCTABLE_BATTLE)==1 then return end
	if Duel.Destroy(bc,REASON_BATTLE)==0 then Duel.SendtoGrave(bc,REASON_BATTLE) end
	bc:SetStatus(STATUS_BATTLE_DESTROYED,true)
	Duel.RaiseEvent(c,EVENT_BATTLE_DESTROYING,e,REASON_BATTLE,c:GetControler(),c:GetControler(),0)
	c:RegisterFlagEffect(m,RESET_PHASE+PHASE_DAMAGE,0,0)
	bc:RegisterFlagEffect(m,RESET_PHASE+PHASE_DAMAGE,0,0)
end
