--万圣之夜 甘城猫猫&猫羽雫
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,s.lcheck)
	c:EnableReviveLimit()
	--(remove and atk up) or (tohand and tograve)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,id-70000000)
	e2:SetCondition(s.tgcon)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end
function s.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x52c4)
end
function s.thfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x52c4) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_REMOVED,0,1,nil)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(id,1)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,sel+1))
	if sel==0 then
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
		if g:GetCount()>0 then
			if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
				local atk=g:GetFirst():GetBaseAttack()
				if atk>0 then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetValue(atk)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
					e:GetHandler():RegisterEffect(e1)
				end
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_REMOVED,0,1,2,nil)
		if g:GetCount()>0 then
			if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
				Duel.ConfirmCards(1-tp,g)
				Duel.BreakEffect()
				Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT)
			end
		end
	end
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x52c4)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	local lab=0
	if re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
		lab=1
	end
	e:SetLabel(lab)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end