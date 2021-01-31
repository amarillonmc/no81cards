--方舟之骑士·衾翼
function c29065596.initial_effect(c)
	c:EnableCounterPermit(0x87ae)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065596,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29065596)
	e1:SetCost(c29065596.spcost)
	e1:SetTarget(c29065596.sptg)
	e1:SetOperation(c29065596.spop)
	c:RegisterEffect(e1)	
	--ANNOUNCE_CARD
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ANNOUNCE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,19065596)
	e2:SetTarget(c29065596.cttg)
	e2:SetOperation(c29065596.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	c29065596.summon_effect=e2
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29065596,3))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,09065582)
	e4:SetCondition(c29065596.thcon)
	e4:SetTarget(c29065596.thtg)
	e4:SetOperation(c29065596.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e5)
end
function c29065596.rlfil(c)
	return c:IsReleasable() and (c:IsSetCard(0xa900) or c:IsSetCard(0x87af))
end
function c29065596.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x87ae,1,REASON_COST) or Duel.IsPlayerAffectedByEffect(tp,29065592) or Duel.IsExistingMatchingCard(c29065596.rlfil,tp,LOCATION_MZONE,0,1,nil) end
	if Duel.IsExistingMatchingCard(c29065596.rlfil,tp,LOCATION_MZONE,0,1,nil) and   (not (Duel.IsCanRemoveCounter(tp,1,0,0x87ae,1,REASON_COST) or Duel.IsPlayerAffectedByEffect(tp,29065592)) or Duel.SelectYesNo(tp,aux.Stringid(29065596,0))) then
	local rg=Duel.SelectMatchingCard(tp,c29065596.rlfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(rg,REASON_COST)
	e:SetLabel(1)
	else
	if Duel.IsPlayerAffectedByEffect(tp,29065592) and (not Duel.IsCanRemoveCounter(tp,1,0,0x87ae,1,REASON_COST) or Duel.SelectYesNo(tp,aux.Stringid(29065592,0))) then
	Duel.RegisterFlagEffect(tp,29065592,RESET_PHASE+PHASE_END,0,1)
	else
	Duel.RemoveCounter(tp,1,0,0x87ae,1,REASON_COST)
	end
   end
end
function c29065596.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c29065596.xthfilter(c)
	return c:IsSetCard(0x87af) and c:IsCanAddCounter(0x87ae,1)
end
function c29065596.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	if e:GetLabel()==1 and Duel.SelectYesNo(tp,aux.Stringid(29065596,1)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c29065596.xthfilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	local n=1 
	if Duel.IsPlayerAffectedByEffect(tp,29065580) then
	n=n+1
	end
	tc:AddCounter(0x87ae,n)
	end
	end
end
function c29065596.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c29065596.thfilter(c)
	return c:IsSetCard(0x87af) and c:IsCanAddCounter(0x87ae,1)
end
function c29065596.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065596.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c29065596.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c29065596.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	local n=1 
	if Duel.IsPlayerAffectedByEffect(tp,29065580) then
	n=n+1
	end
	tc:AddCounter(0x87ae,n)
end
function c29065596.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if chk==0 then return dcount~=0 and Duel.IsPlayerCanDraw(tp,1) end
end
function c29065596.refilter(c)
	return c:IsSetCard(0x87af) and c:GetBaseAttack()>0
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
	if not xc:IsCode(ac) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(29065596,2)) then
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT,nil)
	Duel.Draw(tp,1,REASON_EFFECT)
	elseif xc:IsCode(ac) and Duel.SelectYesNo(tp,aux.Stringid(29065596,3)) then
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










