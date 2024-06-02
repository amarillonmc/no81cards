--枢机神降·虚界之刃
local cm,m,o=GetID()
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.desreptg)
	e2:SetValue(cm.desrepval)
	e2:SetOperation(cm.desrepop)
	c:RegisterEffect(e2)
end
if not cm.tab then
	cm.tab={}
end
if not cm.num then
	cm.num=0
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.thfilter(c)
	return c:IsSetCard(0x647) and c:IsAbleToHand() and c:IsType(TYPE_EQUIP)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.ablefil(c)
	local ub=true
	local ableg=Group.FromCards(table.unpack(cm.tab))
	local ablec=ableg:GetFirst()
	for i=1,#ableg do
		if c:IsCode(ablec:GetCode()) then
			ub=false
		end
		ablec=ableg:GetNext()
	end
	return c:IsSetCard(0x647) and ub==true and c:IsType(TYPE_MONSTER)
end
function cm.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField()
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(cm.ablefil,tp,LOCATION_DECK,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.desrepval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.ablefil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		table.insert(cm.tab,g:GetFirst())
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
				
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		cm.num=cm.num+1
			
		if cm.eff then cm.eff:Reset() end
		
		local e100=Effect.CreateEffect(c)
		e100:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e100:SetCode(EVENT_ADJUST)
		e100:SetCondition(cm.rcon)
		e100:SetOperation(cm.rop)
		Duel.RegisterEffect(e100,tp)
		cm.eff=e100
	end
end

function cm.sfil(c)
	return c:GetFlagEffect(m)~=0
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.sfil,tp,LOCATION_HAND,0,nil)
	return cm.num~=#g
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.sfil,tp,LOCATION_HAND,0,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(cm.sfil,tp,LOCATION_HAND,0,nil)
	cm.num=#g
	Duel.Readjust()
	if cm.num==0 then e:Reset() end
end