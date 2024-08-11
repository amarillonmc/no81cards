--娜塔莎-遍世仁心-
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x629,LOCATION_ONFIELD)
	--summon success
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_COUNTER)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetTarget(cm.tg)
	e11:SetOperation(cm.op)
	c:RegisterEffect(e11)
	local e2=e11:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.rthtg)
	e3:SetOperation(cm.rthop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.cgcon)
	e1:SetOperation(cm.cgop)
	c:RegisterEffect(e1)
end
if not cm.cnum then
	cm.cnum=0
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message(cm.cnum)
	local c=e:GetHandler()
	local i=c:GetControler()
	if cm.cnum~=Duel.GetCounter(i,LOCATION_ONFIELD,0,0x629) then
		cm.cnum=Duel.GetCounter(i,LOCATION_ONFIELD,0,0x629)
		Duel.RaiseEvent(c,EVENT_CUSTOM+m,nil,0,i,i,0)
	end
end
function cm.ctfil(c)
	return c:IsCode(60010143) and c:IsFaceup()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x629)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local u=1
	if Duel.IsPlayerAffectedByEffect(tp,m+1) then
		u=3
	end
	if e:GetHandler():IsRelateToEffect(e) then
		if e:GetHandler():AddCounter(0x629,u)~=0 and Duel.IsExistingMatchingCard(cm.ctfil,tp,LOCATION_FZONE,0,1,nil) then
			local g=Duel.GetMatchingGroup(cm.ctfil,tp,LOCATION_FZONE,0,nil)
			if #g==0 then return end
			for c in aux.Next(g) do
				c:AddCounter(0x629,u)
			end
		end
	end
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsLocation(LOCATION_MZONE) and not e:GetHandler():IsPosition(POS_FACEUP_DEFENSE) then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end
function cm.rthfilter(c)
	return c:IsAbleToHand() and c:GetCounter(0x629)>0
end
function cm.rthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.rthfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,cm.rthfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,g1:GetCount(),0,LOCATION_ONFIELD)
end
function cm.rthop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	local ctable={}
	for tc in aux.Next(g) do
		if tc:IsControler(tp) then
			ctable[tc]=tc:GetCounter(0x629)
		end
	end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=0
	for tc,num in pairs(ctable) do
		if og:IsContains(tc) and tc:IsLocation(LOCATION_HAND) then
			ct=ct+num
		end
	end
	if ct>0 then
		Duel.BreakEffect()
		e:GetHandler():AddCounter(0x629,ct)
	end
end
function cm.cgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerCanDiscardDeck(tp,1)
end
function cm.cgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m) 
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
end



