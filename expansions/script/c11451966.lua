--秘计螺旋 电动
local cm,m=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,m-5)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.chcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.chtg)
	e2:SetOperation(cm.chop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsCode(m-5) and c:CheckActivateEffect(false,false,false)~=nil
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=1 end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>ft end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE+LOCATION_DECK,0,nil,code)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:Select(tp,1,1,nil)
	if #sg>0 then
		local tc=sg:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		--Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,false,true)
		te:UseCountLimit(tp,1,true)
		local cost=te:GetCost()
		local target=te:GetTarget()
		local operation=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()
		if not tc:IsType(TYPE_EQUIP) then tc:CancelToGrave(false) end
		tc:CreateEffectRelation(te)
		if cost then cost(te,tp,ceg,cep,cev,cre,cr,crp,1) end
		if target then target(te,tp,ceg,cep,cev,cre,cr,crp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			for fc in aux.Next(g) do
				fc:CreateEffectRelation(te)
			end
		end
		if operation then
			operation(te,tp,ceg,cep,cev,cre,cr,crp)
			Duel.BreakEffect()
			operation(te,tp,ceg,cep,cev,cre,cr,crp)
		end
		tc:ReleaseEffectRelation(te)
		if g then
			for fc in aux.Next(g) do
				fc:ReleaseEffectRelation(te)
			end
		end
	end   
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x836)
end
function cm.thfilter(c)
	return c:IsSetCard(0x836) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if rp==tp then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
		else return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_DECK,1,nil) end
	end
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end