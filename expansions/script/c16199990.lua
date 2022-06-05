if not pcall(function() require("expansions/script/c16101100") end) then require("script/c16101100") end
rk=rk or {}
local loc_table_for_reikai={
['dk'] = LOCATION_DECK,
['gy'] = LOCATION_GRAVE,
['re'] = LOCATION_REMOVED,
['hd'] = LOCATION_HAND,
['ex'] = LOCATION_EXTRA,
['mz'] = LOCATION_MZONE,
['sz'] = LOCATION_SZONE,
['on'] = LOCATION_ONFIELD,
}
local cate_table_for_reikai={
['td'] = CATEGORY_TODECK,
['tg'] = CATEGORY_TOGRAVE,
['th'] = CATEGORY_TOHAND,
['re'] = CATEGORY_REMOVE,
['dr'] = CATEGORY_DRAW,
['rc'] = CATEGORY_RECOVER,
['se'] = CATEGORY_SEARCH,
['sp'] = CATEGORY_SPECIAL_SUMMON,
['sum'] = CATEGORY_SUMMON,
['ng'] = CATEGORY_NEGATE,
['eq'] = CATEGORY_EQUIP,
['rel'] = CATEGORY_RELEASE,
['dke'] = CATEGORY_DECKDES,
['dis'] = CATEGORY_DISABLE,
['dss'] = CATEGORY_DISABLE_SUMMON,
['pos'] = CATEGORY_POSITION,
['ctl'] = CATEGORY_CONTROL,
['hde'] = CATEGORY_HANDES,
['tk'] = CATEGORY_TOKEN,
['dam'] = CATEGORY_DAMAGE,
['atk'] = CATEGORY_ATKCHANGE,
['def'] = CATEGORY_DEFCHANGE,
['coin'] = CATEGORY_COIN,
['dice'] = CATEGORY_DICE,
['fus'] = CATEGORY_FUSION_SUMMON,
['tx'] = CATEGORY_TOEXTRA,
['gs'] = CATEGORY_GRAVE_SPSUMMON,
['ga'] = CATEGORY_GRAVE_ACTION,
['lg'] = CATEGORY_LEAVE_GRAVE,
['an'] = CATEGORY_ANNOUNCE,
['ct'] = CATEGORY_COUNTER,
['des'] = CATEGORY_DESTROY,
}
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
	local code1,code2=c:GetCode()
	local subtr=nil
	local subtr2=nil
	if code1 then
		if not _G["c"..code1] then _G["c"..code1]={}
			setmetatable(_G["c"..code1],Card)
			_G["c"..code1].__index=_G["c"..code1]
		end
		local ccodem=_G["c"..code1]   
		substr=ccodem.rksetcode
	end
	if code2 then
		if not _G["c"..code2] then _G["c"..code2]={}
			setmetatable(_G["c"..code2],Card)
			_G["c"..code2].__index=_G["c"..code2]
		end
		local ccodem=_G["c"..code2]   
		substr2=ccodem.rksetcode
	end
	if substr==nil and substr2==nil then return false end
	if (substr and string.match(substr,str)==str) or (substr2 and string.match(substr2,str)==str) then return true end
	return false
end
if not Card.check then
	Card.check=rk.check
end
function rk.bin(str1,substr)
	local result = 0
	if str1 == 'loc' then
		for str in pairs(substr) do
			if not type(str) == "string" and not type(str) == "number" then
				Debug.Message("Param of location table must be string/number value")
				return
			end
			if type(str) == "string" then
				if not loc_table_for_reikai[str] then
					Debug.Message("an invalid key has been used (location table).")
					return
				end
				result = result + loc_table_for_reikai[str]
			else
				result = result + str
			end
		end
	end
	if str1 == 'cate' then
		for str in pairs(substr) do
			if not type(str) == "string" and not type(str) == "number" then
				Debug.Message("Param of category table must be string/number value")
				return
			end
			if type(str) == "string" then
				if not loc_table_for_reikai[str] then
					Debug.Message("an invalid key has been used (category table).")
					return
				end
				result = result + cate_table_for_reikai[str]
			else
				result = result + str
			end
		end
	end
	return result
end
function rk.Loc_Bin(loc)
	return rk.bin('loc',loc)
end
function rk.Cate_Bin(cate)	
	return rk.bin('cate',cate)
end
function rk.Self_Select_Deck(player,f,min,max,exg,...)
	return Duel.SelectMatchingCard(player,f,player,LOCATION_DECK,0,min,max,exg,...)
end
function rk.Self_Select_Grave(player,f,min,max,exg,...)
	return Duel.SelectMatchingCard(player,f,player,LOCATION_GRAVE,0,min,max,exg,...)
end
function rk.Self_Select_Hand(player,f,min,max,exg,...)
	return Duel.SelectMatchingCard(player,f,player,LOCATION_HAND,0,min,max,exg,...)
end
function rk.Self_Select_Banished(player,f,min,max,exg,...)
	return Duel.SelectMatchingCard(player,f,player,LOCATION_REMOVED,0,min,max,exg,...)
end
function rk.Self_Select_ExtraDeck(player,f,min,max,exg,...)
	return Duel.SelectMatchingCard(player,f,player,LOCATION_EXTRA,0,min,max,exg,...)
end
function rk.selectcard(sel_p,tar_p,f,loc,loc1,min,max,exg,...)
	if (loc&LOCATION_GRAVE~=0 and loc>LOCATION_GRAVE) or (loc1&LOCATION_GRAVE~=0 and loc1>LOCATION_GRAVE) then
		f=aux.NecroValleyFilter(f)
	end
	return Duel.SelectMatchingCard(sel_p,f,tar_p,loc,loc1,min,max,exg,...)
end
function rk.yk(c,loc)
    local tc=c
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_ADJUST)
    e1:SetRange(loc)
    e1:SetCondition(rk.ykcon2)
    e1:SetOperation(rk.op2)
    tc:RegisterEffect(e1)
    return e1,e2,e3,e4,e5
end
function rk.ykcon2(e,tp)
    local c=e:GetHandler()
    local ph=Duel.GetCurrentPhase()
    if c:GetFlagEffect(16199990)==0 then
        c:RegisterFlagEffect(16199990,RESET_EVENT+RESETS_STANDARD,0,0,0)
        c:RegisterFlagEffect(16199990+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+ph,0,0,0)
    end
    return c:IsAbleToRemove() and c:GetFlagEffect(16199990+1)==0
end
function rk.ykcon1(e,tp)
    local c=e:GetHandler()
    return c:IsAbleToRemove() 
end
function rk.op2(e,tp)
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
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
function rk.indes1(c,code,att)
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