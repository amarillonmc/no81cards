local m=33712007
local cm=_G["c"..m]
cm.name="逆天而为？"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if chk==0 then return g:FilterCount(Card.IsAbleToHand,nil)>=2 end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local op_deck=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if #op_deck<2 then return end
	if Duel.IsChainDisablable(0) and e:GetHandler():IsSSetable() and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
		Duel.SetLP(1-tp,math.ceil(Duel.GetLP(tp)/2))
		Duel.NegateEffect(0)
		Duel.SSet(1-tp,e:GetHandler(),1-tp)
		e:GetHandler():CancelToGrave()
		Duel.MoveToField(e:GetHandler(),1-tp,1-tp,LOCATION_SZONE,POS_FACEDOWN,false)
		Duel.RaiseEvent(Group.FromCards(e:GetHandler()),EVENT_SSET,e,REASON_EFFECT,1-tp,1-tp,0)
		return
	end
	local max=20
	if #op_deck<max then max=#op_deck end
	local p=1-tp
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then p=tp end
	local t={}
	local i=2
	for i=2,max do t[i-1]=i end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_NUMBER)
	local num=Duel.AnnounceNumber(p,table.unpack(t))
	Duel.ConfirmDecktop(1-tp,num)
	local g=Duel.GetDecktopGroup(1-tp,num)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local sg=g:Select(1-tp,math.ceil(num/2),math.ceil(num/2),nil)
	if sg and Duel.SendtoHand(sg,1-tp,REASON_EFFECT)>0 then
		Duel.ConfirmCards(tp,sg)
		g:Sub(sg)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end