--界限突破·徐盛
function c188828.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(188828,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,188828)
	e1:SetCondition(c188828.spcon)
	e1:SetCost(c188828.spcost)
	e1:SetTarget(c188828.sptg)
	e1:SetOperation(c188828.spop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(188828,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,188829)
	e2:SetTarget(c188828.target)
	e2:SetOperation(c188828.operation)
	c:RegisterEffect(e2)
	--double battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetCondition(c188828.damcon)
	e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(188828,ACTIVITY_SPSUMMON,c188828.counterfilter)
end
function c188828.counterfilter(c)
	return c:IsRace(RACE_WARRIOR)
end
function c188828.cfilter(c)
	return c:IsFaceup() and (c:IsAttribute(ATTRIBUTE_WATER) or c:IsRace(RACE_WARRIOR))
end
function c188828.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c188828.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c188828.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(188828,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c188828.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c188828.splimit(e,c)
	return not c:IsRace(RACE_WARRIOR)
end
function c188828.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c188828.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c188828.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) end
	Debug.Message("犯大吴疆土者，盛必击而破之！")
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,0)
end
function c188828.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if ct<ct2 then ct,ct2=ct2,ct end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_MZONE,1,ct-ct2+2,nil)
	local ct3=g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,ct3)
	local g=g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
	Duel.HintSelection(g)
	g:Merge(sg)
	if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)~=0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
		local c=e:GetHandler()
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		local tc=og:GetFirst()
		while tc do
			tc:RegisterFlagEffect(188828,RESET_EVENT+RESETS_STANDARD,0,1)
			tc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(og)
		e1:SetCountLimit(1)
		e1:SetCondition(c188828.retcon)
		e1:SetOperation(c188828.retop)
		Duel.RegisterEffect(e1,tp)
	end
	c:RegisterFlagEffect(188829,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c188828.retfilter(c)
	return c:GetFlagEffect(188828)~=0
end
function c188828.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(c188828.retfilter,1,nil)
end
function c188828.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c188828.retfilter,nil)
	local og1=g:Filter(Card.IsPreviousLocation,nil,LOCATION_HAND)
	local og2=g:Filter(Card.IsPreviousLocation,nil,LOCATION_ONFIELD)
	if og1 then Duel.SendtoHand(og1,nil,REASON_EFFECT) end
	if og2 then 
		local tc=og2:GetFirst()
		while tc do
			Duel.ReturnToField(tc) 
			tc=og2:GetNext()
		end
	end
	g:DeleteGroup()
end
function c188828.damcon(e)
	local ct=Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND+LOCATION_ONFIELD,0)
	local ct2=Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_HAND+LOCATION_ONFIELD)
	return ct>ct2 and e:GetHandler():GetFlagEffect(188829)>0
end
