TYPE_DOUBLESIDED				=0x1000000000

SIDE_OBVERSE	= 0x1
SIDE_REVERSE	= 0x2

EVENT_TRANSFORMED		= EVENT_CUSTOM+100000041
EVENT_PRE_TRANSFORMED	= EVENT_CUSTOM+100000042

FLAG_PRE_TRANSFORMED						=	100000042
FLAG_ALLOW_DOUBLESIDED_REVERSE_REGISTRATION	=	100000043
	
Auxiliary.DoubleSided={}

Auxiliary.PreTransformationGlobalChecks={}
function Auxiliary.AddOrigDoubleSidedType(c)
	table.insert(Auxiliary.DoubleSided,c)
	Auxiliary.DoubleSided[c]=true
end
function Auxiliary.AddDoubleSidedProc(c,side,id,prechk)
	if c:IsStatus(STATUS_COPYING_EFFECT) and not c:HasFlagEffect(FLAG_ALLOW_DOUBLESIDED_REVERSE_REGISTRATION) then return end
	aux.AddOrigDoubleSidedType(c)
	local s=getmetatable(c)
	if side==SIDE_OBVERSE then
		if s.reverse_side==nil then
			s.reverse_side=id
		end
	elseif side==SIDE_REVERSE then
		if s.obverse_side==nil then
			s.obverse_side=id
		end
		aux.AddReverseSideProc(c)
	end
	if prechk then
		if type(prechk)=="number" then
			local code=prechk
			prechk = function(card)
				return card:IsCode(code)
			end
		end
		s.pre_transformation_condition = prechk
	end
end

--Checks if a card has a certain Side
function Card.HasObverseSide(c)
	return c.obverse_side~=nil
end
function Card.HasReverseSide(c)
	return c.reverse_side~=nil
end
function Card.IsObverse(c)
	return c:HasReverseSide()
end
function Card.IsReverse(c)
	return c:HasObverseSide()
end
function Card.GetObverseSide(c)
	if not c:HasObverseSide() then return end
	return Duel.IgnoreActionCheck(Duel.CreateToken,c:GetControler(),c.obverse_side)
end
function Card.GetReverseSide(c)
	if not c:HasReverseSide() then return end
	return Duel.IgnoreActionCheck(Duel.CreateToken,c:GetControler(),c.reverse_side)
end
function Card.IsCanTransform(c,side,e,tp,r)
	if not side then side=SIDE_OBVERSE|SIDE_REVERSE end
	return (side&SIDE_OBVERSE>0 and c:HasObverseSide()) or (side&SIDE_REVERSE>0 and c:HasReverseSide())
end
function Auxiliary.IsCanTransformTargetFunction(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanTransform(nil,e,tp) end
end

--Transforms a card to its opposite Side
function Duel.Transform(c,side,e,tp,r)
	if not r then r=REASON_EFFECT end
	if not c:IsCanTransform(side,e,tp,r) then return false end
	
	local tcode
	if side&SIDE_REVERSE>0 and c:HasReverseSide() then
		tcode=c.reverse_side
	elseif side&SIDE_OBVERSE>0 and c:HasObverseSide() then
		tcode=c.obverse_side
	else
		return false
	end
	local s=getmetatable(c)
	c:ResetFlagEffect(FLAG_PRE_TRANSFORMED)
	if s.pre_transformation_condition and s.pre_transformation_condition(c) then
		c:RegisterFlagEffect(FLAG_PRE_TRANSFORMED,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_IGNORE_IMMUNE,1,c:GetOriginalCode())
	end
	Duel.RaiseEvent(c,EVENT_PRE_TRANSFORMED,e,r,tp,tp,0)
	Duel.RaiseSingleEvent(c,EVENT_PRE_TRANSFORMED,e,r,tp,tp,0)
	local res=c:SetEntityCode(tcode,true)
	if res then
		c:RegisterFlagEffect(FLAG_ALLOW_DOUBLESIDED_REVERSE_REGISTRATION,0,EFFECT_FLAG_IGNORE_IMMUNE,1)
		if not s.transform_token_initialized then
			s.transform_token_initialized=true
			Duel.CreateToken(0,tcode)
		end
		Duel.SetMetatable(c, _G["c"..tcode])
		c:ReplaceEffect(CARD_CYBER_HARPIE_LADY,0,0)
		c:SetStatus(STATUS_EFFECT_REPLACED,false)
		s=getmetatable(c)
		s.initial_effect(c)
		c:ResetFlagEffect(FLAG_ALLOW_DOUBLESIDED_REVERSE_REGISTRATION)
		Duel.RaiseEvent(c,EVENT_TRANSFORMED,e,r,tp,tp,0)
		Duel.RaiseSingleEvent(c,EVENT_TRANSFORMED,e,r,tp,tp,0)
	end
	return res
end
function Auxiliary.TransformOperationFunction(side)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if c:IsRelateToChain() and c:IsFaceup() then
					Duel.Transform(c,side,e,tp,REASON_EFFECT)
				end
			end
end

--Pre-Transformation Checks
function Auxiliary.AddPreTransformationCheck(c,e,condition,duel)
	if not duel then
		local ce=Effect.CreateEffect(c)
		ce:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ce:SetProperty((e:GetProperty()&(~EFFECT_FLAG_DELAY))|EFFECT_FLAG_CANNOT_DISABLE)
		ce:SetCode(EVENT_PRE_TRANSFORMED)
		ce:SetRange(e:GetRange())
		ce:SetOperation(aux.PreTransformationCheckOperation(condition))
		c:RegisterEffect(ce,true)
		e:SetLabelObject(ce)
		return ce
	else
		local ce=Effect.CreateEffect(c)
		ce:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ce:SetProperty((e:GetProperty()&(~EFFECT_FLAG_DELAY)))
		ce:SetCode(EVENT_PRE_TRANSFORMED)
		ce:SetOperation(aux.PreTransformationGlobalCheckOperation(condition))
		Duel.RegisterEffect(ce,0)
		e:SetLabelObject(ce)
		return ce
	end
end
function Auxiliary.PreTransformationCheckOperation(condition)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				if condition and condition(e,tp,eg,ep,ev,re,r,rp) then
					e:SetLabel(1)
				else
					e:SetLabel(0)
				end
			end
end
function Auxiliary.PreTransformationGlobalCheckOperation(condition)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local labels={0,0}
				for p=0,1 do
					if condition and condition(e,p,eg,ep,ev,re,r,rp) then
						labels[p+1]=1
					end
				end
				e:SetLabel(table.unpack(labels))
			end
end
function Auxiliary.PreTransformationCheckSuccessSingle(e)
	return e:GetHandler():HasFlagEffect(FLAG_PRE_TRANSFORMED)
end
function Auxiliary.PreTransformationCheckSuccess(e)
	return e:GetLabelObject():GetLabel()==1
end
function Auxiliary.PreTransformationGlobalCheckSuccess(e,tp)
	local labels={e:GetLabelObject():GetLabel()}
	return labels[tp+1]==1
end

--Add procedure that reverts a card from Reverse Side to Obverse Side as soon as it leaves the field.
Auxiliary.AllowReverseSideInAllLocation = false
function Auxiliary.AddReverseSideProc(c)
	if aux.AllowReverseSideInAllLocation then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_DECK|LOCATION_GRAVE|LOCATION_REMOVED|LOCATION_HAND|LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		return c:HasObverseSide()
	end)
	e2:SetOperation(Auxiliary.RevertToObverseSideOperation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(0)
	c:RegisterEffect(e3)
end
function Auxiliary.RevertToObverseSideOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.HasObverseSide,tp,LOCATION_DECK|LOCATION_GRAVE|LOCATION_REMOVED|LOCATION_HAND|LOCATION_EXTRA,LOCATION_DECK|LOCATION_GRAVE|LOCATION_REMOVED|LOCATION_HAND|LOCATION_EXTRA,nil)
	if #g>1 and not g:GetMaxGroup(Card.GetSequence):IsContains(c) then return end
	local tcode=c.obverse_side
	if not tcode then return end
	c:SetEntityCode(tcode)
	local s=getmetatable(c)
	c:RegisterFlagEffect(FLAG_ALLOW_DOUBLESIDED_REVERSE_REGISTRATION,0,EFFECT_FLAG_IGNORE_IMMUNE,1)
	if not s.transform_token_initialized then
		s.transform_token_initialized=true
		Duel.CreateToken(0,tcode)
	end
	Duel.SetMetatable(c,_G["c"..tcode])
	c:ReplaceEffect(CARD_CYBER_HARPIE_LADY,0,0)
	c:SetStatus(STATUS_EFFECT_REPLACED,false)
	s=getmetatable(c)
	s.initial_effect(c)
	c:ResetFlagEffect(FLAG_ALLOW_DOUBLESIDED_REVERSE_REGISTRATION)
end

--Conditions

--Others
function Duel.IgnoreActionCheck(f,...)
	Duel.DisableActionCheck(true)
	local ret={}
	local sret={pcall(f,...)}
	for i=2,#sret do
		table.insert(ret,sret[i])
	end
	Duel.DisableActionCheck(false)
	return table.unpack(ret)
end