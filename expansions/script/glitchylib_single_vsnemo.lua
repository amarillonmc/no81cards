function Auxiliary.ForEach(f,loc1,loc2,exc,n)
	if not loc1 then loc1=0 end
	if not loc2 then loc2=0 end
	if not n then n=1 end
	return	function(e,c)
				local tp=e:GetHandlerPlayer()
				local exc= (type(exc)=="boolean" and exc) and e:GetHandler() or (exc) and exc or nil
				return Duel.GetMatchingGroupCount(f,tp,loc1,loc2,exc,e,tp)*n
			end
end

--Update stats
function Card.UpdateATK(c,atk,reset,rc,range,cond,prop,desc)
	local typ = EFFECT_TYPE_SINGLE
	if not reset and not range then
		range = c:GetOriginalType()&TYPE_FIELD>0 and LOCATION_FZONE or c:GetOriginalType()&TYPE_ST>0 and LOCATION_SZONE or LOCATION_MZONE
	end
	
	local donotdisable=false
	local rc = rc and rc or c
    local rct=1
    if type(reset)=="table" then
        rct=reset[2]
        reset=reset[1]
    end
	
	if type(rc)=="table" then
        donotdisable=rc[2]
        rc=rc[1]
    end
	
	if not prop then prop=0 end
	
	local att=c:GetAttack()
	local e=Effect.CreateEffect(rc)
	e:SetType(typ)
	if range then
		prop=prop|EFFECT_FLAG_SINGLE_RANGE
		e:SetRange(range)
	end
	e:SetCode(EFFECT_UPDATE_ATTACK)
	e:SetValue(atk)
	if cond then
		e:SetCondition(cond)
	end
	
	if reset then
		if type(reset)~="number" then reset=0 end
		if rc==c and not donotdisable then
			reset = reset|RESET_DISABLE
		else
			prop=prop|EFFECT_FLAG_CANNOT_DISABLE
		end
		e:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
	end
	
	if prop~=0 then
		e:SetProperty(prop)
	end
	
	c:RegisterEffect(e)
	
	if reset then
		return e,c:GetAttack()-att
	else
		return e
	end
end
function Card.UpdateDEF(c,def,reset,rc,range,cond,prop,desc)
	local typ = EFFECT_TYPE_SINGLE
	if not reset and not range then
		range = c:GetOriginalType()&TYPE_FIELD>0 and LOCATION_FZONE or c:GetOriginalType()&TYPE_ST>0 and LOCATION_SZONE or LOCATION_MZONE
	end
	local rc = rc and rc or c
    local rct=1
    if type(reset)=="table" then
        rct=reset[2]
        reset=reset[1]
    end
	if not prop then prop=0 end
	
	local df=c:GetDefense()
	local e=Effect.CreateEffect(rc)
	e:SetType(typ)
	if range then
		prop=prop|EFFECT_FLAG_SINGLE_RANGE
		e:SetRange(range)
	end
	e:SetCode(EFFECT_UPDATE_DEFENSE)
	e:SetValue(def)
	if cond then
		e:SetCondition(cond)
	end
	if reset then
		if type(reset)~="number" then reset=0 end
		if rc==c and not donotdisable then
			reset = reset|RESET_DISABLE
		else
			prop=prop|EFFECT_FLAG_CANNOT_DISABLE
		end
		e:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
	end
	
	if prop~=0 then
		e:SetProperty(prop)
	end
	
	c:RegisterEffect(e)
	if reset then
		return e,c:GetDefense()-df
	else
		return e
	end
end
function Card.UpdateATKDEF(c,atk,def,reset,rc,range,cond,prop,desc)
	local typ = EFFECT_TYPE_SINGLE
	if not reset and not range then
		range = c:GetOriginalType()&TYPE_FIELD>0 and LOCATION_FZONE or c:GetOriginalType()&TYPE_ST>0 and LOCATION_SZONE or LOCATION_MZONE
	end
	
	local donotdisable=false
    local rct=1
    if type(reset)=="table" then
        rct=reset[2]
        reset=reset[1]
    end
	
	if type(rc)=="table" then
        donotdisable=rc[2]
        rc=rc[1]
    end
	local rc = rc and rc or c
	
	if not atk then
		atk=def
	elseif not def then
		def=atk
	end
	
	if not prop then prop=0 end
	
	local oatk,odef=c:GetAttack(),c:GetDefense()
	local e=Effect.CreateEffect(rc)
	e:SetType(typ)
	
	if range then
		prop=prop|EFFECT_FLAG_SINGLE_RANGE
		e:SetRange(range)
	end
	
	e:SetCode(EFFECT_UPDATE_ATTACK)
	e:SetValue(atk)
	
	if cond then
		e:SetCondition(cond)
	end
	
	if reset then
		if type(reset)~="number" then reset=0 end
		if rc==c and not donotdisable then
			reset = reset|RESET_DISABLE
		else
			prop=prop|EFFECT_FLAG_CANNOT_DISABLE
		end
		e:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
	end
	
	if prop~=0 then
		e:SetProperty(prop)
	end
	
	c:RegisterEffect(e)
	
	local e1x=e:Clone()
	e1x:SetCode(EFFECT_UPDATE_DEFENSE)
	e1x:SetValue(def)
	
	c:RegisterEffect(e1x)
	
	if not reset then
		return e,e1x
	else
		return e,e1x,c:GetAttack()-oatk,c:GetDefense()-odef
	end
end

--Change stats
function Card.ChangeATK(c,atk,reset,rc,range,cond,prop,desc)
	local typ = EFFECT_TYPE_SINGLE
	if not reset and not range then
		range = c:GetOriginalType()&TYPE_FIELD>0 and LOCATION_FZONE or c:GetOriginalType()&TYPE_ST>0 and LOCATION_SZONE or LOCATION_MZONE
	end
	
	local donotdisable=false
    local rct=1
    if type(reset)=="table" then
        rct=reset[2]
        reset=reset[1]
    end
	
	if type(rc)=="table" then
        donotdisable=rc[2]
        rc=rc[1]
    end
	local rc = rc and rc or c
	
	if not prop then prop=0 end
	
	local oatk=c:GetAttack()
	local e=Effect.CreateEffect(rc)
	e:SetType(typ)
	
	if range then
		prop=prop|EFFECT_FLAG_SINGLE_RANGE
		e:SetRange(range)
	end
	
	e:SetCode(EFFECT_SET_ATTACK_FINAL)
	e:SetValue(atk)
	if cond then
		e:SetCondition(cond)
	end
	if reset then
		if type(reset)~="number" then reset=0 end
		if rc==c and not donotdisable then
			reset = reset|RESET_DISABLE
		else
			prop=prop|EFFECT_FLAG_CANNOT_DISABLE
		end
		e:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
	end
	
	if prop~=0 then
		e:SetProperty(prop)
	end
	c:RegisterEffect(e)
	if not reset then
		return e
	else
		local natk=c:GetAttack()
		return e,oatk,natk,natk-oatk
	end
end
function Card.ChangeDEF(c,def,reset,rc,range,cond,prop,desc)
	local typ = EFFECT_TYPE_SINGLE
	if not reset and not range then
		range = c:GetOriginalType()&TYPE_FIELD>0 and LOCATION_FZONE or c:GetOriginalType()&TYPE_ST>0 and LOCATION_SZONE or LOCATION_MZONE
	end
	
	local donotdisable=false
    local rct=1
    if type(reset)=="table" then
        rct=reset[2]
        reset=reset[1]
    end
	
	if type(rc)=="table" then
        donotdisable=rc[2]
        rc=rc[1]
    end
	local rc = rc and rc or c
	
	if not prop then prop=0 end
	
	local odef=c:GetDefense()
	local e=Effect.CreateEffect(rc)
	e:SetType(typ)
	
	if range then
		prop=prop|EFFECT_FLAG_SINGLE_RANGE
		e:SetRange(range)
	end
	
	e:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e:SetValue(def)
	if cond then
		e:SetCondition(cond)
	end
	if reset then
		if type(reset)~="number" then reset=0 end
		if rc==c and not donotdisable then
			reset = reset|RESET_DISABLE
			prop=prop|EFFECT_FLAG_COPY_INHERIT
		else
			prop=prop|EFFECT_FLAG_CANNOT_DISABLE
		end
		e:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
	end
	
	if prop~=0 then
		e:SetProperty(prop)
	end
	
	c:RegisterEffect(e)
	if not reset then
		return e
	else
		local ndef=c:GetDefense()
		return e,odef,ndef,ndef-odef
	end
end
function Card.ChangeATKDEF(c,atk,def,reset,rc,range,cond,prop,desc)
	local typ = EFFECT_TYPE_SINGLE
	if not reset and not range then
		range = c:GetOriginalType()&TYPE_FIELD>0 and LOCATION_FZONE or c:GetOriginalType()&TYPE_ST>0 and LOCATION_SZONE or LOCATION_MZONE
	end
	
	local donotdisable=false
    local rct=1
    if type(reset)=="table" then
        rct=reset[2]
        reset=reset[1]
    end
	
	if type(rc)=="table" then
        donotdisable=rc[2]
        rc=rc[1]
    end
	local rc = rc and rc or c
	
	if not prop then prop=0 end
	
	if not atk then
		atk=def
	elseif not def then
		def=atk
	end
	
	local oatk=c:GetAttack()
	local odef=c:GetDefense()
	local e=Effect.CreateEffect(rc)
	e:SetType(typ)
	
	if range then
		prop=prop|EFFECT_FLAG_SINGLE_RANGE
		e:SetRange(range)
	end
	
	e:SetCode(EFFECT_SET_ATTACK_FINAL)
	e:SetValue(atk)
	if cond then
		e:SetCondition(cond)
	end
	
	if reset then
		if type(reset)~="number" then reset=0 end
		if rc==c and not donotdisable then
			reset = reset|RESET_DISABLE
			prop=prop|EFFECT_FLAG_COPY_INHERIT
		else
			prop=prop|EFFECT_FLAG_CANNOT_DISABLE
		end
		e:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
	end
	
	if prop~=0 then
		e:SetProperty(prop)
	end
	c:RegisterEffect(e)
	
	local e1x=e:Clone()
	e1x:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1x:SetValue(def)
	c:RegisterEffect(e1x)
	if not reset then
		return e,e1x
	else
		local natk,ndef=c:GetAttack(),c:GetDefense()
		return e,e1x,oatk,natk,odef,ndef,natk-oatk,ndef-odef
	end
end

function Card.HalveATK(c,reset,rc,range,cond,prop,desc)
	local atk=math.ceil(c:GetAttack()/2)
	return c:ChangeATK(atk,reset,rc,range,cond,prop,desc)
end
function Card.HalveDEF(c,reset,rc,range,cond,prop,desc)
	local def=math.ceil(c:GetDefense()/2)
	return c:ChangeDEF(def,reset,rc,range,cond,prop,desc)
end
function Card.DoubleATK(c,reset,rc,range,cond,prop,desc)
	local atk=c:GetAttack()*2
	return c:ChangeATK(atk,reset,rc,range,cond,prop,desc)
end
function Card.DoubleDEF(c,reset,rc,range,cond,prop,desc)
	local def=c:GetDefense()*2
	return c:ChangeDEF(def,reset,rc,range,cond,prop,desc)
end

--Protections
function Card.CannotBeDestroyedByBattle(c,val,cond,reset,rc,range,prop,desc,forced,typ)
	if not typ and c:IsOriginalType(TYPE_EQUIP) and not range then
		typ = EFFECT_TYPE_EQUIP
	else
		typ = typ or EFFECT_TYPE_SINGLE
	end
	
	if typ==EFFECT_TYPE_SINGLE and not reset and not range then
		range = c:GetOriginalType()&TYPE_FIELD>0 and LOCATION_FZONE or c:GetOriginalType()&TYPE_ST>0 and LOCATION_SZONE or LOCATION_MZONE
	end
	
	local donotdisable=false
	local rc = rc and rc or c
    local rct=1
    if type(reset)=="table" then
        rct=reset[2]
        reset=reset[1]
    end
	
	if type(rc)=="table" then
        donotdisable=rc[2]
        rc=rc[1]
    end
	
	if not prop then prop=0 end
	
	if not val then val=1 end
	
	local e=Effect.CreateEffect(rc)
	e:SetType(typ)
	if range then
		prop=prop|EFFECT_FLAG_SINGLE_RANGE
		e:SetRange(range)
	end
	e:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e:SetValue(val)
	if cond then
		e:SetCondition(cond)
	end
	
	if reset then
		if type(reset)~="number" then reset=0 end
		prop=prop|EFFECT_FLAG_CANNOT_DISABLE
		e:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
	end
	
	if prop~=0 then
		e:SetProperty(prop)
	end
	
	c:RegisterEffect(e,forced)
	
	return e
end

function Card.CannotBeDestroyedByEffects(c,val,cond,reset,rc,range,prop,desc,forced,typ)
	if not typ and c:IsOriginalType(TYPE_EQUIP) and not range then
		typ = EFFECT_TYPE_EQUIP
	else
		typ = typ or EFFECT_TYPE_SINGLE
	end
	
	if typ==EFFECT_TYPE_SINGLE and not reset and not range then
		range = c:GetOriginalType()&TYPE_FIELD>0 and LOCATION_FZONE or c:GetOriginalType()&TYPE_ST>0 and LOCATION_SZONE or LOCATION_MZONE
	end
	
	local donotdisable=false
	local rc = rc and rc or c
    local rct=1
    if type(reset)=="table" then
        rct=reset[2]
        reset=reset[1]
    end
	
	if type(rc)=="table" then
        donotdisable=rc[2]
        rc=rc[1]
    end
	
	if not prop then prop=0 end
	
	if not val then val=1 end
	
	local e=Effect.CreateEffect(rc)
	e:SetType(typ)
	if range then
		prop=prop|EFFECT_FLAG_SINGLE_RANGE
		e:SetRange(range)
	end
	e:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e:SetValue(val)
	if cond then
		e:SetCondition(cond)
	end
	
	if reset then
		if type(reset)~="number" then reset=0 end
		prop=prop|EFFECT_FLAG_CANNOT_DISABLE
		e:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
	end
	
	if prop~=0 then
		e:SetProperty(prop)
	end
	
	c:RegisterEffect(e,forced)
	
	return e
end

--Protections: Immunity
UNAFFECTED_OTHER		= 0x1
UNAFFECTED_OPPO			= 0x2
UNAFFECTED_OTHER_EQUIP	= 0x100

function Auxiliary.imother(e,te)
	return e:GetOwner()~=te:GetOwner()
end
function Auxiliary.imoval(e,te)
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end
function Auxiliary.imothereq(e,te)
	local owner,affecting_owner=e:GetOwner(),te:GetOwner()
	return owner~=affecting_owner and affecting_owner~=owner:GetEquipTarget()
end

Auxiliary.UnaffectedProtections={
	[UNAFFECTED_OTHER]			= aux.imother;
	[UNAFFECTED_OPPO]			= aux.imoval;
	[UNAFFECTED_OTHER_EQUIP]	= aux.imothereq;
}
function Card.Unaffected(c,immunity,cond,reset,rc,range,prop,desc,forced,typ)
	if not typ and c:IsOriginalType(TYPE_EQUIP) and not range then
		typ = EFFECT_TYPE_EQUIP
	else
		typ = typ or EFFECT_TYPE_SINGLE
	end
	
	if typ==EFFECT_TYPE_SINGLE and not reset and not range then
		range = c:GetOriginalType()&TYPE_FIELD>0 and LOCATION_FZONE or c:GetOriginalType()&TYPE_ST>0 and LOCATION_SZONE or LOCATION_MZONE
	end
	
	local donotdisable=false
	local rc = rc and rc or c
    local rct=1
    if type(reset)=="table" then
        rct=reset[2]
        reset=reset[1]
    end
	
	if type(rc)=="table" then
        donotdisable=rc[2]
        rc=rc[1]
    end
	
	if not prop then prop=0 end
	
	if type(immunity)=="number" then
		immunity=aux.UnaffectedProtections[immunity]
	end
	
	local e=Effect.CreateEffect(rc)
	if desc then
		e:SetDescription(desc)
		prop=prop|EFFECT_FLAG_CLIENT_HINT
	end
	e:SetType(typ)
	if range then
		prop=prop|EFFECT_FLAG_SINGLE_RANGE
		e:SetRange(range)
	end
	e:SetCode(EFFECT_IMMUNE_EFFECT)
	e:SetValue(immunity)
	if cond then
		e:SetCondition(cond)
	end
	
	if reset then
		if type(reset)~="number" then reset=0 end
		prop=prop|EFFECT_FLAG_CANNOT_DISABLE
		e:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
	end
	
	if prop~=0 then
		e:SetProperty(prop)
	end
	
	c:RegisterEffect(e,forced)
	
	return e
end

--Restriction and Rules
function Card.MustBeSummoned(c,sumtype,rc)
	local rc = rc and rc or c
	local e=Effect.CreateEffect(rc)
	e:SetType(EFFECT_TYPE_SINGLE)
	e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
	e:SetCode(EFFECT_SPSUMMON_CONDITION)
	e:SetValue(	function(eff,se,sp,st)
					return st&sumtype==sumtype
				end
			  )
	c:RegisterEffect(e)
	return e
end
function Card.MustFirstBeSummoned(c,sumtype,rc)
	local rc = rc and rc or c
	local e=Effect.CreateEffect(rc)
	e:SetType(EFFECT_TYPE_SINGLE)
	e:SetProperty(EFFECT_FLAG_SINGLE_RANGE|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
	e:SetCode(EFFECT_SPSUMMON_CONDITION)
	e:SetRange(LOCATION_EXTRA)
	e:SetValue(	function(eff,se,sp,st)
					return st&sumtype==sumtype
				end
			  )
	c:RegisterEffect(e)
	return e
end
function Card.MustBeSSedByOwnProcedure(c,rc)
	local rc = rc and rc or c
	local e=Effect.CreateEffect(rc)
	e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
	e:SetType(EFFECT_TYPE_SINGLE)
	e:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e)
end