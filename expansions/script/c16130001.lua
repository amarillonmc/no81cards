--B·O·W. NYX
Duel.LoadScript("c16199990.lua")
local m,cm=rk.set(16130001,"BOW")
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--synchro summon
	aux.AddSynchroProcedure(c,cm.synfilter,aux.NonTuner(cm.synfilter),2) 
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(cm.urlval)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.discon)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
end
cm.material_type=TYPE_SYNCHRO
function cm.synfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_SYNCHRO)
end
function cm.urlval(e,c,...)
	return c:IsRace(RACE_ZOMBIE) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
end
function cm.efilter(e,te)
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,3,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
	end
end
function cm.sfilter(c)
	return c:IsRace(RACE_ZOMBIE) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		local g1=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		local rc=re:GetHandler()
		if not re:IsActiveType(TYPE_MONSTER) then rc:CancelToGrave()
		if not rc:IsAbleToHand() then Duel.SendtoGrave(rc,REASON_RULE) end end
		if Duel.SendtoHand(eg,tp,REASON_EFFECT)==0 then return end
		local og=Duel.GetOperatedGroup()
		local tc=og:GetFirst()
		if tc:IsControler(tp) and tc:IsLocation(LOCATION_HAND) and Duel.GetMatchingGroupCount(cm.sfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)>Duel.GetMatchingGroupCount(nil,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil) and g:GetCount()>0 and g1:GetCount()>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.ConfirmCards(tp,g1)
			if not Duel.SelectYesNo(tp,aux.Stringid(m,4)) then return end
			local tg1=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
			local tg2=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_GRAVE,nil)
			local tg3=g1:Filter(Card.IsAbleToHand,nil)
			local sg=Group.CreateGroup()
			if tg1:GetCount()>0 and ((tg2:GetCount()==0 and tg3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg1=tg1:Select(tp,1,1,nil)
				Duel.HintSelection(sg1)
				sg:Merge(sg1)
			end
			if tg2:GetCount()>0 and ((sg:GetCount()==0 and tg3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg2=tg2:Select(tp,1,1,nil)
				Duel.HintSelection(sg2)
				sg:Merge(sg2)
			end
			if tg3:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(m,3))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg3=tg3:Select(tp,1,1,nil)
				sg:Merge(sg3)
			end
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
		end
	end
end