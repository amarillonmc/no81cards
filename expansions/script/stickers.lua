--Stickers Mechanic library
--Scripted by: XGlitchy30

STICKERS_LOADED	= true
STICKER_FLAG		= 33730121
STICKER_COUNT_FLAG	= 33730122

--Custom Categories
CATEGORY_PLACE_STICKER	=	0x1

--Custom Effects
EFFECT_PLACE_STICKER_REPLACE 		= 33730143
EFFECT_GRANT_STICKER_EFFECT			= 33730144
EFFECT_GRANT_PLAYER_STICKER_EFFECT	= 33730145

--Table of Stickers
STICKER_PEERLESSLY_CUTE_FAIRY_TALE_GIRL 	= 0x1
STICKER_LOST_TO_KOMARI 						= 0x2
STICKER_A_TAD_MISCHIEVOUS_ANEGO 			= 0x3
STICKER_LOST_TO_KURUGAYA					= 0x4
STICKER_EASYGOING_NOISY_GIRL				= 0x5
STICKER_LOST_TO_HARUKA						= 0x6
STICKER_EXOTIC_SELF_PROCLAIMED_MASCOT		= 0x7
STICKER_LOST_TO_KUD							= 0x8
STICKER_PARASOL_HOLDING_SILENT_BEAUTY		= 0x9
STICKER_LOST_TO_MIO							= 0xa
STICKER_ORDINARY_BOY						= 0xb
STICKER_LOST_TO_RIKI						= 0xc
STICKER_PRIDEFUL_KITTEN						= 0xd
STICKER_LOST_TO_RIN							= 0xe
STICKER_LEADER_WHO_TURNS_DAYS_INTO_MISSIONS	= 0xf
STICKER_LOST_TO_KYOUSUKE					= 0x10
STICKER_LOVABLE_STRAIGHT_MUSCLE_IDIOT		= 0x11
STICKER_LOST_TO_MASATO						= 0x12
STICKER_MASATOS_STRONGEST_RIVAL				= 0x13
STICKER_LOST_TO_KENGO						= 0x14

STICKERS_TABLE = {}

STICKER_EFFECTS_TABLE = {}

-- local _Clone = Effect.Clone

-- Effect.Clone = function(e)

-- end

function Auxiliary.GetStickerDescription(sticker)
	return aux.Stringid(table.unpack(STICKERS_TABLE[sticker]))
end
function Auxiliary.GetStickerOwner(sticker)
	return STICKERS_TABLE[sticker][1]
end

--Functions
function Card.GetSticker(c,p)
	if not c:HasFlagEffect(c,STICKER_FLAG) then return end
	local stickers,descs={},{}
	for _,label in ipairs({c:GetFlagEffectLabel(STICKER_FLAG)}) do
		local desc=aux.GetStickerDescription(label)
		if not aux.FindInTable(descs,desc) then
			table.insert(stickers,label)
			table.insert(descs,desc)
		end
	end
	local opt=Duel.SelectOption(p,table.unpack(descs))+1
	local sticker=stickers[opt]
	return sticker, STICKERS_TABLE[sticker][1]
end
function Card.GetAllStickers(c)
	local stickers={}
	for _,label in ipairs({c:GetFlagEffectLabel(STICKER_FLAG)}) do
		table.insert(stickers,label)
	end
	return stickers
end
function Card.GetStickerCount(c,sticker)
	if not c:GetFlagEffect(STICKER_FLAG) then return 0 end
	if not sticker then
		return c:GetFlagEffect(STICKER_FLAG)
	else
		local ct=0
		for _,label in ipairs({c:GetFlagEffectLabel(STICKER_FLAG)}) do
			if label==sticker then
				ct=ct+1
			end
		end
		return ct
	end
end
function Duel.GetStickerCountOnPlayer(p,sticker)
	if not Duel.GetFlagEffect(STICKER_FLAG) then return 0 end
	if not sticker then
		return Duel.GetFlagEffect(STICKER_FLAG)
	else
		local ct=0
		for _,label in ipairs({Duel.GetFlagEffectLabel(p,STICKER_FLAG)}) do
			if label==sticker then
				ct=ct+1
			end
		end
		return ct
	end
end
function Card.GetStickerClassCount(c)
	local counted={}
	for _,label in ipairs({c:GetFlagEffectLabel(STICKER_FLAG)}) do
		if not aux.FindInTable(counted,label) then
			table.insert(counted,label)
		end
	end
	return #counted
end
function Card.HasSticker(c,sticker)
	return c:GetStickerCount(sticker)>0
end
function Card.IsCanAddSticker(c,sticker,ct,e,tp,r)
	return true	--placeholder
end
function Duel.IsCanAddStickerOnPlayer(p,sticker,ct,e,tp,r)
	return true	--placeholder
end

aux.TempAddedStickerCount = 0
function Card.AddSticker(c,sticker,ct,e,tp,r,temp)
	if not c:IsCanAddSticker(sticker,ct,e,tp,r) then return 0 end
	local ct0=c:GetStickerCount(sticker)
	if c:HasFlagEffectLabel(STICKER_COUNT_FLAG,sticker) then
		for _,fe in ipairs({c:IsHasEffect(STICKER_COUNT_FLAG|EFFECT_FLAG_EFFECT)}) do
			if fe:GetLabel()==sticker then
				fe:Reset()
			end
		end
	end
	local gc=Group.FromCards(c)
	if r&REASON_REPLACE==REASON_REPLACE or not c:IsHasEffect(EFFECT_PLACE_STICKER_REPLACE) then
		for i=1,ct do
			Duel.HintSelection(gc)
			c:RegisterFlagEffect(STICKER_FLAG,RESET_EVENT|RESETS_STANDARD_FACEDOWN,0,1,sticker)
			c:GainStickerEffect(sticker,ct0+i)
			if temp then
				aux.TempAddedStickerCount = aux.TempAddedStickerCount + 1
			end
		end
	else
		local g=Group.CreateGroup()
		local effects,descs={},{}
		for _,ce in ipairs({c:IsHasEffect(EFFECT_PLACE_STICKER_REPLACE)}) do
			local op=ce:GetOperation()
			if not op or op(ce,c,sticker,ct,e,tp,r,0) then
				local hc=ce:GetHandler()
				if not g:IsContains(hc) then
					g:AddCard(hc)
					effects[hc]={}
					descs[hc]={}
				end
				table.insert(effects[hc],ce)
				table.insert(descs[hc],ce:GetDescription())
			end	
		end
		if #g==0 or not Duel.SelectYesNo(tp,aux.Stringid(EFFECT_PLACE_STICKER_REPLACE,2)) then
			for i=1,ct do
				Duel.HintSelection(gc)
				c:RegisterFlagEffect(STICKER_FLAG,RESET_EVENT|RESETS_STANDARD_FACEDOWN,0,1,sticker)
				c:GainStickerEffect(sticker,ct0+i)
				if temp then
					aux.TempAddedStickerCount = aux.TempAddedStickerCount + 1
				end
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33730143,3))
			local hc=g:Select(tp,1,1,nil):GetFirst()
			local ce=effects[hc][Duel.SelectOption(tp,table.unpack(descs[hc]))+1]
			ce:GetOperation()(ce,c,sticker,ct,e,tp,r,1)
		end
	end
	
	local ct1=c:GetStickerCount(sticker)
	if ct1>0 then
		c:RegisterFlagEffect(STICKER_COUNT_FLAG,RESET_EVENT|RESETS_STANDARD_FACEDOWN,EFFECT_FLAG_CLIENT_HINT,1,sticker,aux.GetStickerDescription(sticker)+math.min(5,ct1-1))
	end
	return math.max(0,ct1-ct0)
end
function Card.AddStickerComplete(c)
	local val=aux.TempAddedStickerCount
	aux.TempAddedStickerCount=0
	return val
end

function Duel.AddStickerOnPlayer(p,sticker,ct,e,tp,r)
	if not Duel.IsCanAddStickerOnPlayer(p,sticker,ct,e,tp,r) then return 0 end
	local ct0=Duel.GetStickerCountOnPlayer(p,sticker)
	if Duel.PlayerHasFlagEffectLabel(p,STICKER_COUNT_FLAG,sticker) then
		for _,fe in ipairs({Duel.IsPlayerAffectedByEffect(p,STICKER_COUNT_FLAG|EFFECT_FLAG_EFFECT)}) do
			if fe:GetLabel()==sticker then
				fe:Reset()
			end
		end
	end

	for i=1,ct do
		Duel.RegisterFlagEffect(p,STICKER_FLAG,0,0,1,sticker)
		Duel.GainStickerEffect(p,sticker,ct0+i)
	end
	
	local ct1=Duel.GetStickerCountOnPlayer(p,sticker)
	if ct1>0 then
		local fe=Duel.RegisterFlagEffect(p,STICKER_COUNT_FLAG,0,EFFECT_FLAG_CLIENT_HINT,1,sticker)
		local fe2=fe:Clone()
		fe2:SetDescription(aux.GetStickerDescription(sticker)+math.min(5,ct1-1))
		Duel.RegisterEffect(fe2,p)
		fe:Reset()
	end
	return math.max(0,ct1-ct0)
end

--Register Sticker Effects
function Auxiliary.RegisterStickerEffect(sticker,f)
	if not STICKER_EFFECTS_TABLE[sticker] then
		STICKER_EFFECTS_TABLE[sticker] = f
	end
end
function Card.GainStickerEffect(c,sticker,ct)
	if c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE|EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetCondition(Auxiliary.StickerEffectCondition(sticker))
		e1:SetValue(TYPE_EFFECT)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
		c:RegisterEffect(e1,true)
	end
	local f=STICKER_EFFECTS_TABLE[sticker]
	if not f then return end
	local effects={f(c)}
	for _,e in ipairs(effects) do
		local cond=e:GetCondition()
		e:SetCondition(aux.StickerEffectCondition(sticker,ct,cond))
		
		if e:GetType()==EFFECT_TYPE_FIELD then
			local ge=Effect.CreateEffect(c)
			ge:SetType(EFFECT_TYPE_FIELD)
			ge:SetProperty(e:GetProperty())
			ge:SetCode(e:GetCode())
			local tg=e:GetTarget()
			if tg then
				ge:SetTarget(tg)
			end
			local val=e:GetValue()
			if val then
				ge:SetValue(val)
			end
			
			local p=c:GetControler()
			local s,o=e:GLGetTargetRange()
			ge:SetAbsoluteRange(p,s,o)
			ge:SetCondition(aux.StickerFaceDownFieldEffectCondition(p,e:GetCondition()))
			Duel.RegisterEffect(ge,p)
			
			local ge2=ge:Clone()
			ge2:SetAbsoluteRange(p,o,s)
			ge2:SetCondition(aux.StickerFaceDownFieldEffectCondition(1-p,e:GetCondition()))
			Duel.RegisterEffect(ge2,p)
		
		elseif e:IsActivated() then
			local cost=e:GetCost()
			e:SetCost(aux.StickerInfoCost(sticker,cost))
		end
		
		c:RegisterEffect(e)
		
		local clone=e:Clone()
		clone:SetCondition(cond or aux.TRUE)
		local gr=Effect.CreateEffect(c)
		gr:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_GRANT)
		gr:SetRange(LOCATION_ONFIELD)
		gr:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		gr:SetCondition(aux.StickerGrantEffectCondition(sticker,ct))
		gr:SetTarget(aux.StickerGrantEffectTarget)
		gr:SetLabelObject(clone)
		c:RegisterEffect(gr)
		
		local ge=e:Clone()
		ge:SetOwnerPlayer(0)
		ge:SetCondition(aux.StickerPlayerEffectCondition(0,sticker,ct,cond))
		Duel.RegisterEffect(ge,0)
		local ge2=e:Clone()
		ge2:SetOwnerPlayer(1)
		ge2:SetCondition(aux.StickerPlayerEffectCondition(1,sticker,ct,cond))
		Duel.RegisterEffect(ge2,1)
		
	end
	return table.unpack(effects)
end

Auxiliary.StickerPlayerEffectTable = {}

local _GetHandlerPlayer = Effect.GetHandlerPlayer

Effect.GetHandlerPlayer = function(e)
	local p=aux.StickerPlayerEffectTable[e]
	if p then
		return p
	else
		return _GetHandlerPlayer(e)
	end
end

function Duel.GainStickerEffect(p,sticker,ct)
	local f=STICKER_EFFECTS_TABLE[sticker]
	if not f then return end
	local effects={f(aux.GlitchyHelper)}
	for _,e in ipairs(effects) do
		aux.StickerPlayerEffectTable[e]=p
		
		local cond=e:GetCondition()
		e:SetCondition(aux.StickerPlayerEffectCondition2(p,sticker,ct,cond))
		
		if e:IsActivated() then
			local cost=e:GetCost()
			e:SetCost(aux.StickerInfoCost(sticker,cost))
		end
		
		Duel.RegisterEffect(e,p)
	end
	return table.unpack(effects)
end

function Auxiliary.StickerEffectCondition(sticker,ct,f)
	return	function(e,...)
				if e:GetHandler():GetStickerCount(sticker)<ct then
					e:Reset()
					return false
				end
				return not f or f(e,...)
			end
end
function Auxiliary.StickerGrantEffectCondition(sticker,ct)
	return	function(e,...)
				local c=e:GetHandler()
				if c:GetStickerCount(sticker)<ct then
					e:Reset()
					return false
				end
				for _,ce in ipairs({c:IsHasEffect(EFFECT_GRANT_STICKER_EFFECT)}) do
					local cond=ce:GetCondition()
					if not cond or cond(e) then
						return true
					end
				end
				return false
			end
end
function Auxiliary.StickerGrantEffectTarget(e,c)
	for _,ce in ipairs({e:GetHandler():IsHasEffect(EFFECT_GRANT_STICKER_EFFECT)}) do
		local tg=ce:GetTarget()
		if not tg or tg(e,c) then
			return true
		end
	end
	return false
end
function Auxiliary.StickerPlayerEffectCondition(tp,sticker,ct,f)
	return	function(e,...)
				local c=e:GetHandler()
				if c:GetStickerCount(sticker)<ct then
					e:Reset()
					return false
				end
				local check=false
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_GRANT_PLAYER_STICKER_EFFECT)}
				for _,ce in ipairs(eset) do
					if ce:GetHandler()==c then
						check=true
						break
					end
				end
				return check and (not f or f(e,...))
			end
end
function Auxiliary.StickerPlayerEffectCondition2(tp,sticker,ct,f)
	return	function(e,...)
				if Duel.GetStickerCountOnPlayer(tp,sticker)<ct then
					aux.StickerPlayerEffectTable[e]=nil
					e:Reset()
					return false
				end
				return not f or f(e,...)
			end
end
function Auxiliary.StickerFaceDownFieldEffectCondition(p,f)
	return	function(e,...)
				local c=e:GetHandler()
				return c:IsOnField() and c:IsFacedown() and c:IsControler(p) and (not f or f(e,...))
			end
end
function Auxiliary.oppoact(e,tp,eg,ep,ev,re,r,rp)
	return tp==1-e:GetHandlerPlayer()
end
function Auxiliary.StickerInfoCost(sticker,f)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					return not f or f(e,tp,eg,ep,ev,re,r,rp,chk)
				end
				local owner=aux.GetStickerOwner(sticker)
				local token=Duel.CreateToken(tp,owner)
				Duel.ConfirmCards(1-tp,token)
				Duel.Exile(token,REASON_RULE)
				if f then
					f(e,tp,eg,ep,ev,re,r,rp,chk)
				end
			end
end