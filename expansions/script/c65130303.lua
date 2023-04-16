--未完成伊吕波
function c65130303.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCondition(c65130303.copycon)
	e1:SetOperation(c65130303.copyop)
	c:RegisterEffect(e1)
	
	local e5=e1:Clone()
	e5:SetCode(EVENT_CUSTOM+65130303)
	c:RegisterEffect(e5)
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function c65130303.cfilter(c)
	return c:GetOriginalCodeRule()==65130303
end
function c65130303.cfilter2(c,zone1,e)
	local zone2=1<<c:GetSequence()
	return not c:IsOriginalCodeRule(65130303) and c:GetFlagEffect(65130303)==0 and c:GetFlagEffect(65130333)==0 and zone1==zone2|zone1 and not c:IsImmuneToEffect(e) 
end
function c65130303.cfilter3(c,zc,e)
	return not c:IsOriginalCodeRule(65130303) and c:GetFlagEffect(65130303)==0 and c:GetFlagEffect(65130333)==0  and c:GetColumnGroup():IsContains(zc) and not c:IsImmuneToEffect(e)
end
function c65130303.copycon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=0
	local seq=c:GetSequence()
	if seq>0 then zone=zone|(1<<(seq-1)) end
	if seq<4 then zone=zone|(1<<(seq+1)) end
	return Duel.IsExistingMatchingCard(c65130303.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
	and (Duel.IsExistingMatchingCard(c65130303.cfilter2,tp,LOCATION_MZONE,0,1,c,zone,e) or
	Duel.IsExistingMatchingCard(c65130303.cfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c,e))
end
function c65130303.ncopycon0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(65130303)~=0
end
function c65130303.ncopycon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not Duel.IsExistingMatchingCard(c65130303.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and c:GetFlagEffect(65130303)~=0
end
function c65130303.ncfilter2(c,zone1)
	local zone2=1<<c:GetSequence()
	return (c:IsOriginalCodeRule(65130303) or c:GetFlagEffect(65130303)~=0) and zone1==zone2|zone1 
end
function c65130303.ncfilter3(c,zc)
	return (c:IsOriginalCodeRule(65130303) or c:GetFlagEffect(65130303)~=0) and c:GetColumnGroup():IsContains(zc)
end
function c65130303.ncopycon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=0
	local seq=c:GetSequence()
	if seq>0 then zone=zone|(1<<(seq-1)) end
	if seq<4 then zone=zone|(1<<(seq+1)) end	
	return not Duel.IsExistingMatchingCard(c65130303.ncfilter2,tp,LOCATION_MZONE,0,1,c,zone) and not Duel.IsExistingMatchingCard(c65130303.ncfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c) and c:GetFlagEffect(65130303)~=0 end
function c65130303.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsImmuneToEffect(e) then return end
	local zone=0
	local seq=c:GetSequence()
	if seq>0 then zone=zone|(1<<(seq-1)) end
	if seq<4 then zone=zone|(1<<(seq+1)) end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):Filter(c65130303.cfilter2,c,zone,e)
	local tg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE):Filter(c65130303.cfilter3,c,c,e)
	tg=Group.__add(tg,g)
	if tg then 
		for tc in aux.Next(tg) do
			local cid=tc:GetOriginalCodeRule()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(65130304)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			--no iroha 
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetRange(LOCATION_ONFIELD)
			e2:SetCode(EVENT_LEAVE_FIELD)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCondition(c65130303.ncopycon)
			e2:SetOperation(c65130303.ncopyop)
			e2:SetLabel(cid)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			--leave
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_LEAVE_FIELD_P)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetLabel(cid)
			e3:SetCondition(c65130303.ncopycon0)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			e3:SetOperation(c65130303.ncopyop)
			tc:RegisterEffect(e3)
			--move
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4:SetCode(EVENT_MOVE)
			e4:SetRange(LOCATION_MZONE)
			e4:SetLabel(cid)
			e4:SetCondition(c65130303.ncopycon2)
			e4:SetOperation(c65130303.ncopyop)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4)
			--xyz
			--local e5=Effect.CreateEffect(c)
			--e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			--e5:SetCode(EVENT_EVENT_BE_MATERIAL)
			--e5:SetLabel(cid)
			--e5:SetOperation(c65130303.ncopyop)
			--tc:RegisterEffect(e5)
			--custom
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e6:SetRange(LOCATION_MZONE)
			e6:SetCode(EVENT_CUSTOM+65130304)
			e6:SetLabel(cid)
			e6:SetCondition(c65130303.ncopycon2)
			e6:SetOperation(c65130303.ncopyop)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e6)
			tc:CopyEffect(65130303,RESET_EVENT+RESETS_STANDARD)
			tc:RegisterFlagEffect(65130303,RESET_EVENT+RESETS_STANDARD,0,1)
			local Type=tc:GetType()
			--local Lv=tc:GetOriginalLevel()
			--local Rk=tc:GetOriginalRank()
			local Lv=tc:GetLevel()
			local Rk=tc:GetRank()
			local Lk=tc:GetLink()
			local Att=tc:GetOriginalAttribute()
			local Atk=tc:GetBaseAttack()
			local Def=tc:GetBaseDefense()
			local Race=tc:GetOriginalRace()
			local Lkm =0
			if tc:IsType(TYPE_LINK) then 
				local Lkml = {0x001,0x002,0x004,0x008,0x020,0x040,0x080,0x100}   
				for k,v in ipairs(Lkml) do
					if tc:IsLinkMarker(v) then 
						Lkm=Lkm+v
					end
				end
			end
			if tc:IsType(TYPE_XYZ)then
				Lk=9
			end
			if KOISHI_CHECK and Duel.IsExistingMatchingCard(c65130303.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
				tc:SetEntityCode(65130304+Lk,true)
			end
			c65130303.baseop(tc,Type,Lv,Rk,Att,Atk,Def,Race)
			if KOISHI_CHECK and Lkm~=0 then
				c65130303.Linkop(tc,Lkm)
			end
		end
		Duel.RaiseEvent(c,EVENT_CUSTOM+65130303,re,r,rp,ep,ev)
	end
end
function c65130303.baseop(c,Type,Lv,Rk,Att,Atk,Def,Race)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(Atk)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(Def)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(Type)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)	
	if not c:IsType(TYPE_EFFECT) then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_ADD_TYPE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetValue(TYPE_EFFECT)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e4)
	end
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_LEVEL)
	e5:SetValue(Lv)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CHANGE_RANK)
	e6:SetValue(Rk)
	c:RegisterEffect(e6)
	local e7=e1:Clone()
	e7:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e7:SetValue(Att)
	c:RegisterEffect(e7)
	local e8=e1:Clone()
	e8:SetCode(EFFECT_CHANGE_RACE)
	e8:SetValue(Race)
	c:RegisterEffect(e8)
end
function c65130303.Linkop(c,Lkm)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(Lkm)
	c:RegisterEffect(e1)	
end
function c65130303.ncopyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:ResetFlagEffect(65130303)
	local code=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(code)
	c:RegisterEffect(e1)
	if KOISHI_CHECK then
		c:SetEntityCode(code,true)
	end
	c:ResetEffect(65130303,RESET_COPY)
	Duel.RaiseEvent(c,EVENT_CUSTOM+65130304,re,r,rp,ep,ev)
end