--里魂的显化
function c16108100.initial_effect(c)
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
	e1:SetCondition(c16108100.actcon)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16108100,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,98500099)
	e2:SetTarget(c16108100.tstg)
	e2:SetOperation(c16108100.tsop)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16108100,1))
	e3:SetCategory(CATEGORY_ANNOUNCE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,98500100)
	e3:SetTarget(c16108100.target)
	e3:SetOperation(c16108100.activate)
	c:RegisterEffect(e3) 
end
function c16108100.afilter(c)
	return c:IsPosition(POS_FACEUP)
end
function c16108100.afilter2(c)
	return c:IsPosition(POS_FACEDOWN)
end
function c16108100.actcon(e)
	return Duel.IsExistingMatchingCard(c16108100.afilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and not Duel.IsExistingMatchingCard(c16108100.afilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c16108100.spfilter(c,e,tp)
	return c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c16108100.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c16108100.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c16108100.tsop(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),2)
	if ft<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16108100.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
		   if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) then
				Duel.ConfirmCards(1-tp,tc)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1,true)
				local fid=e:GetHandler():GetFieldID()
				tc:RegisterFlagEffect(16108100,RESET_EVENT+RESETS_STANDARD,0,1,fid)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_END)
				e2:SetCountLimit(1)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetLabel(fid)
				e2:SetLabelObject(tc)
				e2:SetCondition(c16108100.tgcon)
				e2:SetOperation(c16108100.tgop)
				Duel.RegisterEffect(e2,tp)
			end
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
		Duel.BreakEffect()
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end
function c16108100.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(16108100)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c16108100.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_EFFECT)
end
function c16108100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local code=e:GetHandler():GetCode()
	--c:IsSetCard(0x51) and not c:IsCode(code)
	getmetatable(e:GetHandler()).announce_filter={0x985,OPCODE_ISSETCARD,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c16108100.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	--effect gain
	local cp={}
	local func=Card.RegisterEffect
	Card.RegisterEffect=function(tc,e,f)
		if e:GetType()&EFFECT_TYPE_FLIP~=0 or (e:GetCode()&EVENT_FLIP~=0 and (e:GetType()&EFFECT_TYPE_QUICK_O~=0 or e:GetType()&EFFECT_TYPE_TRIGGER_O~=0) and e:GetType()&EFFECT_TYPE_SINGLE~=0 ) then
			table.insert(cp,e:Clone())
		end
		return func(tc,e,f)
	end
	Duel.CreateToken(tp,ac)
	for i,v in ipairs(cp) do
		local pro=v:GetProperty()
		if pro&EFFECT_FLAG_DELAY~=0 then
			v:SetProperty(pro-EFFECT_FLAG_DELAY)
		end
		v:SetCode(EVENT_FREE_CHAIN)
		v:SetType(EFFECT_TYPE_QUICK_O)
		v:SetRange(LOCATION_MZONE)
		v:SetCountLimit(1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetLabel(ac)
		e1:SetTarget(c16108100.eftg)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(v)
		Duel.RegisterEffect(e1,tp)
	end
	Card.RegisterEffect=func
end
function c16108100.eftg(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end
