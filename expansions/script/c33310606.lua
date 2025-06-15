--绒武士技 居合
local cm,m=GetID()
cm.rssetcode="FurryWarrior"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(cm.actcon)
	e2:SetValue(aux.TRUE)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.atkcon)
	e3:SetTarget(cm.atktg)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
end
function cm.filter(c)
	return c:IsFaceup() and c.rssetcode and c.rssetcode=="FurryWarrior"
end
function cm.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.IsExistingMatchingCard(cm.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetBattleMonster(tp)
	return ac and ac.rssetcode and ac.rssetcode=="FurryWarrior" and ac:GetBaseAttack()>0 and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function cm.cfilter(c)
	return c:IsAbleToGrave() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsRace(RACE_BEAST)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ac=Duel.GetBattleMonster(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,ac) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function cm.ofilter(c)
	return c:IsRace(RACE_BEAST) and c:IsLevelBelow(2) and c:IsCanOverlay()
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetBattleMonster(tp)
	if not ac:IsRelateToBattle() or ac:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	if #tg>0 and Duel.SendtoGrave(tg,REASON_EFFECT)>0 and tg:GetFirst():IsLocation(LOCATION_GRAVE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ac:GetBaseAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ac:RegisterEffect(e1)
		local og=Duel.GetMatchingGroup(cm.ofilter,tp,LOCATION_DECK,0,nil)
		if not ac:IsImmuneToEffect(e) and ac:IsType(TYPE_XYZ) and #og>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local og2=og:Select(tp,1,1,nil)
			Duel.Overlay(ac,og2)
		end
	end
end