--风起 浪滔天
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65812000)
	--特招
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(s.tftg)
	e1:SetOperation(s.tfop)
	c:RegisterEffect(e1)
	if not PNFL_LOCATION_CHECK then
		PNFL_LOCATION_CHECK=true
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge6:SetCode(EVENT_MOVE)
		ge6:SetOperation(s.checkop6)
		Duel.RegisterEffect(ge6,true)
	end
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.actarget)
	e4:SetOperation(s.negop)
	c:RegisterEffect(e4)
end


function s.checkop6(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local tc=eg:GetFirst()
		while tc do
			if s.locfilter(tc,p) then
				tc:RegisterFlagEffect(65812010,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65812010,3))
			end
			tc=eg:GetNext()
		end
	end
end
function s.locfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLocation(LOCATION_ONFIELD)
		and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=c:GetControler() or c:GetPreviousLocation()~=c:GetLocation()) 
		and c:GetFlagEffect(65812010)==0
end


function s.shfilter(c)
	return c:GetFlagEffect(65812010)>0
end
function s.tffilter(c,e,tp)
	return c:IsAbleToHand() and c:IsFaceupEx() and (c:IsControler(tp) and (aux.IsCodeListed(c,65812000) or c:IsCode(65812000)) or c:IsControler(1-tp) and Duel.IsExistingMatchingCard(s.shfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp)) and Duel.GetMZoneCount(tp,c)>0
end
function s.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,e,tp) and Duel.GetFlagEffect(tp,id)==0 end
	local ph=Duel.GetCurrentPhase()
	if ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then ph=PHASE_BATTLE end
	Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+ph,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,s.tffilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,e,tp):GetFirst()
	if and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND+LOCATION_EXTRA) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end


function s.cfilter(c,se)
	if not (se==nil or c:GetReasonEffect()~=se) then return false end
	local code1,code2=c:GetPreviousCodeOnField()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and (code1==65812000 or code2==65812000)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,se) and not eg:IsContains(e:GetHandler())
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.GetFlagEffect(tp,id+1)==0 end
	local ph=Duel.GetCurrentPhase()
	if ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then ph=PHASE_BATTLE end
	Duel.RegisterFlagEffect(tp,id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+ph,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end


function s.cfilter1(c,e)
	local tp=c:GetControler()
	local seq=c:GetSequence()
	if seq>4 or c:IsLocation(LOCATION_PZONE) then return false end
	return (c:IsLocation(LOCATION_MZONE) and ((seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)) or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))) or c:IsLocation(LOCATION_SZONE) and ((seq>0 and Duel.CheckLocation(tp,LOCATION_SZONE,seq-1)) or (seq<4 and Duel.CheckLocation(tp,LOCATION_SZONE,seq+1)))) and not c:IsImmuneToEffect(e)
end
function s.actarget(e,te)
	local c=e:GetHandler()
	local tc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT):GetHandler()
	local g=c:GetColumnGroup():Filter(s.cfilter1,nil,e)
	if not c or not g or not aux.IsInGroup(tc,g) then return end
	e:SetLabelObject(tc)
	return true
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local tp1=tc:GetControler()
	local seq=tc:GetSequence()
	if (tc:IsLocation(LOCATION_MZONE) and ((seq>0 and Duel.CheckLocation(tp1,LOCATION_MZONE,seq-1)) or (seq<4 and Duel.CheckLocation(tp1,LOCATION_MZONE,seq+1))) or tc:IsLocation(LOCATION_SZONE) and ((seq>0 and Duel.CheckLocation(tp1,LOCATION_SZONE,seq-1)) or (seq<4 and Duel.CheckLocation(tp1,LOCATION_SZONE,seq+1)))) and not tc:IsImmuneToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		e:Reset()
		Duel.Hint(HINT_CARD,0,id)
		if seq>4 then return end
		local flag=0
		local p=tc:GetControler()
		if tc:IsLocation(LOCATION_MZONE) then
			if seq>0 and Duel.CheckLocation(p,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
			if seq<4 and Duel.CheckLocation(p,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
		end
		if tc:IsLocation(LOCATION_SZONE) then
			if seq>0 and Duel.CheckLocation(p,LOCATION_SZONE,seq-1) then flag=flag|(1<<(seq+7)) end
			if seq<4 and Duel.CheckLocation(p,LOCATION_SZONE,seq+1) then flag=flag|(1<<(seq+9)) end
		end
		if flag==0 then return end
		if p~=tp then flag=flag<<16 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,~flag)
		local a=s
		if p~=tp then s=s>>16 end
		if tc:IsLocation(LOCATION_SZONE) then s=s>>8 end
		local nseq=math.log(s,2)
		Duel.MoveSequence(tc,nseq)
	end
end