--人理之基 泳装伊什塔尔
function c22020990.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,22020300,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6ff1),1,true,true)
	--to field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22020990,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,22020990)
	e1:SetCost(c22020990.cost)
	e1:SetTarget(c22020990.target)
	e1:SetOperation(c22020990.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020990,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,22020990)
	e2:SetCondition(c22020990.spcon)
	e2:SetCost(c22020990.cost1)
	e2:SetTarget(c22020990.target1)
	e2:SetOperation(c22020990.operation1)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c22020990.spcon)
	e3:SetOperation(c22020990.chainop)
	c:RegisterEffect(e3) 
end
function c22020990.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22020990,2))
	Duel.SelectOption(tp,aux.Stringid(22020990,3))
end
function c22020990.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c22020990.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(22020990,2))
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function c22020990.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22020990,4))
end
function c22020990.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c22020990.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c22020990.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function c22020990.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(c22020990.desfilter,tp,0,LOCATION_ONFIELD,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SelectOption(tp,aux.Stringid(22020990,5))
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c22020990.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS 
end
function c22020990.typefil(c,otype) 
	local flag1=0 
	local flag2=0 
	if bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 then flag1=bit.bor(flag1,TYPE_MONSTER) end 
	if bit.band(c:GetOriginalType(),TYPE_SPELL)~=0 then flag1=bit.bor(flag1,TYPE_SPELL) end 
	if bit.band(c:GetOriginalType(),TYPE_TRAP)~=0 then flag1=bit.bor(flag1,TYPE_TRAP) end 
	if bit.band(otype,TYPE_MONSTER)~=0 then flag2=bit.bor(flag2,TYPE_MONSTER) end 
	if bit.band(otype,TYPE_SPELL)~=0 then flag2=bit.bor(flag2,TYPE_SPELL) end 
	if bit.band(otype,TYPE_TRAP)~=0 then flag2=bit.bor(flag2,TYPE_TRAP) end 
	return flag1==flag2 
end 
function c22020990.ffilter(c,fc,sub,mg,sg)
	return not sg or not sg:IsExists(c22020990.typefil,1,c,c:GetOriginalType())
end
function c22020990.chainop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,22090000) 
	local flag=0 
	if re:IsActiveType(TYPE_MONSTER) then flag=bit.bor(flag,TYPE_MONSTER) end 
	if re:IsActiveType(TYPE_SPELL) then flag=bit.bor(flag,TYPE_SPELL) end 
	if re:IsActiveType(TYPE_TRAP) then flag=bit.bor(flag,TYPE_TRAP) end  
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e1:SetLabel(flag)
	e1:SetTargetRange(1,1) 
	e1:SetValue(c22020990.actlimit)
	e1:SetReset(RESET_CHAIN) 
	Duel.RegisterEffect(e1,tp) 
end 
function c22020990.actlimit(e,re,tp) 
	local flag=e:GetLabel() 
	return flag and re:IsActiveType(TYPE_MONSTER)
end