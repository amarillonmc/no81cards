--群山的兽领 山风
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,50913601)
	--link summon
	aux.AddLinkProcedure(c,nil,2,4,cm.lcheck)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--change code
	aux.EnableChangeCode(c,50913601,LOCATION_MZONE+LOCATION_GRAVE)
	--fight in main phase
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m+10000)
	e2:SetCost(cm.ftcost)
	e2:SetTarget(cm.fttg)
	e2:SetOperation(cm.ftop)
	c:RegisterEffect(e2)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_WIND)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.thfilter(c)
	return aux.IsCodeListed(c,50913601) or c:IsCode(50913601) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   local c=e:GetHandler()
   if chk==0 then 
		local sel=0
		if Duel.GetLP(tp)>0 then sel=sel+1 end
		if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40044918,0))
		sel=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(m,1))
	else
		Duel.SelectOption(tp,aux.Stringid(m,2))
	end
	e:SetLabel(sel)
	if sel==1 then
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		local e2=Effect.CreateEffect(c)
			  e2:SetType(EFFECT_TYPE_SINGLE)
			  e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			  e2:SetRange(LOCATION_MZONE)
			  e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			  e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			  e2:SetValue(aux.tgoval)
			  c:RegisterEffect(e2)
			  local e3=e2:Clone()
			  e3:SetType(EFFECT_TYPE_SINGLE)
			  e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			  e3:SetRange(LOCATION_MZONE)
			  e3:SetValue(aux.indoval)
			  c:RegisterEffect(e3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		local tc=Duel.GetOperatedGroup():GetFirst()
			if tc:IsType(TYPE_MONSTER) then
			local atk=tc:GetTextAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(atk)
			c:RegisterEffect(e1)  
			end
		end
	end
end
function cm.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_MONSTER) and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
end
function cm.ftcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.ftfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function cm.fttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsPosition(POS_FACEUP_ATTACK) end
	if chk==0 then return c:IsAttackable()
		and Duel.IsExistingTarget(cm.ftfilter,tp,0,LOCATION_MZONE,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,cm.ftfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function cm.ftop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackable() and c:IsControler(tp) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local tc=g:GetFirst()
		if tc:IsControler(1-tp) and tc:IsRelateToEffect(e) then
			local atk=tc:GetAttack()
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_UPDATE_ATTACK)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e4:SetRange(LOCATION_MZONE)
			e4:SetValue(math.ceil(atk/2))
			c:RegisterEffect(e4)
			Duel.CalculateDamage(c,tc)
		end
	end
end