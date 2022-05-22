local m=53707019
local cm=_G["c"..m]
cm.name="清响分歧线 游身潜如芳"
function cm.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_PLANT),2,3,function(g,lc)return g:IsExists(Card.IsLinkType,1,nil,TYPE_SYNCHRO)end)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.tgcost)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+50)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 and eg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK)end)
	e2:SetOperation(cm.plop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(LOCATION_DECK)
	c:RegisterEffect(e3)
	if not cm.Selfree_Likeour then
		cm.Selfree_Likeour=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.count)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(cm.reset)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_TO_DECK)
		ge3:SetOperation(cm.tdeg)
		Duel.RegisterEffect(ge3,0)
	end
end
function cm.count(e,tp,eg,ep,ev,re,r,rp)
	cm.chain=true
end
function cm.tdeg(e,tp,eg,ep,ev,re,r,rp)
	if cm.chain==true then
		local g=Group.CreateGroup()
		if cm[0] then g=cm[0] end
		g:Merge(eg)
		g:KeepAlive()
		cm[0]=g
	end
	if cm.chain==false then
		Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev)
	end
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	cm.chain=false
	if not cm[0] then return end
	Duel.RaiseEvent(cm[0],EVENT_CUSTOM+m,re,r,rp,ep,ev)
	cm[0]=nil
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function cm.rmfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function cm.fselect(g,tp)
	return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,#g,g)
end
function cm.tgfilter(c,tp)
	return c:IsSetCard(0x3537) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_DECK,0,nil)
	local p=0
	if tp==1 then p=1 end
	local ct,zone=0,e:GetHandler():GetLinkedZone(p)
	if zone==0 then return false end
	for i=0,4 do
		if bit.extract(zone,i)~=0 and Duel.CheckLocation(tp,LOCATION_MZONE,i) then ct=ct+1 end
		if bit.extract(zone,i+16)~=0 and Duel.CheckLocation(1-tp,LOCATION_MZONE,i) then ct=ct+1 end
	end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return g:CheckSubGroup(cm.fselect,1,ct,tp)
	end
	SNNM.UpConfirm()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,cm.fselect,false,1,ct,tp)
	Duel.ConfirmCards(1-tp,rg)
	local rct=Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
	e:SetLabel(rct)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,rct,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,ct,ct,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.plop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()<2 then return end
	local ct=eg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	while ct>0 do
		local tc=Duel.GetFieldGroup(tp,LOCATION_DECK,0):GetMinGroup(Card.GetSequence):GetFirst()
		Duel.MoveSequence(tc,0)
		if tc:IsFaceup() then tc:ReverseInDeck() end
		ct=ct-1
		if ct>0 and not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then ct=0 end
	end
end
