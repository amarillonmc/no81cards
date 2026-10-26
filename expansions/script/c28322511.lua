--伊尔米涅特音乐会
function c28322511.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,28322511+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c28322511.cost)
	e1:SetTarget(c28322511.target)
	e1:SetOperation(c28322511.activate)
	c:RegisterEffect(e1)
	--illumination maho
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CUSTOM+28322511)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetOperation(c28322511.repop)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(28322511)
	e0:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e0)
	--global
	if not ILLUMINA_REPLACE_GLOBAL then
		ILLUMINA_REPLACE_GLOBAL = true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EFFECT_SEND_REPLACE)
		ge1:SetTarget(c28322511.reptg)
		ge1:SetValue(aux.FALSE)
		Duel.RegisterEffect(ge1,0)
	end
end
function c28322511.chkfilter(c)
	return c:IsSetCard(0x284) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c28322511.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28322511.chkfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c28322511.chkfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c28322511.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c28322511.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and Duel.GetControl(tc,tp,PHASE_END,1)~=0 and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetDescription(aux.Stringid(28322511,2))
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		tc:RegisterEffect(e2)
	end
end
function c28322511.repfilter(c)
	return c:IsHasEffect(28322511) and c:GetDestination()==LOCATION_DECK --and c:IsLocation(LOCATION_GRAVE)
end
function c28322511.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=eg:Filter(c28322511.repfilter,nil)
	if chk==0 then return #tg>0 and bit.band(r,REASON_EFFECT)~=0 and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x284) end
	for p in aux.TurnPlayers() do
		local g=tg:Filter(Card.IsControler,nil,p)
		local ops,t={aux.Stringid(28384553,3)},{}
		for tc in aux.Next(g) do table.insert(ops,aux.Stringid(tc:GetOriginalCode(),0)) table.insert(t,tc) end
		if #g>1 then
			while #t>1 do
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_RESOLVEEFFECT)
				local sel=Duel.SelectOption(p,table.unpack(ops))
				if sel~=0 then
					local tc=t[sel]
					Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+28322511,re,REASON_EFFECT,p,p,0)
					--tc.replace_operation(e,p,eg,ep,ev,re,r,rp)
					table.remove(ops,sel+1)
					table.remove(t,sel)
				else break end
			end
		end
		for _,tc in ipairs(t) do Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+28322511,re,REASON_EFFECT,p,p,0) end
	end
	return false
end
function c28322511.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,28322511)
	--[[c28322511.target(e,tp,eg,ep,ev,re,r,rp,0)
	c28322511.activate(e,tp,eg,ep,ev,re,r,rp)]]
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local tc=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	if Duel.GetControl(tc,tp,PHASE_END,1)~=0 and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetDescription(aux.Stringid(28322511,2))
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		tc:RegisterEffect(e2)
	end
end
--c28322511.replace_operation=c28322511.repop
