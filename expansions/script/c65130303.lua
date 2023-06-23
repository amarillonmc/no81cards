--未完成伊吕波
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCondition(s.changecon)
	e1:SetOperation(s.changeop)
	c:RegisterEffect(e1)
	
	local e5=e1:Clone()
	e5:SetCode(EVENT_CUSTOM+id)
	c:RegisterEffect(e5)
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.cfilter(c)
	return c:GetOriginalCode()==id and c:IsFaceup() and not c:IsDisabled()
end
function s.zfilter1(c,zone1,e)
	local zone2=1<<c:GetSequence()
	return c:GetOriginalCode()~=id and c:GetFlagEffect(id)==0 and c:GetFlagEffect(65130333)==0 and zone1==zone2|zone1 and c:IsFaceup() and not c:IsImmuneToEffect(e) 
end
function s.zfilter2(c,zc,e)
	return c:GetOriginalCode()~=id and c:GetFlagEffect(id)==0 and c:GetFlagEffect(65130333)==0 and c:GetColumnGroup():IsContains(zc) and c:IsFaceup() and not c:IsImmuneToEffect(e)
end
function s.changecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=0
	local seq=c:GetSequence()
	if seq>0 and seq<5 then zone=zone|(1<<(seq-1)) end
	if seq<4 then zone=zone|(1<<(seq+1)) end
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
	and (Duel.IsExistingMatchingCard(s.zfilter1,tp,LOCATION_MZONE,0,1,c,zone,e) or
	Duel.IsExistingMatchingCard(s.zfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c,e))
end
function s.unchangecon0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(id)~=0
end
function s.unchangecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and c:GetFlagEffect(id)~=0
end
function s.unzfilter1(c,zone1)
	local zone2=1<<c:GetSequence()
	return (c:GetOriginalCode()==id or c:GetFlagEffect(id)~=0) and not c:IsDisabled() and zone1==zone2|zone1 
end
function s.unzfilter2(c,zc)
	return (c:GetOriginalCode()==id or c:GetFlagEffect(id)~=0) and not c:IsDisabled() and c:GetColumnGroup():IsContains(zc)
end
function s.unchangecon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=0
	local seq=c:GetSequence()
	if seq>0 and seq<5 then zone=zone|(1<<(seq-1)) end
	if seq<4 then zone=zone|(1<<(seq+1)) end	
	return not Duel.IsExistingMatchingCard(s.unzfilter1,tp,LOCATION_MZONE,0,1,nil,zone) and not Duel.IsExistingMatchingCard(s.unzfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c) and c:GetFlagEffect(id)~=0 end
function s.changeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsImmuneToEffect(e) then return end
	local zone=0
	local seq=c:GetSequence()
	if seq>0 and seq<5 then zone=zone|(1<<(seq-1)) end
	if seq<4 then zone=zone|(1<<(seq+1)) end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):Filter(s.zfilter1,c,zone,e)
	local tg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE):Filter(s.zfilter2,c,c,e)
	tg=Group.__add(tg,g)
	if tg then 
		for tc in aux.Next(tg) do
			local cid=tc:GetOriginalCode()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(id+1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			--no iroha 
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EVENT_LEAVE_FIELD)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCondition(s.unchangecon)
			e2:SetOperation(s.unchangeop)
			e2:SetLabel(cid)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			--leave
			local e3=e2:Clone()
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_LEAVE_FIELD_P)
			e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():GetFlagEffect(id)~=0 end)
			tc:RegisterEffect(e3)
			--move
			local e4=e2:Clone()
			e4:SetCode(EVENT_MOVE)
			e4:SetCondition(s.unchangecon2)
			tc:RegisterEffect(e4)
			--custom
			local e6=e2:Clone()
			e6:SetCode(EVENT_CUSTOM+id+1)
			e6:SetCondition(s.unchangecon2)
			tc:RegisterEffect(e6)

			tc:CopyEffect(id,RESET_EVENT+RESETS_STANDARD)
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
			local Lk=tc:GetLink()
			if tc:IsType(TYPE_XYZ)then
				Lk=9
			end
			if KOISHI_CHECK and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then				
				tc:SetCardData(CARDDATA_CODE,id+1+Lk)
			end
			if not tc:IsType(TYPE_EFFECT) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_ADD_TYPE)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(TYPE_EFFECT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e1)
			end
		end
		Duel.RaiseEvent(c,EVENT_CUSTOM+id,re,r,rp,ep,ev)
	end
end
function s.unchangeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:ResetFlagEffect(id)
	local code=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(code)
	c:RegisterEffect(e1)
	if KOISHI_CHECK then		
		c:SetCardData(CARDDATA_CODE,code) 
	end
	c:ResetEffect(id,RESET_COPY)
	Duel.RaiseEvent(c,EVENT_CUSTOM+id+1,re,r,rp,ep,ev)
end