--[[
快乐空降！
Happily Raided!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id,o=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
Duel.LoadScript("glitchylib_counters.lua")
function s.initial_effect(c)
	aux.AddEquipSpellEffect(c,true,true,Card.IsFaceup,nil)
	--[[Each time a monster(s) you control with higher ATK/DEF on the field than its original ATK/DEF is destroyed by your opponent and sent to the GY, note that ATK/DEF difference, and the equipped monster immediately gains ATK/DEF equal to the respective ATK/DEF difference, also if that monster(s) had any counters on it, transfer them onto the equipped monster.]]
	aux.RegisterMaxxCEffect(c,id,nil,LOCATION_SZONE,EVENT_TO_GRAVE,s.reccon,s.recopOUT,s.recopIN,s.flaglabel,false,false,nil,aux.AddThisCardInSZoneAlreadyCheck(c))
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(s.regcounter)
	c:RegisterEffect(e2)
	--If the equipped monster would be destroyed by your opponent, destroy this card instead.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e3:SetValue(s.repfilter)
	c:RegisterEffect(e3)
end
--E1
function s.atkval(c)
	return c:GetPreviousAttackOnField()-c:GetBaseAttack()
end
function s.defval(c)
	return c:GetPreviousDefenseOnField()-c:GetBaseDefense()
end
function s.cfilter(c,p)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(p) and c:IsPreviousPosition(POS_FACEUP) and c:GetReasonPlayer()==1-p and c:IsReason(REASON_DESTROY)
		and (c:GetPreviousAttackOnField()>c:GetBaseAttack() or c:GetPreviousDefenseOnField()>c:GetBaseDefense())
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not eg:IsContains(c) and c:GetEquipTarget() and eg:IsExists(aux.AlreadyInRangeFilter(e,s.cfilter),1,nil,tp)
end
function s.flaglabel(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(aux.AlreadyInRangeFilter(e,s.cfilter),nil,tp)
	local atk,def=g:GetSum(s.atkval),g:GetSum(s.defval)
	return atk|(def<<16)
end
function s.recopOUT(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not ec or not ec:IsFaceup() then return end
	Duel.Hint(HINT_CARD,tp,id)
	local g=eg:Filter(aux.AlreadyInRangeFilter(e,s.cfilter),nil,tp)
	local atk,def=g:GetSum(s.atkval),g:GetSum(s.defval)
	if atk>0 or def>0 then
		ec:UpdateATKDEF(atk,def,true,{c,true})
	end
end
function s.recopIN(e,tp,eg,ep,ev,re,r,rp,n)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not ec or not ec:IsFaceup() then return end
	Duel.Hint(HINT_CARD,tp,id)
	local labels={Duel.GetFlagEffectLabel(tp,id)}
	local atk,def=0,0
	for i=1,#labels do
		local val=labels[i]
		local tatk,tdef=val&0xffff,val>>16
		atk,def=atk+tatk,def+tdef
	end
	if atk>0 or def>0 then
		ec:UpdateATKDEF(atk,def,true,{c,true})
	end
end

--E2
function s.cfilter2(c,p)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(p) and c:IsPosition(POS_FACEUP) and c:IsReason(REASON_DESTROY) and c:GetReasonPlayer()==1-p
		and (c:GetAttack()>c:GetBaseAttack() or c:GetDefense()>c:GetBaseDefense()) and c:HasFlagEffect(FLAG_HAD_COUNTER_GLITCHY)
end
function s.regcounter(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if not ec or not ec:IsFaceup() then return end
	local g=eg:Filter(s.cfilter2,nil,tp)
	if #g==0 then return end
	for tc in aux.Next(g) do
		for _,ctype in ipairs({tc:GetFlagEffectLabel(FLAG_HAD_COUNTER_GLITCHY)}) do
			local ct=tc:GetCounter(ctype)
			if ct>0 and ec:IsCanAddCounter(ctype,ct,true) then
				ec:AddCounter(ctype,ct,true)
			end
		end
	end
end

--E3
function s.repfilter(e,re,r,rp)
	return rp==1-e:GetHandlerPlayer()
end