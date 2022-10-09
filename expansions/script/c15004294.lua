local m=15004294
local cm=_G["c"..m]
cm.name="冲雷的刻证兽"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,15004294)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,15004295)
	e2:SetOperation(cm.rcop)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(15000780) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			res=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(cm.chop)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if #tg~=1 then return end
	local rc=tg:GetFirst()
	if rp==tp and re:GetHandler():IsSetCard(0xf3d) and Duel.GetFlagEffect(tp,15004294)==0 and re:IsActiveType(TYPE_MONSTER)
		and rc:IsLocation(LOCATION_GRAVE) and rc:IsRelateToEffect(re)
		and Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,15004294)
		local code=rc:GetCode()
		getmetatable(e:GetHandler()).announce_filter={0xf3d,OPCODE_ISSETCARD,TYPE_MONSTER,OPCODE_ISTYPE,OPCODE_AND,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
		local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
		Duel.Hint(HINT_CARD,0,ac)
		--change code
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(ac)
		e1:SetLabel(rc:GetFieldID())
		e1:SetReset(RESET_CHAIN)
		rc:RegisterEffect(e1)
		--change type
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetValue(TYPE_MONSTER)
		e2:SetLabel(rc:GetFieldID())
		e2:SetReset(RESET_CHAIN)
		rc:RegisterEffect(e2)
		--end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetOperation(cm.endop)
		e3:SetLabel(ev)
		e3:SetLabelObject(rc)
		e3:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e3,tp)
		if Duel.GetTurnPlayer()==tp then
			Duel.RegisterFlagEffect(tp,15004294,RESET_PHASE+PHASE_END,0,2)
		end
		if Duel.GetTurnPlayer()~=tp then
			Duel.RegisterFlagEffect(tp,15004294,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function cm.endop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	if ev~=e:GetLabel() then return end
	local e1=0
	if rc:IsHasEffect(EFFECT_CHANGE_CODE)~=0 then
		for _,i in ipairs{rc:IsHasEffect(EFFECT_CHANGE_CODE)} do
			if i:GetLabel() and i:GetLabel()==rc:GetFieldID() then e1=i end
		end
	end
	local e2=0
	if rc:IsHasEffect(EFFECT_CHANGE_TYPE)~=0 then
		for _,i in ipairs{rc:IsHasEffect(EFFECT_CHANGE_TYPE)} do
			if i:GetLabel() and i:GetLabel()==rc:GetFieldID() then e2=i end
		end
	end
	if e1~=0 then e1:Reset() end
	if e2~=0 then e2:Reset() end
	e:Reset()
end