function c10111184.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111184,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,10111184)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c10111184.target1)
	e2:SetOperation(c10111184.activate1)
	c:RegisterEffect(e2)
	--atk 下降
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	e3:SetValue(c10111184.val)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10111184,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,101111840)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c10111184.descon)
	e4:SetTarget(c10111184.target)
	e4:SetOperation(c10111184.activate)
	e4:SetValue(c10111184.zones)
	c:RegisterEffect(e4)
	if not c10111184.global_check then
		c10111184.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DETACH_MATERIAL)
		ge1:SetOperation(c10111184.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
		ge2:SetCondition(c10111184.regop)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAIN_END)
		ge3:SetCondition(c10111184.clearop)
		Duel.RegisterEffect(ge3,0)
		c10111184[0]={}
		c10111184[1]={}
	end
end
function c10111184.checkop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetCurrentChain()
	if cid>0 and (r&REASON_COST)>0 then
		local te=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_EFFECT)
		local rc=te:GetHandler()
		if rc:IsRelateToEffect(te) and c10111184[1][rc]~=nil then
			local dg=c10111184[1][rc]-rc:GetOverlayGroup()
			if dg:IsExists(Card.IsType,1,nil,TYPE_NORMAL) then
				c10111184[0][rc]=rc:GetFieldID()
			end
		end
	end
	c10111184[1]={}
end
function c10111184.regop(e,tp,eg,ep,ev,re,r,rp)
	if (r&REASON_COST)==REASON_COST and re:IsActiveType(TYPE_XYZ) then
		local rc=re:GetHandler()
		c10111184[1][rc]=rc:GetOverlayGroup()
	end
	return false
end
function c10111184.clearop(e,tp,eg,ep,ev,re,r,rp)
	c10111184[0]={}
	c10111184[1]={}
end
function c10111184.descon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsControler(tp) and rc:GetFieldID()==c10111184[0][rc]
end
function c10111184.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE)
	if not b or p0 and p1 then return zone end
	if p0 then zone=zone-0x1 end
	if p1 then zone=zone-0x10 end
	return zone
end
function c10111184.penfilter(c)
	return c:IsSetCard(0x160) and c:IsType(TYPE_PENDULUM)
		and not c:IsForbidden()
end
function c10111184.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c10111184.penfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c10111184.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c10111184.penfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c10111184.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x160)
end
function c10111184.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevel(3) and c:IsCanOverlay()
end
function c10111184.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c10111184.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10111184.tgfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c10111184.matfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10111184.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10111184.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c10111184.matfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
function c10111184.val(e,c)
	return Duel.GetOverlayCount(e:GetHandlerPlayer(),1,1)*-200
end