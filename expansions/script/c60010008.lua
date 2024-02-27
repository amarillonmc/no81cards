--塔斯汀娜 传说天之长岁
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	MTC.LHini(c)
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
end
function cm.tdfilter(c)
	return c:IsSetCard(0x630) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local num=Duel.GetFlagEffect(tp,60010002)
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<num then return false end
		local g=Duel.GetDecktopGroup(tp,num)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
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