--噪声恶魔
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x624)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	--attackup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(cm.incon)
	e3:SetValue(2000)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetCondition(cm.incon)
	e3:SetValue(2000)
	c:RegisterEffect(e3)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCondition(cm.atkcon)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==ep then
		Duel.RegisterFlagEffect(ep,m,0,0,1)
	end
end
function cm.incon(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,m)<7 then
		Duel.Damage(tp,1000,REASON_EFFECT)
	elseif c:IsRelateToEffect(e) then
		c:AddCounter(0x624,1)
		Duel.RegisterFlagEffect(tp,60002148,0,0,1)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		if g and Duel.Destroy(g,REASON_EFFECT)~=0 then
			local num=#Duel.GetOperatedGroup()
			for i=1,num do
				if c:IsRelateToEffect(e) then
					c:AddCounter(0x624,1)
					Duel.RegisterFlagEffect(tp,60002148,0,0,1)
				end
			end
		end
	end
end

function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and c:GetCounter(0x624)~=0 
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local num=e:GetHandler():GetCounter(0x624)+1
	for i=1,num do
		Duel.Damage(1-tp,400,REASON_EFFECT)
		Duel.Recover(tp,400,REASON_EFFECT)
		Duel.BreakEffect()
	end
end