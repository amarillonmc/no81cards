--千篇万花
function c33710901.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33710901,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33710901.target)
	e1:SetOperation(c33710901.activate)
	c:RegisterEffect(e1)
	--forbidden
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0x7f,0x7f)
	e2:SetTarget(c33710901.bantg)
	e2:SetValue(c33710901.cval)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33710901,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetCondition(c33710901.spcon)
	e3:SetTarget(c33710901.sptg)
	e3:SetOperation(c33710901.spop)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	--EFFECT GAIN
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_SZONE)
	e5:SetLabelObject(e1)
	e5:SetOperation(c33710901.op)
	c:RegisterEffect(e5)
	--
end
function c33710901.eftg(e,c)
	local code=e:GetLabelObject():GetLabelObject():GetLabel()
	return c:IsType(TYPE_MONSTER) and c:GetOriginalCode()==code
end
function c33710901.acfilter(c,code,mc)
	return c:GetTextAttack()==mc:GetTextAttack() and c:GetTextDefense()==mc:GetTextDefense() and c:GetOriginalCode()~=code and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER) and c:GetLevel()==mc:GetLevel() and c:GetAttribute()==mc:GetAttribute() and c:GetRace()==mc:GetRace()
end
function c33710901.acfilter1(c,code,mc)
	if c:GetTextAttack()==mc:GetTextAttack() and c:GetTextDefense()==mc:GetTextDefense() and c:GetOriginalCode()~=code and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)and c:GetLevel()==mc:GetLevel() and c:GetAttribute()==mc:GetAttribute() and c:GetRace()==mc:GetRace()
		then c:RegisterFlagEffect(code+16100000000,RESET_CHAIN,0,0) return true
	else return false
	end 
end
function c33710901.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local flag=0
	local ag=Group.CreateGroup()
	local codes={}
	for c in aux.Next(g) do
		local code=c:GetCode()
		if not ag:IsExists(Card.IsCode,1,nil,code) and g:IsExists(c33710901.acfilter,1,nil,code,c) and c:IsType(TYPE_MONSTER) then
				ag:AddCard(c)
				table.insert(codes,code)
				flag=1
		end
	end
	if chk==0 then return flag==1 end
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local flag=0
	local ag=Group.CreateGroup()
	local codes1={}
	for c in aux.Next(g) do
		local code=c:GetCode()
		if not ag:IsExists(Card.IsCode,1,nil,code) then
			local sg=Duel.GetMatchingGroup(c33710901.acfilter1,tp,LOCATION_DECK,0,nil,code,c)
			if sg:GetCount()>0 and c:IsType(TYPE_MONSTER) then
				ag:AddCard(c)
				table.insert(codes1,code)
				flag=1
			end
		end
	end
	table.sort(codes1)
	--c:IsCode(codes[1])
	local afilter={codes1[1],OPCODE_ISCODE}
	if #codes1>1 then
		--or ... or c:IsCode(codes[i])
		for i=2,#codes1 do
			table.insert(afilter,codes1[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	getmetatable(e:GetHandler()).announce_filter={TYPE_SPELL+TYPE_TRAP,OPCODE_ISTYPE,OPCODE_NOT}
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c33710901.filter(c,code)
	return c:IsAbleToRemove() and c:GetFlagEffect(code+16100000000)~=0 and c:GetCode()~=code
end
function c33710901.copyfilter(c,code)
	return c:GetOriginalCode()==code
end
function c33710901.copyfilter22(c,code)
	return c:GetFlagEffect(33710901)~=0
end
function c33710901.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c33710901.filter,tp,LOCATION_DECK,0,1,1,nil,ac):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		e:SetLabel(ac)
		e:SetLabelObject(tc)
		e:GetHandler():RegisterFlagEffect(16133710901,RESET_EVENT+RESETS_STANDARD,0,0)
		local g=Duel.GetMatchingGroup(c33710901.copyfilter,tp,0x7f,0x7f,nil,ac)
		for gc in aux.Next(g) do
			tc:RegisterFlagEffect(33710901,RESET_EVENT+EVENT_CUSTOM+33710901,0,0)
			local cid=tc:CopyEffect(tc:GetOriginalCode(),0)
			local e0=Effect.CreateEffect(tc)
			e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e0:SetCode(EVENT_ADJUST)
			e0:SetLabel(cid)
			e0:SetLabelObject(e:GetHandler())
			e0:SetOperation(c33710901.resetop)
			Duel.RegisterEffect(e0,tp)
		end
	end
end
function c33710901.resetop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetFlagEffect(16133710901)==0 then
		local c=e:GetOwner()
		local cid=e:GetLabel()
		if cid~=0 then
			c:ResetEffect(cid,RESET_COPY)
			c:ResetEffect(RESET_DISABLE,RESET_EVENT)
			c:ResetFlagEffect(33710901)
		end
		e:Reset()
	end
end
function c33710901.resetop1(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message(1)
end
function c33710901.bantg(e,c)
	local code1,code2=c:GetOriginalCodeRule()
	local fcode=e:GetLabelObject():GetLabel()
	return (code1==fcode or code2==fcode) and (not c:IsOnField() or c:GetRealFieldID()>e:GetFieldID())
end
function c33710901.cval(e)
	return e:GetLabelObject():GetLabelObject():GetOriginalCode()
end
function c33710901.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousControler()==tp
end
function c33710901.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c33710901.spop(e,tp,eg,ep,ev,re,r,rp)
	local fc=e:GetLabelObject():GetLabelObject()
	if not fc then return end
	local code=fc:GetCode()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetLabel(code)
	e1:SetValue(c33710901.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33710901.actlimit(e,te,tp)
	return te:GetHandler():GetCode()==e:GetLabel()
end
function c33710901.copyfilter1(c,code)
	return c:GetOriginalCode()==code and c:GetFlagEffect(33710901)==0
end
function c33710901.op(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabelObject():GetLabel()
	local ac=e:GetLabelObject():GetLabelObject():GetOriginalCode()
	local g=Duel.GetMatchingGroup(c33710901.copyfilter1,tp,0x7f,0x7f,nil,code)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(33710901,RESET_EVENT+EVENT_CUSTOM+33710901,0,0)
		local cid=tc:CopyEffect(ac,0)
			local e0=Effect.CreateEffect(tc)
			e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e0:SetCode(EVENT_ADJUST)
			e0:SetLabel(cid)
			e0:SetLabelObject(e:GetHandler())
			e0:SetOperation(c33710901.resetop)
			Duel.RegisterEffect(e0,tp)
	end
end