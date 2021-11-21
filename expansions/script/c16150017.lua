--真王命之大王具
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local m,cm=rk.set(16150017,"SEIOUMEINODAIOUGU")
function cm.initial_effect(c)
	--fusion procedure
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,cm.FusFilter1,cm.FusFilter2)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(cm.tg)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
end
function cm.FusFilter1(c)
	return rk.check(c,"DAIOU") or rk.check(c,"OUMEI") or c:IsType(TYPE_EQUIP)
end
function cm.FusFilter2(c)
	return rk.check(c,"DAIOU") or rk.check(c,"OUMEI") or c:IsType(TYPE_EQUIP)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local tp=c:GetSummonPlayer()
	if not c:IsSummonType(SUMMON_TYPE_FUSION) then return false end
	if Duel.GetFlagEffect(tp,m)==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,4))
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(1,0)
		e1:SetCondition(cm.con)
		e1:SetOperation(cm.op1)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EFFECT_SEND_REPLACE)
		e2:SetTarget(cm.reptg)
		e2:SetValue(cm.repval)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(m,3))
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e3:SetTargetRange(1,0)
		Duel.RegisterEffect(e3,tp)
	end
	Duel.RegisterFlagEffect(tp,m,0,0,0)
end
function cm.sfilter(c)
	return c:IsSummonable(true,nil) and (rk.check(c,"DAIOU") or rk.check(c,"OUMEI") or c:IsSetCard(0xccd))
end
function cm.con(e,tp)
	local num=Duel.GetFlagEffect(tp,m)
	local num2=Duel.GetFlagEffect(tp,m+2)
	if num==nil or num==0 then return false end
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetFlagEffect(tp,m+2)<Duel.GetFlagEffect(tp,m)
end
function cm.op1(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
		Duel.RegisterFlagEffect(tp,m+2,RESET_PHASE+PHASE_END,0,0)
	end
end
function cm.val(e,re)
	local num=Duel.GetFlagEffect(tp,m)
	if num==nil then return 0 end
	return num
end
function cm.repfilter(c,tp)
	return c:IsControler(tp) and (c:IsReason(REASON_LOST_TARGET) or (c:IsReason(REASON_RELEASE) and c:IsReason(REASON_SUMMON)) or c:GetDestination()==LOCATION_DECK) and c:IsLocation(LOCATION_ONFIELD) and c:IsType(TYPE_EQUIP) 
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,eg) end
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local g=eg:Filter(cm.repfilter,nil,tp)
		local ct=g:GetCount()
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			g=g:Select(tp,1,ct,nil)
		end
		local tc=g:GetFirst()
		while tc do
			Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			local ac=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,tc:GetEquipTarget()):GetFirst()
			if not Duel.Equip(tp,tc,ac,true,true) then return end
			
			--equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(ac)
			e1:SetValue(cm.eqlimit)
			tc:RegisterEffect(e1,true)
			tc=g:GetNext()
		end
		Duel.EquipComplete()
		return true
	else return false end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.repval(e,c)
	return true
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function cm.tg(e,c)
	local rc=e:GetHandler()
	local qc=rc:GetEquipTarget()
	if qc then
		local eg=qc:GetEquipGroup() 
		if eg:GetCount()<3 then return false end
		return eg:IsContains(c) or c==qc
	end
	return false 
end