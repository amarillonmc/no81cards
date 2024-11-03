--秘计螺旋 混沌
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.filter(c,code)
	return (not code or c:GetOriginalCode()==code) and c:IsSetCard(0x836) and not (c:IsFaceup() and c:IsOnField()) and c:CheckActivateEffect(false,false,false)~=nil
end
function cm.fselect(g)
	for code=11451961,11451964 do
		if not g:IsExists(cm.filter,1,nil,code) then return false end
	end
	return true
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		for code=11451961,11451964 do
			if not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD+LOCATION_DECK,0,1,nil,code) then return false end
		end
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and (Duel.GetLocationCount(tp,LOCATION_SZONE)>1 or e:GetHandler():IsOnField())
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD+LOCATION_DECK,0,nil,code)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not g:CheckSubGroup(cm.fselect,4,4) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,4,4)
	if #sg==4 then
		local ct=sg:FilterCount(Card.IsOnField,nil)+1
		for i=1,math.min(ct,4) do
			if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
			if i>1 then Duel.BreakEffect() end
			local tc=sg:RandomSelect(tp,1):GetFirst()
			if not tc:IsOnField() then
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			else
				Duel.ChangePosition(tc,POS_FACEUP)
			end
			Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
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
			if operation then operation(te,tp,ceg,cep,cev,cre,cr,crp) end
			tc:ReleaseEffectRelation(te)
			if g then
				for fc in aux.Next(g) do
					fc:ReleaseEffectRelation(te)
				end
			end
			sg:RemoveCard(tc)
		end
	end	  
end