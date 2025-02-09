if FLAG_ALREADY_CHANGED_BATTLE_RECOVER then return end

--Modified functions for LP-recovering effects
EFFECT_CHANGE_RECOVER					= 1508
FLAG_ALREADY_CHANGED_BATTLE_RECOVER		= 33720325

local duel_recover, duel_damage, aux_damcon1 = Duel.Recover, Duel.Damage, Auxiliary.damcon1

Duel.Recover = function(p,v,r,...)
	aux.IsRecoverFunctionCalled=true
	for _,e in ipairs({Duel.IsPlayerAffectedByEffect(p,EFFECT_NO_RECOVER)}) do
		if e:Evaluate(p,v,r,...) then
			aux.IsRecoverFunctionCalled=false
			return 0
		end
	end
	local eset={Duel.IsPlayerAffectedByEffect(p,EFFECT_CHANGE_RECOVER)}
	if #eset>0 then
		local eff
		for _,e in ipairs(eset) do
			local res=e:Evaluate(r,v,self_reference_effect,0)
			if res and (#eset==1 or Duel.SelectEffectYesNo(e:GetHandlerPlayer(),e:GetHandler())) then
				eff=e
				break
			end
		end
		
		if eff then
			local val=eff:Evaluate(r,v,self_reference_effect,1)
			if val then
				local res=duel_recover(p,val,r,...)
				aux.IsRecoverFunctionCalled=false
				return res
			end
		end
	end
	
	local res=duel_recover(p,v,r,...)
	aux.IsRecoverFunctionCalled=false
	return res
end

if not aux.DamageReplacementEffectAlreadyUsed then aux.DamageReplacementEffectAlreadyUsed={} end

Duel.Damage = function(p,v,r,...)
	aux.IsDamageFunctionCalled=true
	local re=self_reference_effect
	local rp=self_reference_tp
	
	if not aux.CheckOnlyReplaceDamage then
		local revdamcheck=fasle
		local revdam={Duel.IsPlayerAffectedByEffect(p,EFFECT_REVERSE_DAMAGE)}
		for _,e in ipairs(revdam) do
			local res=e:Evaluate(r,rp,re:GetHandler())
			if res then
				revdamcheck=true
				break
			end
		end
		if revdamcheck and Duel.IsPlayerAffectedByEffect(p,EFFECT_CHANGE_RECOVER) then
			for _,e in ipairs({Duel.IsPlayerAffectedByEffect(p,EFFECT_NO_RECOVER)}) do
				if e:Evaluate(p,v,r,...) then
					return 0
				end
			end
			
			local eset={Duel.IsPlayerAffectedByEffect(p,EFFECT_CHANGE_RECOVER)}
			if #eset>0 then
				local eff
				for _,e in ipairs(eset) do
					local res=e:Evaluate(r|REASON_RDAMAGE,v,re,0)
					if res and (#eset==1 or Duel.SelectEffectYesNo(e:GetHandlerPlayer(),e:GetHandler())) then
						eff=e
						break
					end
				end
				
				if eff then
					local val=eff:Evaluate(r|REASON_RDAMAGE,v,self_reference_effect,1)
					if val then
						local res=duel_recover(p,val,r,...)
						aux.IsDamageFunctionCalled=false
						return res
					end
				end
			end
		end
	end
	
	local res=duel_damage(p,v,r,...)
	
	--EFFECT_REPLACE_DAMAGE mods
	if aux.IsReplacedDamage then
		aux.CheckOnlyReplaceDamage=true
		if res==0 and not aux.DamageReplacementEffectWasApplied then
			res=Duel.Damage(p,v,r,...)
		end
		aux.CheckOnlyReplaceDamage=false
		aux.IsReplacedDamage=false
		aux.ClearTableRecursive(aux.DamageReplacementEffectAlreadyUsed)
	end
	
	aux.IsDamageFunctionCalled=false
	return res
end
Auxiliary.damcon1 = function(e,tp,eg,ep,ev,re,r,rp)
	local e1=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_DAMAGE)
	local e2=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)
	local rd=e1 and not e2
	local rr=not e1 and e2
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	local takedamcheck=true
	for _,ce in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE)}) do
		local value=ce:GetValue()
		if not value or value(ce,cv) then
			takedamcheck=false
			break
		end
	end
	if ex and (cp==tp or cp==PLAYER_ALL) and not rd and takedamcheck then
		return true
	end
	
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	local recovercheck=true
	for _,e in ipairs({Duel.IsPlayerAffectedByEffect(p,EFFECT_NO_RECOVER)}) do
		if e:Evaluate(ep,ev,r) then
			recovercheck=false
			break
		end
	end
	return ex and (cp==tp or cp==PLAYER_ALL) and rr and recovercheck and takedamcheck
end

--LP Modification Events
EVENT_LP_CHANGE		= EVENT_CUSTOM+33720360

LP_REASON_UPDATE	= 0x1
LP_REASON_BECOME	= 0x2

local _SetLP = Duel.SetLP

Duel.SetLP = function(p,val,r,rp)
	if not r then r=LP_REASON_UPDATE end
	if not rp then rp=self_reference_effect:GetHandlerPlayer() end
	local prev=Duel.GetLP(p)
	local res = _SetLP(p,val)
	if Duel.GetLP(p)~=prev then
		Duel.RaiseEvent(self_reference_effect:GetHandler(),EVENT_LP_CHANGE,nil,REASON_EFFECT,rp,p,Duel.GetLP(p)-prev)
	end
	return res
end

--Auxiliary function to handle Muscle Medic (and similar effects) when effects that change LP recovers are being applied
function Glitchy.RegisterChangeBattleRecoverHandler()
	if not xgl.ChangeBattleRecoverEnabled then
		xgl.ChangeBattleRecoverEnabled=true
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e1:SetCondition(xgl.ChangeBattleRecoverCondition)
		e1:SetOperation(xgl.ChangeBattleRecoverOperation)
		Duel.RegisterEffect(e1,0)
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e2:SetCondition(xgl.ChangeBattleRecoverCondition)
		e2:SetOperation(xgl.ChangeBattleRecoverOperation)
		Duel.RegisterEffect(e2,1)
	end
end
function Glitchy.ChangeBattleRecoverCondition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetBattleDamage(tp)<=0 or Duel.IsPlayerAffectedByEffect(tp,EFFECT_AVOID_BATTLE_DAMAGE) then return false end
	local DamageWillBeReversed=false
	for _,ce in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_DAMAGE)}) do
		local val=ce:GetValue()
		local rc = (re and re&REASON_EFFECT==REASON_EFFECT) and re:GetHandler() or Duel.GetAttacker()
		if not val or (type(val)=="number" and val~=0) or val(ce,re,r|REASON_BATTLE,rp,rc) then
			DamageWillBeReversed=true
			break
		end
	end
	for _,ce in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)}) do
		local val=ce:GetValue()
		if not val or (type(val)=="number" and val~=0) or val(ce,re,r|REASON_BATTLE,rp) then
			DamageWillBeReversed=false
			break
		end
	end
	return DamageWillBeReversed
end
function Glitchy.ChangeBattleRecoverOperation(e,tp,eg,ep,ev,re,r,rp)
	local eff
	local v=Duel.GetBattleDamage(tp)
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CHANGE_RECOVER)}
	if #eset>0 then
		for _,e in ipairs(eset) do
			local res=e:Evaluate(r|REASON_BATTLE,v,nil,0)
			if res and (#eset==1 or Duel.SelectEffectYesNo(e:GetHandlerPlayer(),e:GetHandler())) then
				eff=e
				break
			end
		end
	end

	if eff then
		local val=eff:Evaluate(r|REASON_BATTLE,v,nil,1)
		Duel.ChangeBattleDamage(tp,val)
	end
end