--风起之时
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65812000)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--移动
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.condition)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end

function s.filter(c)
	return (aux.IsCodeListed(c,65812000) or c:IsCode(65812000)) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	e:SetLabel(0)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLocation(LOCATION_ONFIELD) and (c:GetSequence()~=c:GetPreviousSequence() or c:GetLocation()~=c:GetPreviousLocation()) then e:SetLabel(114514) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if e:GetLabel()==114514 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsPlayerCanDraw(tp,1)
			and e:GetLabel()==114514
			and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

function s.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLocation(LOCATION_ONFIELD)
		and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=c:GetControler() or c:GetPreviousLocation()~=c:GetLocation())
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	e3:SetOperation(s.negop)
	Duel.RegisterEffect(e3,tp)
end
function s.filter1(c,e)
	local tp=c:GetControler()
	local seq=c:GetSequence()
	if seq>4 or c:IsLocation(LOCATION_PZONE) then return false end
	return (c:IsLocation(LOCATION_MZONE) and ((seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)) or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))) or c:IsLocation(LOCATION_SZONE) and ((seq>0 and Duel.CheckLocation(tp,LOCATION_SZONE,seq-1)) or (seq<4 and Duel.CheckLocation(tp,LOCATION_SZONE,seq+1)))) and not c:IsImmuneToEffect(e)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		e:Reset()
		Duel.Hint(HINT_CARD,0,id)
		local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e)
		local tc=g:GetFirst()
		local seq=tc:GetSequence()
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

