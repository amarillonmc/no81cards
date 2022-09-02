--绘舞华·绯梦之樱术使 RK4
--21.06.22
local m=11451579
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,11451582)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetValue(11451480)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(cm.check)
		Duel.RegisterEffect(ge1,0)
	end
end
cm.rkup={11451580}
cm.rkdn={11451578}
function cm.check(e,tp,eg,ep,ev,re,r,rp)
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	for tc in aux.Next(eg) do
		local te=tc:GetReasonEffect()
		if te and (te:GetHandler():IsSetCard(0x97f) or te:GetValue()==11451480) and tc:IsReason(REASON_EFFECT) then return end
		if tc:GetReasonPlayer()==0 and tc:GetControler()==0 then
			g1:AddCard(tc)
		elseif tc:GetReasonPlayer()==1 and tc:GetControler()==1 then
			g2:AddCard(tc)
		end
	end
	if #g1>0 then Duel.RaiseEvent(g1,EVENT_CUSTOM+m,re,r,rp,0,0) end
	if #g2>0 then Duel.RaiseEvent(g2,EVENT_CUSTOM+m,re,r,rp,1,0) end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=0
	--local tg=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsCanOverlay,nil)
	local tg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND):Filter(Card.IsCanOverlay,nil)
	local b1=e:GetHandler():IsType(TYPE_XYZ) and #tg>0 and Duel.IsPlayerCanDraw(tp)
	local b2=e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.IsPlayerCanDraw(1-tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))+1
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,3))+2
	end
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif op==2 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
	end
	e:SetLabel(op)
end
function cm.matfilter(c,e)
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		--local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(cm.matfilter,nil,e)
		local tg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND):Filter(cm.matfilter,nil,e)
		if #tg==0 or not c:IsRelateToEffect(e) then return end
	   --local tg=g:RandomSelect(tp,1)
		Duel.Overlay(c,tg)
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif e:GetLabel()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
		if not c:IsRelateToEffect(e) or not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return end
		if c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)>0 then Duel.Draw(1-tp,1,REASON_EFFECT) end
	end
end
function cm.filter3(c,tp)
	return c:IsCode(11451582) and c:IsSSetable()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=3
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter3),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then Duel.SSet(tp,tc) end
end