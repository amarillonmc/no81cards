--佐臣之弈姬 - 巡相
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(TIMING_MAIN_END)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--effect target protection
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.efftg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function s.spfilter(c)
	return c:IsSetCard(0x9f6) and c:IsType(TYPE_MONSTER) and not c:IsLevel(3) and c:IsAbleToHand()
end
function s.seqfilter(c,seq)
	return c:GetSequence()==seq
end
function s.canswap(c,tp)
	local seq=c:GetSequence()
	if seq>4 then return false end
	if seq>0 and Duel.GetMatchingGroupCount(s.seqfilter,tp,LOCATION_MZONE,0,nil,seq-1)>0 then return true end
	if seq<4 and Duel.GetMatchingGroupCount(s.seqfilter,tp,LOCATION_MZONE,0,nil,seq+1)>0 then return true end
	return false
end
function s.canmove(c,tp)
	local seq=c:GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=s.canmove(c,tp)
	local b3=s.canswap(c,tp)
	if chk==0 then return b1 or b2 or b3 end
	local op=0
	if b1 and b2 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2),aux.Stringid(id,3))
	elseif b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,3))
		if op==1 then op=2 end
	elseif b2 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))+1
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,3))+2
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==1 then
		if not (c:IsRelateToEffect(e) and c:IsControler(tp)) then return end
		local seq=c:GetSequence()
		if seq>4 then return end
		if (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
			or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) then
			local flag=0
			if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=bit.replace(flag,0x1,seq-1) end
			if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=bit.replace(flag,0x1,seq+1) end
			flag=bit.bxor(flag,0xff)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
			local nseq=0
			if s==1 then nseq=0
			elseif s==2 then nseq=1
			elseif s==4 then nseq=2
			elseif s==8 then nseq=3
			else nseq=4 end
			Duel.MoveSequence(c,nseq)
		end
	elseif op==2 then
		if not (c:IsRelateToEffect(e) and c:IsControler(tp)) then return end
		local seq=c:GetSequence()
		if seq>4 then return end
		local g=Group.CreateGroup()
		if seq>0 then
			local tc=Duel.GetMatchingGroup(s.seqfilter,tp,LOCATION_MZONE,0,nil,seq-1):GetFirst()
			if tc then g:AddCard(tc) end
		end
		if seq<4 then
			local tc=Duel.GetMatchingGroup(s.seqfilter,tp,LOCATION_MZONE,0,nil,seq+1):GetFirst()
			if tc then g:AddCard(tc) end
		end
		if g:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc then
			Duel.SwapSequence(c,tc)
		end
	end
end
function s.efftg(e,c)
	local tp=e:GetHandlerPlayer()
	local ec=e:GetHandler()
	if not (c:IsSetCard(0x9f6) and c:IsFaceup() and c~=ec) then return false end
	local eseq=ec:GetSequence()
	local cseq=c:GetSequence()
	if eseq>4 or cseq>4 then return false end
	return math.abs(eseq-cseq)==1 and c:IsControler(tp)
end
