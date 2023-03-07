--阴郁邪树种
local m=40010934
local cm=_G["c"..m]
cm.named_with_DragonTree=1
function cm.DragonTree(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_DragonTree) or c:IsCode(40010936)
end
function cm.CaLaMity(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_CaLaMity
end
function cm.initial_effect(c)
	--Effect 1
	local e02=Effect.CreateEffect(c)  
	e02:SetDescription(aux.Stringid(m,0))
	e02:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e02:SetType(EFFECT_TYPE_IGNITION)
	e02:SetRange(LOCATION_MZONE)
	e02:SetCost(cm.tkcost)
	e02:SetTarget(cm.tktg)
	e02:SetOperation(cm.tkop)
	c:RegisterEffect(e02)  
end
--Effect 1
function cm.cf(c)
	return cm.CaLaMity(c) and c:IsAbleToRemoveAsCost()
end
function cm.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.cf,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0 and g:GetClassCount(Card.GetCode)>2 end
	if #g==3 and g:GetClassCount(Card.GetCode)==3 then
		g:AddCard(c)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	else	
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
		rg:AddCard(c)
		Duel.Remove(rg,POS_FACEUP,REASON_COST)
	end
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,40010936,0,TYPES_TOKEN_MONSTER,3000,3000,100,RACE_PLANT,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,40010936,0,TYPES_TOKEN_MONSTER,3000,3000,100,RACE_PLANT,ATTRIBUTE_DARK) then
		local tkc=Duel.CreateToken(tp,40010936)
		Duel.SpecialSummonStep(tkc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(tkc:GetTextAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(cm.excon)
		tkc:RegisterEffect(e1,true)
		local e12=Effect.CreateEffect(c)
		e12:SetType(EFFECT_TYPE_SINGLE)
		e12:SetCode(EFFECT_CHANGE_INVOLVING_BATTLE_DAMAGE)
		e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e12:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
		e12:SetReset(RESET_EVENT+RESETS_STANDARD)
		e12:SetCondition(cm.excon)
		tkc:RegisterEffect(e12,true)
		local e13=Effect.CreateEffect(e:GetHandler())
		e13:SetType(EFFECT_TYPE_SINGLE)
		e13:SetCode(EFFECT_CHANGE_LEVEL)
		e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e13:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e13:SetValue(100)
		tkc:RegisterEffect(e13,true)
		if Duel.SpecialSummonComplete()==0 then return false end
		local tc=Duel.CreateToken(tp,40010932)
		if tc==nil then return false end
		local te=tc:GetActivateEffect()
		local actchk=te:IsActivatable(tp,true,true)
		if not actchk then return false end
		Duel.BreakEffect()
		cm.actop(e,tp,tc)
	end
end
function cm.excon(e)
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsCode),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil,40010932)
	return #g>0 
end
function cm.actop(e,tp,tc)
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end