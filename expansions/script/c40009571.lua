--焰之护符 戏法之星
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40009571,"BlazeTalisman")
function cm.initial_effect(c)
	aux.AddCodeList(c,40009577)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.negcon)
	e1:SetTarget(cm.negtg)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:IsFaceup() and ((c:CheckSetCard("BlazeMaiden") and c:IsType(TYPE_MONSTER)) or (c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_FIRE)))
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local rc = re:GetHandler()
	if Duel.NegateActivation(ev) and (Duel.GetLocationCount(tp,LOCATION_SZONE) > 0 or (rc:IsLocation(LOCATION_SZONE) and rc:GetSequence() < 5)) and rc:IsRelateToEffect(re) then
		rc:CancelToGrave()
		if not (rc:IsLocation(LOCATION_SZONE) and rc:GetSequence() < 5) then 
			Duel.MoveToField(rc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end 
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		rc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_ADD_SETCODE)
		e2:SetValue("BlazeTalisman")
		rc:RegisterEffect(e2,true)
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,false)
	end
end
function cm.desop(e,tp)
	local g = Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if #g > 0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg = g:Select(tp,1,1,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
cm.Overlay_List = { CATEGORY_DESTROY,cm.desop }