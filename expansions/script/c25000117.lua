local m=25000117
local cm=_G["c"..m]
cm.name="百万巨神 大欧"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and (re:GetActiveType()==TYPE_SPELL or re:GetActiveType()==TYPE_TRAP)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local t={1}
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac1=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac1)
	if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,ac1,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
		local ac2=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
		t={ac2}
		if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,ac1,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,ac2,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
			local ac3=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
			table.insert(t,ac3)
		end
	end
	e:SetLabel(table.unpack(t))
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local ct=math.min(6,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0))
	local tb={}
	for i=1,ct do tb[i]=i end
	local ac=1
	if ct>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		ac=Duel.AnnounceNumber(tp,table.unpack(tb))
	end
	for i=1,ac do
		local dc=Duel.GetFieldGroup(tp,LOCATION_DECK,0):GetMinGroup(Card.GetSequence):GetFirst()
		Duel.MoveSequence(dc,0)
	end
	Duel.ConfirmDecktop(tp,ac)
	local og=Duel.GetDecktopGroup(tp,ac)
	local t={e:GetLabel()}
	table.insert(t,Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM))
	local oct=0
	for tc in aux.Next(og) do if SNNM.IsInTable(tc:GetCode(),t) then oct=oct+1 end end
	Duel.SortDecktop(tp,tp,ac)
	for i=1,ac do
		local dg=Duel.GetDecktopGroup(tp,1)
		Duel.MoveSequence(dg:GetFirst(),1)
	end
	if oct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,oct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
