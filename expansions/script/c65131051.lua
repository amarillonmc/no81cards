--🥒
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EFFECT_SEND_REPLACE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e0:SetTarget(s.resetg)
	e0:SetValue(aux.TRUE)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCondition(s.cpcon)
	e1:SetOperation(s.cpop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
end
local KOISHI_CHECK=false
if Duel.DisableActionCheck then KOISHI_CHECK=true end
function s.resetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_ONFIELD) and c:GetOriginalCode()==id end
	if c:IsFacedown() then Duel.ConfirmCards(1-tp,c) end
	c:SetEntityCode(id-1,true)
	c:ReplaceEffect(id-1,0,0)
	return false
end
function s.xylabel(c,tp)
	local x=c:GetSequence()
	local y=0
	if c:GetControler()==tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then y=0
		else x,y=-1,0.5 end
	elseif c:GetControler()==1-tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then x,y=4-x,4
		else x,y=5,3.5 end
	end
	return x,y
end
function s.distance(ac,bc,tp)
	local ax,ay=s.xylabel(ac,tp)
	local bx,by=s.xylabel(bc,tp)
	return ((by-ay)*(by-ay)+(ax-bx)*(ax-bx))*1000
end
function s.cpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ng=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if ng:GetCount()==0 then return false end
	local tc=e:GetLabelObject()
	if not tc then return true end
	local ag=ng:GetMinGroup(s.distance,c,tp)
	local res=tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and ag:IsContains(tc)
	return not res
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ng=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	local ag=ng:GetMinGroup(s.distance,c,tp)
	if ag:GetCount()>1 then
		ag=ag:Select(tp,1,1,nil)
	end
	if ag:GetCount()>0 then
		Duel.HintSelection(ag)
		local ac=e:GetLabelObject()
		local aid=e:GetLabel()
		if ac and aid then
			s.resetcopy(c,ac,aid)
		end
		local tc=ag:GetFirst()
		e:SetLabelObject(tc)
		c:SetCardTarget(tc)
		local code=tc:GetOriginalCodeRule()
		local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD)
		e:SetLabel(cid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		if code>=11451900 and code<=11451905 then
			e1:SetDescription(aux.Stringid(code,5))
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		end
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0xffffff+code+11451907,RESET_EVENT+RESETS_STANDARD,0,1)
		local re=Effect.CreateEffect(c)
		re:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		re:SetRange(LOCATION_MZONE)
		re:SetCode(EVENT_ADJUST)
		re:SetLabelObject(e)
		re:SetCondition(s.resetcon)
		re:SetOperation(s.resetop)
		re:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(re)
	end
end
function s.resetcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ce=e:GetLabelObject()
	local tc=ce:GetLabelObject()
	return not tc:IsLocation(LOCATION_MZONE) or not tc:IsFaceup()
end
function s.resetcopy(c,tc,cid)
	local code=tc:GetOriginalCodeRule()
	c:CancelCardTarget(tc)
	local num=c:GetFlagEffect(0xffffff+code+11451907)
	c:ResetFlagEffect(0xffffff+code+11451907)
	if num>1 then c:RegisterFlagEffect(0xffffff+code+11451907,RESET_EVENT+RESETS_STANDARD,0,1) end
	c:ResetEffect(cid,RESET_COPY)
	local elist={c:IsHasEffect(EFFECT_ADD_CODE)}
	for _,v in pairs(elist) do
		if v:GetValue()==code then v:Reset() end
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ce=e:GetLabelObject()
	local cid=ce:GetLabel()
	local tc=ce:GetLabelObject()
	s.resetcopy(c,tc,cid)
	e:Reset()
end
function s.efilter(e,te)
	if te and te:GetHandler() and e:GetHandler()~=te:GetHandler() and not te:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) and (te:GetCode()<0x10000 or te:IsHasType(EFFECT_TYPE_ACTIONS)) and te:GetCode()~=16 and te:GetCode()~=359 then
		local e1=Effect.CreateEffect(te:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabelObject(e:GetHandler())
		e1:SetCondition(function() return not pnfl_adjusting end)
		e1:SetOperation(s.acop)
		Duel.RegisterEffect(e1,te:GetHandlerPlayer())
		return true
	end
	return false
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	if pnfl_adjusting then return end
	pnfl_adjusting=true
	local c=e:GetLabelObject()
	local ph=Duel.GetCurrentPhase()
	local pos=c:GetPosition()
	local seq=c:GetSequence()
	if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)>0 and c:IsLocation(LOCATION_REMOVED) then
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE_START+ph)
		e1:SetLabel(fid,pos,seq)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
		pnfl_adjusting=false
	end
	e:Reset()
end
function s.retfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject():GetFlagEffectLabel(id)==fid then
		e:Reset()
		return false
	end
	return true
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local fid,pos,seq=e:GetLabel()
	local c=e:GetLabelObject()
	if c:GetFlagEffectLabel(id)==fid then
		Duel.Hint(HINT_CARD,0,id)
		local ex=0x60
		if not Duel.CheckLocation(pi,LOCATION_MZONE,i) then 
			ex=ex|2^i
		end
		if ex==0x7f then
			Duel.SendtoGrave(c,REASON_RULE+REASON_RETURN)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local flag=Duel.SelectField(tp,1,LOCATION_MZONE,0,ex)
			Duel.MoveToField(c,tp,tp,LOCATION_MZONE,pos,true,flag)
		end
	end
	e:Reset()
end