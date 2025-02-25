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
function s.ScreemEquips(c,pro)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(s.ScreemEtarget)
	e1:SetOperation(s.ScreemEoperation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetValue(100)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+pro)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(s.ScreemEDcon)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EQUIP_LIMIT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	if not s.ScreemEquips_check then
		s.ScreemEquips_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCode(EVENT_LEAVE_FIELD_P)
		ge1:SetOperation(s.ScreemEvalcheck)
		Duel.RegisterEffect(ge1,0)
	end
	return e4
end
function s.ScreemEDfilter(c)
	local ec=c:GetPreviousEquipTarget()
	return ec and c:GetReason()&0x201==0x201 and c:IsFaceup() and ec:IsReason(REASON_XYZ)-- and c:IsSetCard(0xc538)
end
function s.ScreemEvalcheck(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.ScreemEDfilter,nil)
	g:ForEach(Card.ResetFlagEffect,53762000)
	local mg=Group.CreateGroup()
	for eqc in aux.Next(g) do mg:AddCard(eqc:GetPreviousEquipTarget()) end
	for ec in aux.Next(mg) do
		local eqg=Group.CreateGroup()
		for eqc in aux.Next(g) do if eqc:GetPreviousEquipTarget()==ec then eqg:AddCard(eqc) end end
		g:ForEach(Card.RegisterFlagEffect,53762000,RESET_EVENT+0x1420000,0,1,eqg:GetClassCount(Card.GetCode))
	end
end
function s.ScreemEtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.ScreemEoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function s.ScreemEDcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	return ec and c:GetReason()&0x201==0x201 and ec:IsReason(REASON_XYZ)
end
function s.ScreemTraps(c,gete)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(s.ScreemTcost)
	e1:SetTarget(s.ScreemTtarget)
	e1:SetOperation(s.ScreemToperation(gete))
	c:RegisterEffect(e1)
	return e1
end
function s.ScreemTcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.ScreemTfilter(c)
	return c:IsSetCard(0xc538) and c:IsType(TYPE_TRAP) and (c:IsAbleToHand() or c:IsSSetable())
end
function s.ScreemTtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ScreemTfilter,tp,LOCATION_DECK,0,1,nil) end
	e:GetHandler():CreateEffectRelation(e)
end
function s.ScreemToperation(gete)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				if not e:GetHandler():IsRelateToEffect(e) then return end
				gete(e:GetHandler())
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local tc=Duel.SelectMatchingCard(tp,s.ScreemTfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
				if tc then
					if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
						Duel.SendtoHand(tc,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,tc)
					else
						Duel.SSet(tp,tc)
					end
				end
			end
end
