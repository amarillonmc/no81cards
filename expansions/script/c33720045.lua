--孝心变质 | Prima Impressione, con Disperazione
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.ctcon)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	--boost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabel(1)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(s.countct)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	local e3x=e3:Clone()
	e3x:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3x)
	--mark for replacement
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(id)
	e4:SetRange(LOCATION_SZONE)
	e4:SetLabel(2)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(s.countct)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(s.regop)
	c:RegisterEffect(e5)
	--fusion material
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e6:SetRange(LOCATION_SZONE)
	e6:SetLabel(1)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetTarget(s.countct)
	e6:SetValue(s.mtval)
	c:RegisterEffect(e6)
	--synchro material
	local e6x=Effect.CreateEffect(c)
	e6x:SetType(EFFECT_TYPE_FIELD)
	e6x:SetCode(EFFECT_SYNCHRO_MATERIAL)
	e6x:SetRange(LOCATION_SZONE)
	e6x:SetLabel(1)
	e6x:SetTargetRange(0,LOCATION_MZONE)
	e6x:SetTarget(s.countct)
	c:RegisterEffect(e6x)
	--xyz material
	local e6y=Effect.CreateEffect(c)
	e6y:SetType(EFFECT_TYPE_FIELD)
	e6y:SetCode(EFFECT_XYZ_MATERIAL)
	e6y:SetRange(LOCATION_SZONE)
	e6y:SetLabel(1)
	e6y:SetTargetRange(0,LOCATION_MZONE)
	e6y:SetTarget(s.countct)
	c:RegisterEffect(e6y)
	--link material
	local e6z=Effect.CreateEffect(c)
	e6z:SetType(EFFECT_TYPE_FIELD)
	e6z:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e6z:SetRange(LOCATION_SZONE)
	e6z:SetLabel(1)
	e6z:SetTargetRange(0,LOCATION_MZONE)
	e6z:SetTarget(s.countct)
	e6z:SetValue(s.mtval_link)
	c:RegisterEffect(e6z)
	if not s.global_check then
		s.global_check=true
		--disable effects
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.replace)
		Duel.RegisterEffect(ge1,0)
		--fusion workaround
		function aux.ExtraFusionFilter(c)
			return c:IsHasEffect(EFFECT_EXTRA_FUSION_MATERIAL,c:GetControler())
		end
		_GetFusionMaterial = Duel.GetFusionMaterial
		function Duel.GetFusionMaterial(tp,...)
			local og=_GetFusionMaterial(tp,...)
			local eg=Duel.GetMatchingGroup(aux.ExtraFusionFilter,tp,0,LOCATION_MZONE,nil)
			if #eg>0 then
				og:Merge(eg)
			end
			return og
		end
	end
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,nil,0x1337,1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,#g,1,0x1337)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,nil,0x1337,1)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1337,1)
		tc=g:GetNext()
	end
end

function s.countct(e,c)
	return c:GetCounter(0x1337)>=e:GetLabel()
end
function s.countctfil(c,e)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsImmuneToEffect(e) and c:IsHasEffect(id) and c:GetFlagEffect(id)<=0
end
function s.resetfil(c,e)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsHasEffect(id) and c:GetFlagEffect(id)>0
end
function s.replace(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(s.countctfil,tp,0,LOCATION_MZONE,nil,e)
	local rg=Duel.GetMatchingGroup(s.resetfil,tp,0,LOCATION_MZONE,nil,e)
	if #g>0 then
		for tc in aux.Next(g) do
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_CONTROL+RESET_MSCHANGE+RESET_OVERLAY,EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE,1)
			tc:ReplaceEffect(33720062,RESET_EVENT+RESETS_STANDARD+RESET_CONTROL+RESET_MSCHANGE+RESET_OVERLAY)
		end
	end
	if #rg>0 then
		for tc in aux.Next(rg) do
			tc:ResetFlagEffect(id)
			tc:ReplaceEffect(tc:GetOriginalCodeRule(),RESET_EVENT+RESETS_STANDARD+RESET_CONTROL+RESET_MSCHANGE+RESET_OVERLAY)
		end
	end
end

function s.ctreg(c)
	return c:GetCounter(0x1337)>=3
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(s.ctreg,1,nil) then
		local g=eg:Filter(s.ctreg,nil)
		for tc in aux.Next(g) do
			local e5=Effect.CreateEffect(c)
			e5:SetDescription(aux.Stringid(id,1))
			e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
			e5:SetCode(EVENT_TO_GRAVE)
			e5:SetOperation(s.damop)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_LEAVE-RESET_TOGRAVE)
			tc:RegisterEffect(e5)
		end
	end
end
function s.damop(e)
	Duel.Damage(e:GetHandler():GetPreviousControler(),1000,REASON_EFFECT)
	e:Reset()
end

function s.mtval(e,c)
	if not c then return false end
	return c:IsLocation(LOCATION_EXTRA) and c:IsControler(e:GetHandlerPlayer())
end
function s.mtval_link(e,c)
	if not c then return false,nil end
	return c:IsLocation(LOCATION_EXTRA) and c:IsControler(e:GetHandlerPlayer()), true
end