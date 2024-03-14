--塔斯汀娜 传说天之长岁
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--MTC.LHini(c)
	MTC.LHSpS(c,3)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	if not cst==true then
		cst=true
		--local tp=c:GetOwner()
		--spsm
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e1:SetCondition(cm.LHcon1)
		e1:SetOperation(cm.LHop1)
		Duel.RegisterEffect(e1,0)
		--spsm
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e1:SetCondition(cm.LHcon1)
		e1:SetOperation(cm.LHop1)
		Duel.RegisterEffect(e1,0)
	end
end
function cm.tdfilter(c)
	return c:IsSetCard(0x630) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	--local tp=e:GetHandlerPlayer()
	if chk==0 then
		local num=Duel.GetFlagEffect(tp,60010002)
		--Debug.Message(num)
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<num then return false end
		local g=Duel.GetDecktopGroup(tp,num)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandlerPlayer()
	local num=Duel.GetFlagEffect(p,60010002)
	Duel.ConfirmDecktop(p,num)
	local g=Duel.GetDecktopGroup(p,num)
	if not g or #g<num then return end
	g=g:Filter(cm.tdfilter,nil)
	local ct=num
	if #g>0 and Duel.SelectYesNo(p,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:Select(p,1,1,nil)
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-p,sg)
		Duel.ShuffleHand(p)
		ct=ct-1
	end
	Duel.SortDecktop(p,p,ct)
	for i=1,ct do
		local mg=Duel.GetDecktopGroup(p,1)
		Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
	end
end
function cm.LHfil1(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSetCard(0x630)
end
function cm.LHcon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=eg:GetFirst():GetOwner()
	return eg:IsExists(cm.LHfil1,1,nil,tp)
end
function cm.LHop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x630) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),60010002,RESET_PHASE+PHASE_END,0,1)
			Duel.RaiseEvent(c,EVENT_CUSTOM+60010002,nil,0,tc:GetSummonPlayer(),tc:GetSummonPlayer(),0)
		end
		tc=eg:GetNext()
	end
end