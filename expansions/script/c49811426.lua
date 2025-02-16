--仪水镜的遗托邦
local cm,m=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x491)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(cm.acop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(aux.chainreg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_FZONE)
	e5:SetOperation(cm.acop2)
	c:RegisterEffect(e5)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
	e5:SetLabelObject(g)
	--top
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49811426,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCost(cm.thcost)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	--summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(49811426,1))
	e6:SetCategory(CATEGORY_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCost(cm.thcost2)
	e6:SetTarget(cm.thtg2)
	e6:SetOperation(cm.thop2)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		local _ConfirmCards=Duel.ConfirmCards
		local _ConfirmDecktop=Duel.ConfirmDecktop
		local _SortDecktop=Duel.SortDecktop
		function Duel.ConfirmCards(p,g)
			Duel.RaiseEvent(g,EVENT_CUSTOM+m,e2,0,0,0,0)
			return _ConfirmCards(p,g)
		end
		function Duel.ConfirmDecktop(p,ct)
			Duel.RaiseEvent(Duel.GetDecktopGroup(p,ct),EVENT_CUSTOM+m,e2,0,0,0,0)
			return _ConfirmDecktop(p,ct)
		end
		function Duel.SortDecktop(sp,p,ct)
			Duel.RaiseEvent(Duel.GetDecktopGroup(p,ct),EVENT_CUSTOM+m,e2,0,0,0,0)
			return _SortDecktop(sp,p,ct)
		end
	end
end
function cm.thfilter(c,tp)
	return c:IsSetCard(0x3a) and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,c)
end
function cm.tgfilter(c)
	return c:IsSetCard(0x3a) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(1)>0 and eg and eg:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK)>0 then
		e:GetLabelObject():Merge(eg:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK))
	end
end
function cm.acop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(1)
	if #e:GetLabelObject()>0 then
		if re:GetHandler():GetCode()~=49811426 then
			e:GetHandler():AddCounter(0x491,#e:GetLabelObject(),true)
		end
		e:GetLabelObject():Clear()
	end
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x491,1,REASON_COST) end
	local t={}
	for i=1,100 do
		if e:GetHandler():IsCanRemoveCounter(tp,0x491,i,REASON_COST) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,i,nil) then t[#t+1]=i end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(94599451,1))
	local ct=Duel.AnnounceNumber(tp,table.unpack(t))
	e:GetHandler():RemoveCounter(tp,0x491,ct,REASON_COST)
	e:SetLabel(ct)
end
function cm.filter(c)
	return c:IsSetCard(0x3a)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.sumfilter(c,ct)
	return c:IsSummonable(true,nil) and c:IsSetCard(0x3a) and c:IsLevel(ct)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(16693254,1))
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,e:GetLabel(),e:GetLabel(),nil)
	if #g>0 then
		for tc in aux.Next(g) do Duel.MoveSequence(tc,SEQ_DECKTOP) end
		Duel.ConfirmDecktop(tp,#g)
		Duel.SortDecktop(tp,tp,e:GetLabel())
	end
end
function cm.thcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local t={}
	for i=1,100 do
		if e:GetHandler():IsCanRemoveCounter(tp,0x491,i,REASON_COST) and Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,i) then t[#t+1]=i end
	end
	if chk==0 then return #t>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(94599451,1))
	local ct=Duel.AnnounceNumber(tp,table.unpack(t))
	e:GetHandler():RemoveCounter(tp,0x491,ct,REASON_COST)
	e:SetLabel(ct)
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e:GetLabel())
	if sg:GetCount()>0 then
		Duel.Summon(tp,sg:GetFirst(),true,nil)
	end
end