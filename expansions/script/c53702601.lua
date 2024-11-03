if AD_Database_3 then return end
AD_Database_3=true
SNNM=SNNM or {}
local s=SNNM
function s.LostLink(c)
	if AD_LostLink_check then return end
	AD_LostLink_check=true
	local markers={0x1,0x2,0x4,0x8,0x20,0x40,0x80,0x100}
	Card.GetLink=function(sc)
		return s.NumNumber(sc:GetLinkMarker(),markers)
	end
	Card.IsLink=function(sc,...)
		local t={...}
		for _,v in ipairs(t) do if s.NumNumber(sc:GetLinkMarker(),markers)==v then return true end end
		return false
	end
	Card.IsLinkAbove=function(sc,link)
		if s.NumNumber(sc:GetLinkMarker(),markers)>=link then return true else return false end
	end
	Card.IsLinkBelow=function(sc,link)
		if s.NumNumber(sc:GetLinkMarker(),markers)<=link then return true else return false end
	end
end
function s.NumNumber(a,hex_numbers)
	local count = 0
	for _, num in ipairs(hex_numbers) do
		if bit.band(a, num) ~= 0 then
			count = count + 1
		end
	end
	return count
end
function s.NumberNum(a)
	local count = 0
	while a > 0 do
		if a & 1 == 1 then
			count = count + 1
		end
		a = a >> 1
	end
	return count
end
function s.ClearWorld(c)
	if s.Clear_World_Check then return end
	s.Clear_World_Check=true
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge0:SetCode(EVENT_ADJUST)
	ge0:SetOperation(s.ClearWorldop)
	Duel.RegisterEffect(ge0,0)
	local f1=Card.CopyEffect
	Card.CopyEffect=function(sc,code,rf,ct)
		if code==33900648 then
			local token=Duel.CreateToken(sc:GetControler(),33900648)
			getmetatable(sc).attributechk=getmetatable(token).attributechk
		end
		local cid=f1(sc,code,rf,ct)
		if code==33900648 then
			local rct=ct or 1
			local e1=Effect.CreateEffect(sc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetRange(LOCATION_FZONE)
			e1:SetTargetRange(1,0)
			e1:SetCode(33900648)
			e1:SetCondition(s.ClearWorldRpcon)
			if rf and rf~=0 then e1:SetReset(rf,rct) end
			sc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(sc)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTargetRange(1,1)
			e2:SetCode(53797114)
			e2:SetLabel(cid)
			e2:SetLabelObject(e1)
			Duel.RegisterEffect(e2,0)
		end
		return cid
	end
	local f2=Card.ResetEffect
	Card.ResetEffect=function(sc,rc,rt)
		if rt==RESET_COPY then
			local le={Duel.IsPlayerAffectedByEffect(0,53797114)}
			for _,v in pairs(le) do
				if v:GetLabel()==rc and v:GetLabelObject() and v:GetLabelObject():GetOwner()==sc then v:GetLabelObject():Reset() end
			end
		end
		return f2(sc,rc,rt)
	end
	local f3=Card.ReplaceEffect
	Card.ReplaceEffect=function(sc,code,rf,ct)
		if code==33900648 then
			local token=Duel.CreateToken(sc:GetControler(),33900648)
			getmetatable(sc).attributechk=getmetatable(token).attributechk
		end
		local cid=f3(sc,code,rf,ct)
		local rct=ct or 1
		if code==33900648 then
			local e1=Effect.CreateEffect(sc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetRange(LOCATION_FZONE)
			e1:SetTargetRange(1,0)
			e1:SetCode(33900648)
			e1:SetCondition(s.ClearWorldRpcon)
			if rf and rf~=0 then e1:SetReset(rf,rct) end
			sc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(sc)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTargetRange(1,1)
			e2:SetCode(53797114)
			e2:SetLabel(cid)
			e2:SetLabelObject(e1)
			Duel.RegisterEffect(e2,0)
		elseif sc:GetOriginalCode()==33900648 and code~=0 then
			if rf and rf~=0 then sc:RegisterFlagEffect(53797114,rf,0,ct) else sc:RegisterFlagEffect(53797114,0,0,0) end
		end
		return cid
	end
end
function s.ClearWorldRpcon(e)
	return e:GetHandler():GetFlagEffect(53797114)==0
end
function s.ClearWorldop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Group.__add(Duel.GetFieldGroup(0,0xff,0xff),Duel.GetOverlayGroup(0,1,1)):Filter(function(c)return c:GetOriginalCode()==33900648 end,nil)
	local g=sg:Filter(function(c)return c:GetFlagEffect(id)==0 end,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(id,0,0,0)
		tc:SetStatus(STATUS_INITIALIZING,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_FZONE)
		e1:SetTargetRange(1,0)
		e1:SetCode(33900648)
		e1:SetCondition(s.ClearWorldRpcon)
		tc:RegisterEffect(e1,true)
		tc:SetStatus(STATUS_INITIALIZING,false)
		local f=getmetatable(tc).attributechk
		getmetatable(tc).attributechk=function(p)
			local attchk=f(p)
			if not Duel.IsPlayerAffectedByEffect(p,97811903) and not Duel.IsPlayerAffectedByEffect(p,6089145) then
				local le1={Duel.IsPlayerAffectedByEffect(p,53797115)}
				for _,v in pairs(le1) do
					local val=v:GetValue()
					if aux.GetValueType(val)~="number" then val=val(v) end
					attchk=attchk|val
				end
				local le2={Duel.IsPlayerAffectedByEffect(p,53797116)}
				for _,v in pairs(le2) do
					local val=v:GetValue()
					if aux.GetValueType(val)~="number" then val=val(v) end
					attchk=attchk&(~val)
				end
			end
			return attchk
		end
	end
end
function s.ClearWorldAttCheck(ap,ep)
	local attchk=0
	local le={Duel.IsPlayerAffectedByEffect(ap,33900648)}
	for _,v in pairs(le) do
		attchk=(getmetatable(v:GetOwner()).attributechk)(ep)
	end
	return attchk
end
