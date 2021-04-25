--方舟之骑士·衾翼
function c29065596.initial_effect(c)
	c:EnableCounterPermit(0x11ae)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29065596)
	e1:SetCondition(c29065596.spcon)
	e1:SetOperation(c29065596.spop)
	c:RegisterEffect(e1)  
	--ANNOUNCE_CARD
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ANNOUNCE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,29000019)
	e2:SetTarget(c29065596.cttg)
	e2:SetOperation(c29065596.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	c29065596.summon_effect=e2
end
function c29065596.rlfil(c)
	return c:IsReleasable() and (c:IsSetCard(0xa900) or c:IsSetCard(0x87af)) and Duel.GetMZoneCount(tp,c)>0
end
function c29065596.spcon(e,c)
	if c==nil then return true end
	return Duel.IsCanRemoveCounter(tp,1,0,0x11ae,1,REASON_COST) or Duel.IsExistingMatchingCard(c29065596.rlfil,tp,LOCATION_MZONE,0,1,nil)
end
function c29065596.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.IsCanRemoveCounter(tp,1,0,0x11ae,1,REASON_COST) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(29065596,0)) then
	Duel.RemoveCounter(tp,1,0,0x11ae,1,REASON_COST)
	else
	rg=Duel.SelectMatchingCard(tp,c29065596.rlfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(rg,REASON_COST)
	end
end
function c29065596.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if chk==0 then return dcount~=0 and Duel.IsPlayerCanDraw(tp,1) end
end
function c29065596.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local ag=Group.CreateGroup()
	local codes={}
	for c in aux.Next(g) do
		local code=c:GetCode()
		if not ag:IsExists(Card.IsCode,1,nil,code) then
			ag:AddCard(c)
			table.insert(codes,code)
		end
	end
	table.sort(codes)
	--c:IsCode(codes[1])
	local afilter={codes[1],OPCODE_ISCODE}
	if #codes>1 then
		--or ... or c:IsCode(codes[i])
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local xc=Duel.GetDecktopGroup(tp,1):GetFirst() 
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.ConfirmCards(0,xc)
	if xc:IsCode(ac) and Duel.SelectYesNo(tp,aux.Stringid(29065596,3)) then
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x87af))
	e1:SetValue(0xa900)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end










