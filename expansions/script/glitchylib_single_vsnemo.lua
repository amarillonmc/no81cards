local EFFECT_FLAG_COPY_INHERIT = EFFECT_FLAG_COPY_INHERIT or EFFECT_FLAG_COPY

--Single Effect template
function Card.SingleEffect(c,code,val,reset,rc,range,cond,prop,desc)
	local typ = (SCRIPT_AS_EQUIP==true) and EFFECT_TYPE_EQUIP or EFFECT_TYPE_SINGLE
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
	
	local e=Effect.CreateEffect(rc)
	e:SetType(typ)
	if range and not SCRIPT_AS_EQUIP then
		prop=prop|EFFECT_FLAG_SINGLE_RANGE
		e:SetRange(range)
	end
	e:SetCode(code)
	if val then
		e:SetValue(val)
	end
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
		if reset&RESET_EVENT==0 then
			reset=reset|RESET_EVENT|RESETS_STANDARD
		end
		e:SetReset(reset,rct)
	end
	
	if desc then
		prop=prop|EFFECT_FLAG_CLIENT_HINT
		e:SetDescription(desc)
	end
	
	if prop~=0 then
		e:SetProperty(prop)
	end	
	
	return e
end

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

function Glitchy.AddType(c,ctyp,reset,rc,range,cond,prop,desc)
	local otyp=c:GetType()
	local e=c:SingleEffect(EFFECT_ADD_TYPE,ctyp,reset,rc,range,cond,prop,desc)
	c:RegisterEffect(e)
	if reset then
		return e,otyp,c:GetType()&ctyp
	else
		return e
	end
end
function Glitchy.ChangeAttribute(c,attr,reset,rc,range,cond,prop,desc)
	local oatt=c:GetAttribute()
	local e=c:SingleEffect(EFFECT_CHANGE_ATTRIBUTE,attr,reset,rc,range,cond,prop,desc)
	c:RegisterEffect(e)
	if reset then
		return e,oatt,c:GetAttribute()
	else
		return e
	end
end
function Glitchy.ChangeRace(c,race,reset,rc,range,cond,prop,desc)
	local orac=c:GetRace()
	local e=c:SingleEffect(EFFECT_CHANGE_RACE,race,reset,rc,range,cond,prop,desc)
	c:RegisterEffect(e)
	if reset then
		return e,orac,c:GetRace()
	else
		return e
	end
end
function Glitchy.UpdateLevel(c,lv,reset,rc,range,cond,prop,desc)
	local olv=c:GetLevel()
	local e=c:SingleEffect(EFFECT_UPDATE_LEVEL,lv,reset,rc,range,cond,prop,desc)
	c:RegisterEffect(e)
	if reset then
		return e,c:GetLevel()-olv
	else
		return e
	end
end
function Glitchy.ChangeLevel(c,lv,reset,rc,range,cond,prop,desc)
	local olv=c:GetLevel()
	local e=c:SingleEffect(EFFECT_CHANGE_LEVEL,lv,reset,rc,range,cond,prop,desc)
	c:RegisterEffect(e)
	if reset then
		return e,c:GetLevel()-olv
	else
		return e
	end
end
function Glitchy.UpdateRank(c,lv,reset,rc,range,cond,prop,desc)
	local olv=c:GetRank()
	local e=c:SingleEffect(EFFECT_UPDATE_RANK,lv,reset,rc,range,cond,prop,desc)
	c:RegisterEffect(e)
	if reset then
		return e,c:GetRank()-olv
	else
		return e
	end
end
function Glitchy.ChangeRank(c,lv,reset,rc,range,cond,prop,desc)
	local olv=c:GetRank()
	local e=c:SingleEffect(EFFECT_CHANGE_RANK,lv,reset,rc,range,cond,prop,desc)
	c:RegisterEffect(e)
	if reset then
		return e,c:GetRank()-olv
	else
		return e
	end
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
		if desc==nil and typ==EFFECT_TYPE_SINGLE then
			desc=STRING_CANNOT_BE_DESTROYED_BY_BATTLE
		end
	end
	
	if desc then
		e:SetDescription(desc)
		prop=prop|EFFECT_FLAG_CLIENT_HINT
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
	
	if desc then
		e:SetDescription(desc)
		prop=prop|EFFECT_FLAG_CLIENT_HINT
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

--Special conditions (not effects)
function Card.TrapCanBeActivatedFromHand(c,cond,desc,stop)
	local e1=Effect.CreateEffect(c)
	if desc then
		e1:SetDescription(desc)
	end
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	if cond then
		e1:SetCondition(cond)
	end
	if not stop then
		c:RegisterEffect(e1)
	end
	return e1
end