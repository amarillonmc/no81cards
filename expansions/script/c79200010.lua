--字界眼科技树
local m=79200010
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetCondition(cm.condition)
	e2:SetValue(RACE_MACHINE)
	c:RegisterEffect(e2)
	--summon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(cm.sumlimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_GRAVE_RACE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetCondition(cm.condition)
	e5:SetValue(RACE_MACHINE)
	c:RegisterEffect(e5)
	--token
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_EQUIP)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e6:SetRange(LOCATION_SZONE) 
	e6:SetCondition(cm.tkcon)
	e6:SetTarget(cm.tktg)
	e6:SetOperation(cm.tkop)
	c:RegisterEffect(e6)
end
function cm.sumlimit(e,c,tp,sumtp)
	return bit.band(sumtp,SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE and c:GetRace()~=RACE_MACHINE 
end
function cm.condition(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY)
		and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_NECRO_VALLEY)
end
function cm.efilter(c,tp)
	local ec=c:GetEquipTarget()
	return ec:IsControler(tp) and ec:IsCode(79200001)
end
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.efilter,1,nil,tp)
end
function cm.filter(c)
	local ec=c:GetEquipTarget()
	return ec:IsControler(tp) and ec:IsSetCard(0x681)
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local a=eg:IsExists(cm.efilter,1,nil,tp)
	local g1=Group.CreateGroup()
	if eg:GetCount()>0 then
		local tac=eg:GetFirst()
		while tac do 
			local tcet=tac:GetEquipTarget()
			g1:AddCard(tcet)
			tac=eg:GetNext()
		end
	end  
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=g1:Select(tp,1,1,nil):GetFirst() 
	Duel.SetTargetCard(tc) 
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1) end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_SETCODE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(0x684)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	Duel.ResetFlagEffect(tp,m)
end



