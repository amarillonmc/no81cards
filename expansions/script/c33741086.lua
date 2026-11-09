--Healing★Vision
function c33741086.initial_effect(c)
	if not GLITCHYLIB_LOADED then
		Duel.LoadScript("glitchylib_vsnemo.lua")
	end
	Duel.LoadScript("glitchylib_lprecover.lua")
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c33741086.valcheck)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c33741086.regcon)
	e1:SetOperation(c33741086.regop)
	e1:SetLabelObject(e0) 
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_REPLACE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetTargetRange(1,0)
	e2:SetValue(c33741086.damval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--lp
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetTarget(c33741086.lptg)
	e5:SetOperation(c33741086.lpop)
	c:RegisterEffect(e5)
end
function c33741086.valcheck(e,c)
	local g=c:GetMaterial()
	local val=0
	for tc in aux.Next(g) do
		val=val+(tc:GetTextAttack()>0 and tc:GetTextAttack() or 0)
	end
	e:SetLabel(val)
end
function c33741086.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabelObject():GetLabel()~=0
end
function c33741086.regop(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	Duel.Recover(tp,c:GetAttack(),REASON_EFFECT)
end
function c33741086.damval(e,re,val,r,rp,rc)
	if (aux.DamageReplacementEffectAlreadyUsed[e]~=nil or (aux.IsReplacedDamage and aux.DamageReplacementEffectWasApplied)) then return val end
	local tp=e:GetHandlerPlayer()
	if val>Duel.GetLP(tp) then
		aux.IsReplacedDamage=true
		aux.DamageReplacementEffectAlreadyUsed[e]=true
		local fid=e:GetHandler():GetFieldID()
		Duel.RegisterFlagEffect(tp,33741086,0,0,0,fid)
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CUSTOM+33741086)
		e0:SetCountLimit(1)
		e0:SetLabel(fid,val)
		e0:SetCondition(c33741086.damrepcon)
		e0:SetOperation(c33741086.damrepop)
		e0:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e0,tp)
		Duel.IgnoreActionCheck(Duel.RaiseEvent,nil,EVENT_CUSTOM+33741086,re,r,rp,tp,val)
		return 0
	else
		return val
	end
end
function c33741086.damrepcon(e,tp,eg,ep,ev,re,r,rp)
   return Duel.PlayerHasFlagEffectLabel(tp,33741086,e:GetSpecificLabel(1))
end
function c33741086.damrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=c33741086.damrep(e,tp,e:GetSpecificLabel(2))
	aux.DamageReplacementEffectWasApplied=res
	Duel.ResetFlagEffect(tp,33741086)
end
function c33741086.damrep(e,tp,val)
	local c=e:GetHandler()
	if c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_CARD,tp,33741086)
		Duel.SpecialSummonATKDEF(e,c,0,tp,tp,false,false,POS_FACEUP,nil,val)
		return true
	end
	return false
end
function c33741086.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(e:GetHandler():GetPreviousAttackOnField())
end
function c33741086.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)-e:GetLabel())
end
