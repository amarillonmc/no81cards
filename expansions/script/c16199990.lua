if not pcall(function() require("expansions/script/c16101100") end) then require("script/c16101100") end
rk=rk or {}
function rk.set(code,setcode)
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]   
	if setcode and not ccodem.rksetcode then
		ccodem.rksetcode=setcode
	end
	return code,ccodem
end

function rk.check(c,str)
	local substr=c.rksetcode
	if substr==nil then return false end
	if string.match(substr,str)==str then return true end
	return false
end
function rk.effectg(c,code)
	local tc=c
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(code,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e4:SetCondition(rk.efcon)
	e4:SetOperation(rk.efop)
	e4:SetLabel(code)
	tc:RegisterEffect(e4)
	return e4
end
function rk.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function rk.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	e:SetProperty(EFFECT_FLAG_EVENT_PLAYER+EFFECT_FLAG_IGNORE_IMMUNE)
	local rc=c:GetReasonCard()
	local code=e:GetLabel()
	local reset_flag=RESET_EVENT+RESETS_STANDARD
	local cid=rc:CopyEffect(code,reset_flag,1)
	--Debug.Message(e:GetOwnerPlayer()==rc:GetControler())
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(reset_flag)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetValue(code)
	rc:RegisterEffect(e1,true)
	rc:RegisterFlagEffect(0,reset_flag,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,5))
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
	e:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
end
function rk.indes(c,code)
	local tc=c
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	tc:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	tc:RegisterEffect(e4)
	--damage val
	local e5=e3:Clone()
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	tc:RegisterEffect(e5)
	return e3,e4,e5
end
function rk.indes(c,code,att)
	local tc=c
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(function (e,c,sump,sumtype,sumpos,targetp)
	return c:GetAttribute()==att
end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetValue(function (e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(att)
end)
	e2:SetRange(LOCATION_SZONE)
	tc:RegisterEffect(e2)
	return e1,e2
end