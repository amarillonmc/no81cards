--龙门·特种干员-槐琥
function c79029122.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()  
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c79029122.drtg)
	e1:SetOperation(c79029122.dsop)
	e1:SetCountLimit(1,79029122)
	c:RegisterEffect(e1) 
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCost(c79029122.descost)
	e2:SetOperation(c79029122.desop)  
	e2:SetCountLimit(1,79029122999999)
	c:RegisterEffect(e2)  
end
function c79029122.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c79029122.dsop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_EXTRA,nil,ac)
	if g:GetCount()>0 then
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)
	e:GetHandler():CompleteProcedure()
end
end
function c79029122.cfilter(c)
	return c:IsFaceup() and c:IsType(0x58020C0) and c:IsAbleToRemoveAsCost()
end
function c79029122.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029122.cfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local tc=Duel.SelectMatchingCard(tp,c79029122.cfilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	local flag=0
	if tc:IsType(TYPE_RITUAL) then flag=bit.bor(flag,TYPE_RITUAL) end
	if tc:IsType(TYPE_FUSION) then flag=bit.bor(flag,TYPE_FUSION) end
	if tc:IsType(TYPE_SYNCHRO) then flag=bit.bor(flag,TYPE_SYNCHRO) end
	if tc:IsType(TYPE_XYZ) then flag=bit.bor(flag,TYPE_XYZ) end
	if tc:IsType(TYPE_PENDULUM) then flag=bit.bor(flag,TYPE_PENDULUM) end
	if tc:IsType(TYPE_LINK) then flag=bit.bor(flag,TYPE_LINK) end
	e:SetLabel(flag)
end
function c79029122.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:RegisterFlagEffect(79029122,RESET_PHASE+PHASE_END,0,1)
	local flag=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetTarget(c79029122.distg)
	e1:SetCondition(c79029122.discon)
	e1:SetLabel(flag)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79029122.distg(e,c)
	return c:IsType(e:GetLabel())
end
function c79029122.discon(e)
	return e:GetHandler():GetFlagEffect(79029122)~=0
end


















