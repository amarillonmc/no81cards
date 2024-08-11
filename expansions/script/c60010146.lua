--杰帕德-不屈之盾-
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x629,LOCATION_ONFIELD)
	aux.AddSynchroProcedure(c,cm.synfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--summon success
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_COUNTER)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetTarget(cm.tg)
	e11:SetOperation(cm.op)
	c:RegisterEffect(e11)
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--target/atk protection
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(cm.atlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(cm.tglimit)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetCondition(cm.icon)
	e3:SetTarget(cm.indtg)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.cgop)
	c:RegisterEffect(e1)
end
if not cm.cnum then
	cm.cnum=0
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message(cm.cnum)
	local c=e:GetHandler()
	local i=c:GetControler()
	if cm.cnum~=Duel.GetCounter(i,LOCATION_ONFIELD,0,0x629) then
		cm.cnum=Duel.GetCounter(i,LOCATION_ONFIELD,0,0x629)
		Duel.RaiseEvent(c,EVENT_CUSTOM+m,nil,0,i,i,0)
	end
end
function cm.synfilter(c)
	return c:GetCounter(0x629)>0
end
function cm.ctfil(c)
	return c:IsCode(60010143) and c:IsFaceup()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x629)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if e:GetHandler():AddCounter(0x629,1)~=0 and Duel.IsExistingMatchingCard(cm.ctfil,tp,LOCATION_FZONE,0,1,nil) then
			local g=Duel.GetMatchingGroup(cm.ctfil,tp,LOCATION_FZONE,0,nil)
			if #g==0 then return end
			for c in aux.Next(g) do
				c:AddCounter(0x629,1)
			end
		end
	end
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsLocation(LOCATION_MZONE) and not e:GetHandler():IsPosition(POS_FACEUP_DEFENSE) then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end
function cm.atlimit(e,c)
	return c~=e:GetHandler()
end
function cm.tglimit(e,c)
	return c~=e:GetHandler()
end
function cm.icon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsPlayerAffectedByEffect(tp,m+1)
end
function cm.indtg(e,c)
	return c:IsFaceup() and c:GetCounter(0x629)>0
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function cm.cgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m) 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(300)
	e:GetHandler():RegisterEffect(e1)
end