--崩山龙契 精钢西留德
local m=33201264
local cm=_G["c"..m]
function cm.initial_effect(c)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.desreptg)
	e1:SetValue(cm.desrepval)
	e1:SetOperation(cm.desrepop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
end
cm.VHisc_DragonCovenant=true

function cm.repfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_LEAVE_FIELD_REDIRECT) and c:IsControler(tp) and c.VHisc_DragonCovenant and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp) 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local g=eg:Filter(cm.repfilter,nil,tp)
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function cm.desrepval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		local tg=e:GetLabelObject() 
		Duel.SendtoHand(tg,nil,REASON_EFFECT+REASON_REPLACE)
		if tg:GetFirst():IsLocation(LOCATION_HAND+LOCATION_EXTRA) then
			Duel.ConfirmCards(1-tp,tg)
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			Duel.Hint(24,0,aux.Stringid(m,1))
		end
	end
end

function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep==1-tp and Duel.IsChainNegatable(ev) and e:GetHandler():GetEquipGroup():IsExists(function(ec) return ec.VHisc_DragonRelics end,1,nil)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
	Duel.Hint(24,0,aux.Stringid(m,3))
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