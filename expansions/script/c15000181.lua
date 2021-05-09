local m=15000181
local cm=_G["c"..m]
cm.name="远海的歌"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,1,15000181)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--act in set turn
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCondition(cm.actcon)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--effect gain (ATK)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(500)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(cm.eftg)
	e5:SetLabelObject(e3)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetLabelObject(e4)
	c:RegisterEffect(e6)
	--effect gain (Destroy)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,7))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(cm.reptg)
	e7:SetOperation(cm.repop)
	e7:SetLabelObject(c)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e8:SetRange(LOCATION_SZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(cm.eftg)
	e8:SetLabelObject(e7)
	c:RegisterEffect(e8)
	--force mzone
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_MUST_USE_MZONE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(0,0xff)
	e9:SetValue(cm.frcval)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e10:SetRange(LOCATION_SZONE)
	e10:SetTargetRange(LOCATION_MZONE,0)
	e10:SetTarget(cm.eftg)
	e10:SetLabelObject(e9)
	c:RegisterEffect(e10)
	--?彩 蛋
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetRange(0xff)
	e11:SetCode(EVENT_LEAVE_FIELD)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCondition(cm.cdcon1)
	e11:SetOperation(cm.cdop1)
	c:RegisterEffect(e11)
end
function cm.actcon(e)
	return not Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29010023,nil,0x4011,1500,1500,1,RACE_AQUA,ATTRIBUTE_WATER)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,29010023,nil,0x4011,1500,1500,1,RACE_AQUA,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,29010023)
	local fid=e:GetHandler():GetFieldID()
	local g=Group.CreateGroup()
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
		token:RegisterFlagEffect(15000181,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		g:AddCard(token)
		Duel.SpecialSummonComplete()
	end
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(g)
	e1:SetCondition(cm.descon)
	e1:SetOperation(cm.desop)
	Duel.RegisterEffect(e1,tp)
end
function cm.desfilter(c,fid)
	return c:GetFlagEffectLabel(15000181)==fid
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end
function cm.efilter(c,sc,seq,tp)
	local seq2=c:GetSequence()
	local b=false
	if c:GetControler()==tp and seq2<5 and c:IsLocation(LOCATION_MZONE) then
		if (seq2==0 or seq2==1 or seq2==2) and seq==5 then 
			b=true
		end
		if (seq2==2 or seq2==3 or seq2==4) and seq==6 then 
			b=true
		end
		if math.abs(seq2-seq)<=1 then
			b=true
		end
	end
	if c:GetControler()==tp and seq2<5 and c:IsLocation(LOCATION_SZONE) then
		if seq<5 and math.abs(seq2-seq)<=1 then
			b=true
		end
	end
	if c:GetControler()==1-tp and seq2<5 and c:IsLocation(LOCATION_MZONE) then
		if (seq2==0 or seq2==1 or seq2==2) and seq==6 then 
			b=true
		end
		if (seq2==2 or seq2==3 or seq2==4) and seq==5 then 
			b=true
		end
	end
	if seq2>=5 then
		if c:GetControler()==tp then
			if seq2==5 and (seq==0 or seq==1 or seq==2) then
				b=true
			end
			if seq2==6 and (seq==2 or seq==3 or seq==4) then
				b=true
			end
		end
		if c:GetControler()==1-tp then
			if seq2==5 and (seq==2 or seq==3 or seq==4) then
				b=true
			end
			if seq2==6 and (seq==0 or seq==1 or seq==2) then
				b=true
			end
		end
	end

	return b and c:IsCode(29010023) and sc:GetControler()==tp
end
function cm.eftg(e,c)
	local seq=c:GetSequence()
	return c:IsType(TYPE_EFFECT) and ((seq<5 and math.abs(e:GetHandler():GetSequence()-seq)<=1) or (Duel.IsExistingMatchingCard(cm.efilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_MZONE,1,nil,c,seq,e:GetHandlerPlayer())))
end
function cm.repfilter(c,e)
	return c:IsFaceup() and (c:IsCode(29010023) or c:IsCode(15000181))
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local tc=e:GetLabelObject()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(cm.repfilter,tp,LOCATION_ONFIELD,0,1,c,e) end
	if Duel.SelectEffectYesNo(tp,tc,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,cm.repfilter,tp,LOCATION_ONFIELD,0,1,1,c,e)
		Duel.SetTargetCard(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end
function cm.frcval(e,c,fp,rp,r)
	if c:GetAttack()>1000 or (bit.band(c:GetSummonType(),SUMMON_TYPE_NORMAL)==0 and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==0) then return 0xff00ff|0x600060 end
	return (0xff00ff-e:GetHandler():GetColumnZone(LOCATION_MZONE)&0x1f0000)|0x600060|0x00001f
end
function cm.cdcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,15000181)==0 and ((c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() and eg:FilterCount(Card.IsReason,nil,REASON_DESTROY)==eg:GetCount() and not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,c)) or (eg:IsContains(c) and c:IsReason(REASON_REPLACE)) or (c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() and eg:GetFirst():IsReason(REASON_DESTROY) and eg:GetCount()==1 and eg:GetFirst():GetPreviousControler()==1-tp and (Duel.GetAttacker():IsCode(29010023) or (Duel.GetAttackTarget() and Duel.GetAttackTarget():IsCode(29010023)))))
end
function cm.cdop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if Duel.GetFlagEffect(tp,15000181)~=0 then return end
	if c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() and eg:FilterCount(Card.IsReason,nil,REASON_DESTROY)==eg:GetCount() and not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,c) then
		Duel.SelectYesNo(tp,aux.Stringid(m,0))
	elseif eg:IsContains(c) and c:IsReason(REASON_REPLACE) then
		Duel.SelectYesNo(tp,aux.Stringid(m,1))
	elseif c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() and eg:GetFirst():IsReason(REASON_DESTROY) and eg:GetCount()==1 and eg:GetFirst():GetPreviousControler()==1-tp and (Duel.GetAttacker():IsCode(29010023) or (Duel.GetAttackTarget() and Duel.GetAttackTarget():IsCode(29010023))) then
		Duel.SelectYesNo(tp,aux.Stringid(m,2))
	end
	Duel.RegisterFlagEffect(tp,15000181,RESET_PHASE+PHASE_END,0,99)
end