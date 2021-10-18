--诡雷战阵 机装要塞
--21.04.22
local m=11451565
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(cm.eqcon)
	e2:SetTarget(cm.eqtg)
	e2:SetOperation(cm.eqop)
	c:RegisterEffect(e2)
	--activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(cm.accon)
	e3:SetCost(cm.accost)
	e3:SetTarget(cm.actg)
	e3:SetOperation(cm.acop)
	c:RegisterEffect(e3)
end
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local typ=Duel.GetChainInfo(ev,CHAININFO_EXTTYPE)
	return rc:IsSetCard(0x97e) and typ&0x40002==0x40002 and re:GetType()&EFFECT_TYPE_ACTIVATE==0
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=re:GetHandler():GetPreviousEquipTarget()
	if chkc then return false end
	if chk==0 then return tc and Duel.IsPlayerCanDraw(tp,1) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsCanBeEffectTarget(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetTargetCard(tc)
	Duel.HintSelection(Group.FromCards(tc))
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND)
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.Draw(tp,1,REASON_EFFECT)>0 and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		if ec and Duel.Equip(tp,ec,tc,false) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.eqlimit)
			ec:RegisterEffect(e1)
		end
	end
end
function cm.acfilter(c,tp)
	return c:IsPreviousControler(tp) and c:GetEquipTarget()
end
function cm.accon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.acfilter,1,nil,tp)
end
function cm.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x97e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return c:IsType(TYPE_FIELD) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true) and not c:IsHasEffect(EFFECT_NECRO_VALLEY) and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_DECK)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsType(TYPE_FIELD) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)) then return end
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	local res=Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	if res then
		local te=c:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=c:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(c,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end