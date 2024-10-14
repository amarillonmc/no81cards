--最终征途
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c,res,e,tp,eg,ep,ev,re,r,rp)
	local te=c:GetActivateEffect()
	if not (c:IsType(TYPE_SPELL) and te and te:GetCondition() and (c:IsAbleToHand() or (res and c:IsAbleToGrave() and te:GetOperation() and (not te:GetTarget() or (te:GetTarget() and te:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0)))))) or c:GetOriginalCode()==71650854 then return end
	final_odyssey=false
	local _GetActivityCount=Duel.GetActivityCount
	local _GetCurrentPhase=Duel.GetCurrentPhase
	local _CheckPhaseActivity=Duel.CheckPhaseActivity
	Duel.GetActivityCount=function() return 0 end
	Duel.GetCurrentPhase=function() return PHASE_MAIN1 end
	Duel.CheckPhaseActivity=function(...) final_odyssey=true return _CheckPhaseActivity(...) end
	--c:CheckActivateEffect(false,true,true)
	te:GetCondition()(e,tp,eg,ep,ev,re,r,rp)
	local res=final_odyssey
	final_odyssey=false
	Duel.GetActivityCount=_GetActivityCount
	Duel.GetCurrentPhase=_GetCurrentPhase
	Duel.CheckPhaseActivity=_CheckPhaseActivity
	return res
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,res,e,tp,eg,ep,ev,re,r,rp) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,res,e,tp,eg,ep,ev,re,r,rp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local te=tc:GetActivateEffect()
		if not (res and tc:IsAbleToGrave() and te and te:GetOperation() and (not te:GetTarget() or (te:GetTarget() and te:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0)))) or Duel.SelectYesNo(tp,aux.Stringid(m,0))==0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			Duel.SendtoGrave(g,REASON_EFFECT)
			if not te then return end
			local tg=te:GetTarget()
			if (not tg or (tg and tg(e,tp,eg,ep,ev,re,r,rp,0))) then
				if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
				local op=te:GetOperation()
				if op then op(e,tp,eg,ep,ev,re,r,rp) end
			end
		end
	end
end