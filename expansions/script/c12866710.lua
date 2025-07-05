--绝对支配
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,12866600)
	c:SetUniqueOnField(1,0,id)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Announce
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ANNOUNCE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(s.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--tograve&specialsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,4))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.tgcon)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(s.eftg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_MONSTER,OPCODE_ISTYPE}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM) 
	local c=e:GetHandler()
	  local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(s.negcon)
	e3:SetLabel(ac)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetOperation(s.negop)
	Duel.RegisterEffect(e3,tp)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	return   re:GetHandler():IsDestructable() and re:GetHandler():IsCode(code)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_CARD,0,12866600)
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
end
function s.eftg(e,c)
	return c:IsCode(12866600)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER) and ((re:GetHandler():IsAttribute(ATTRIBUTE_DARK) and Duel.GetFlagEffect(tp,id)==0)
		or (re:GetHandler():IsAttribute(ATTRIBUTE_EARTH) and Duel.GetFlagEffect(tp,id+o)==0)
		or (re:GetHandler():IsAttribute(ATTRIBUTE_WATER) and Duel.GetFlagEffect(tp,id+o*2)==0) 
		or (re:GetHandler():IsAttribute(ATTRIBUTE_FIRE) and Duel.GetFlagEffect(tp,id+o*3)==0) 
		or (re:GetHandler():IsAttribute(ATTRIBUTE_WIND) and Duel.GetFlagEffect(tp,id+o*4)==0))
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) then return end
	local proc=rc:IsCode(12866705,12866890) and c:IsCode(12866600)
	local b1=rc:IsAbleToGrave() and not rc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
	local b2=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	and (rc:IsCanBeSpecialSummoned(e,0,tp,false,false)) or rc:IsCanBeSpecialSummoned(e,0,tp,proc,proc))
	if chk==0 then return b1 or b2 end
	if re:GetHandler():IsAttribute(ATTRIBUTE_DARK) then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	elseif re:GetHandler():IsAttribute(ATTRIBUTE_EARTH) then
		Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	elseif re:GetHandler():IsAttribute(ATTRIBUTE_WATER) then
		Duel.RegisterFlagEffect(tp,id+o*2,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	elseif re:GetHandler():IsAttribute(ATTRIBUTE_FIRE) then
		Duel.RegisterFlagEffect(tp,id+o*3,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	elseif re:GetHandler():IsAttribute(ATTRIBUTE_WIND) then
		Duel.RegisterFlagEffect(tp,id+o*4,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
	Duel.SetTargetCard(rc)
	if rc:IsLocation(LOCATION_GRAVE) then
	e:SetCategory(CATEGORY_GRAVE_SPSUMMON+CATEGORY_LEAVE_GRAVE)
	end
	if rc:IsLocation(LOCATION_DECK) then
	e:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		local tc=Duel.GetFirstTarget()
		local proc=tc:IsCode(12866705,12866890) and c:IsCode(12866600)
		local b1=tc:IsAbleToGrave() and not tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or tc:IsCanBeSpecialSummoned(e,0,tp,proc,proc)) and aux.NecroValleyFilter()(tc) 
		local off=1
		local ops={}
		local opval={}
		if b1 then
			ops[off]=1191
			opval[off]=0
			off=off+1
		end
		if b2 then
			ops[off]=1152
			opval[off]=1
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))+1
		local sel=opval[op]
		if sel==0 then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		elseif sel==1 then
			Duel.SpecialSummon(tc,0,tp,tp,proc,proc,POS_FACEUP)
			if proc then tc:CompleteProcedure() end
		end
	end
end