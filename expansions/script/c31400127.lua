local m=31400127
local cm=_G["c"..m]
cm.name="HDR-轨道"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(cm.lasting)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(cm.remop)
	c:RegisterEffect(e3)
end
function cm.thfilter(c)
	return c:IsCode(m,44009443,93953933) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.rem(p)
	local grave=Duel.GetFieldGroup(p,LOCATION_GRAVE,0)
	if grave:FilterCount(Card.IsAbleToRemove,nil,POS_FACEDOWN)==0 or grave:GetClassCount(Card.GetCode)==#grave then return end
	local same_code_g=grave:Filter(function(c,g) return g:FilterCount(Card.IsCode,nil,c:GetCode())~=1 end,nil,grave)
	Duel.Hint(HINT_CARD,0,m)
	local can_rem_g=same_code_g:Filter(Card.IsAbleToRemove,nil,POS_FACEDOWN)
	if #can_rem_g==0 then return end
	local cannot_rem_g=same_code_g:Clone()
	cannot_rem_g:Sub(can_rem_g)
	local remg=Group.CreateGroup()
	cannot_rem_g:ForEach(
		function (c)
			local g=can_rem_g:Filter(Card.IsCode,nil,c:GetCode())
			remg:Merge(g)
			can_rem_g:Sub(g)
		end
	)
	local num=can_rem_g:GetClassCount(Card.GetCode)
	if num>0 then
		Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(m,1))
		aux.GCheckAdditional=aux.dncheck
		local sg=can_rem_g:SelectSubGroup(p,aux.TRUE,false,num,num)
		aux.GCheckAdditional=nil
		can_rem_g:Sub(sg)
	end
	remg:Merge(can_rem_g)
	Duel.Remove(remg,POS_FACEDOWN,REASON_RULE)
end
function cm.remop(e,tp,eg,ep,ev,re,r,rp)
	cm.rem(0)
	cm.rem(1)
end
function cm.lasting(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsPreviousLocation(LOCATION_FZONE) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(cm.remop)
	if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	end
	Duel.RegisterEffect(e1,0)
end