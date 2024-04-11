local m=53799198
local cm=_G["c"..m]
cm.name="银梦之一太刀 YMN"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end
	if not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,e:GetHandler()) then e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN) else e:SetProperty(0) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_MZONE)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		local tc=tg:GetFirst()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		if #tg>1 then tc=tg:Select(1-tp,1,1,nil):GetFirst() end
		Duel.HintSelection(Group.FromCards(tc))
		if Duel.SendtoGrave(tc,REASON_RULE)~=0 then
			Duel.BreakEffect()
			Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		end
	end
end
