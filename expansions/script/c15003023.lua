local m=15003023
local cm=_G["c"..m]
cm.name="虚空孔穴·格利扎"
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,2,6)
	--attach
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetTarget(cm.attg)
	e1:SetOperation(cm.atop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(cm.con1)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.con2)
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--cannot activate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.con3)
	e6:SetTargetRange(1,1)
	e6:SetValue(cm.aclimit)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_SSET)
	e7:SetRange(LOCATION_MZONE)
	--e7:SetCondition(cm.con3)
	e7:SetOperation(cm.aclimset)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetCode(EFFECT_CANNOT_MSET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(cm.con3)
	e8:SetTargetRange(1,1)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e9)
	--negate
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_CHAINING)
	e10:SetCountLimit(1)
	e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(cm.con4)
	e10:SetTarget(cm.distg)
	e10:SetOperation(cm.disop)
	c:RegisterEffect(e10)
	--atk
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetCode(EFFECT_UPDATE_ATTACK)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(cm.con5)
	e11:SetValue(5000)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e12)
	if not cm.GreezaCheck then
		cm.GreezaCheck=true
		_GAnnounceCard=Duel.AnnounceCard
		function Duel.AnnounceCard(p,...)
			local res=_GAnnounceCard(p,...)
			if res==15003023 then res=0 end
			return res
		end
	end
end
function cm.mfilter(c,xyzc)
	return c:IsRace(RACE_FIEND) and c:IsType(TYPE_XYZ)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetCode)==g:GetCount() and g:GetClassCount(Card.GetRank)==1
end
function cm.callcon(e,tp,eg,ep,ev,re,r,rp)
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_ANNOUNCE)
	return ex
end
function cm.callchk(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetChainInfo(ev,CHAININFO_TARGET_PARAM)
	if bit.band(code,15003023)~=0 then
		Duel.ChangeTargetParam(ev,0)
	end
end
function cm.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.matfilter(c)
	return c:IsCanOverlay()
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not Duel.IsExistingMatchingCard(cm.matfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,0,1,c) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.matfilter),tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():GetCount()<=4 and e:GetHandler():GetOverlayGroup():GetCount()>=1
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():GetCount()<=4 and e:GetHandler():GetOverlayGroup():GetCount()>=2
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():GetCount()<=4 and e:GetHandler():GetOverlayGroup():GetCount()>=3
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():GetCount()==4 and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():GetCount()>=5
end
function cm.aclimit(e,re,tp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_SPELL) then return false end
	local c=re:GetHandler()
	return not c:IsLocation(LOCATION_SZONE) or c:GetFlagEffect(15003023)>0
end
function cm.aclimset(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local reset=tc:GetControler()==tp and RESET_OPPO_TURN or RESET_SELF_TURN
		tc:RegisterFlagEffect(15003023,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+reset,0,1)
		tc=eg:GetNext()
	end
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end