--Library for Sound Stage Cards
if TYPE_DUO_DIRECTION then return end

TYPE_DUO_DIRECTION	= 0x4000000000

STRING_NORTH_DIRECTION	= aux.Stringid(33700503,0)
STRING_SOUTH_DIRECTION	= aux.Stringid(33700503,1)

--Handle card type overwriting
Auxiliary.DuoDirection={}

local is_type, get_type, get_orig_type, get_prev_type_field, get_active_type, is_active_type, get_fusion_type, get_synchro_type, get_xyz_type, get_link_type, get_ritual_type = 
	Card.IsType, Card.GetType, Card.GetOriginalType, Card.GetPreviousTypeOnField, Effect.GetActiveType, Effect.IsActiveType, Card.GetFusionType, Card.GetSynchroType, Card.GetXyzType, Card.GetLinkType, Card.GetRitualType

Card.IsType=function(c,typ)
	if Auxiliary.DuoDirection[c] then
		return c:GetType()&typ>0
	end
	return is_type(c,typ)
end
Card.GetType=function(c,scard,sumtype,p)
	local tpe=scard and get_type(c,scard,sumtype,p) or get_type(c)
	if Auxiliary.DuoDirection[c] then
		tpe=(tpe&(~TYPE_FIELD))|TYPE_DUO_DIRECTION
	end
	return tpe
end
Card.GetOriginalType=function(c)
	local tpe=get_orig_type(c)
	if Auxiliary.DuoDirection[c] then
		tpe=(tpe&(~TYPE_FIELD))|TYPE_DUO_DIRECTION
		
	end
	return tpe
end
Card.GetPreviousTypeOnField=function(c)
	local tpe=get_prev_type_field(c)
	if Auxiliary.DuoDirection[c] then
		tpe=(tpe&(~TYPE_FIELD))|TYPE_DUO_DIRECTION
		
	end
	return tpe
end
Effect.GetActiveType=function(e)
	local tpe=get_active_type(e)
	local c = e:GetType()&0x7f0>0 and e:GetHandler() or e:GetOwner()
	if not (e:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsType(TYPE_PENDULUM)) and c:IsType(TYPE_DUO_DIRECTION) then
		tpe=(tpe&(~TYPE_FIELD))|TYPE_DUO_DIRECTION
	end
	return tpe
end
Effect.IsActiveType=function(e,typ)
	return e:GetActiveType()&typ>0
end

Card.GetFusionType=function(c)
	local tpe=get_fusion_type(c)
	if Auxiliary.DuoDirection[c] then
		tpe=(tpe&(~TYPE_FIELD))|TYPE_DUO_DIRECTION
		
	end
	return tpe
end
Card.GetSynchroType=function(c)
	local tpe=get_synchro_type(c)
	if Auxiliary.DuoDirection[c] then
		tpe=(tpe&(~TYPE_FIELD))|TYPE_DUO_DIRECTION
		
	end
	return tpe
end
Card.GetXyzType=function(c)
	local tpe=get_xyz_type(c)
	if Auxiliary.DuoDirection[c] then
		tpe=(tpe&(~TYPE_FIELD))|TYPE_DUO_DIRECTION
		
	end
	return tpe
end
Card.GetLinkType=function(c)
	local tpe=get_link_type(c)
	if Auxiliary.DuoDirection[c] then
		tpe=(tpe&(~TYPE_FIELD))|TYPE_DUO_DIRECTION
		
	end
	return tpe
end
Card.GetRitualType=function(c)
	local res=get_ritual_type(c)
	if Auxiliary.DuoDirection[c] then
		tpe=(tpe&(~TYPE_FIELD))|TYPE_DUO_DIRECTION
		
	end
	return tpe
end

function Auxiliary.AddOrigDuoDirectionType(c)
	Auxiliary.DuoDirection[c]=true
end

--Add DuoDirection procedure
Auxiliary.SelectedDuoDirection = {}

function Auxiliary.AddDuoDirectionProc(c,e,id2)
	Auxiliary.DuoDirection[c]=true
	
	local cost=e:GetCost()
	e:SetCost(function(_e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return not cost or cost(_e,tp,eg,ep,ev,re,r,rp,chk) end
		
		local c=e:GetHandler()
		local op=Duel.SelectOption(tp,STRING_NORTH_DIRECTION,STRING_SOUTH_DIRECTION)
		aux.SelectedDuoDirection[c]=op
		if op==0 then
			c:SetEntityCode(id)
		else
			c:SetEntityCode(id2)
		end
		
		if cost then cost(_e,tp,eg,ep,ev,re,r,rp,chk) end
	end)
	
	local targ=e:GetTarget()
	e:SetTarget(function(_e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return not targ or targ(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
		if chk==0 then
			return e:IsCostChecked() and (not targ or targ(e,tp,eg,ep,ev,re,r,rp,chk))
		end
		if targ then targ(e,tp,eg,ep,ev,re,r,rp,chk) end
	end
	)
end

function Card.GetNorthPlayer(c,tp)
	local dir=Auxiliary.SelectedDuoDirection[c]
	if dir==nil then return PLAYER_NONE end
	if dir==0 then
		return tp
	else
		return 1-tp
	end
end