--·罗兹瓦尔·魔力解放·
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17337540)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,s.mfilter1,s.mfilter2,s.mfilter3)
	aux.AddContactFusionProcedure(c,aux.FilterBoolFunction(Card.IsReleasable,REASON_SPSUMMON),LOCATION_HAND+LOCATION_MZONE,0,Duel.Release,REASON_SPSUMMON+REASON_MATERIAL)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit0)
	c:RegisterEffect(e0)
	--change name
	aux.EnableChangeCode(c,17337540,LOCATION_MZONE+LOCATION_GRAVE)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.th3tg)
	e1:SetOperation(s.th3op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(s.attrcost)
	e2:SetOperation(s.attrop)
	c:RegisterEffect(e2)
end
function s.mfilter1(c)
	return c:IsFusionCode(17337540)
end
function s.mfilter2(c)
	return c:IsFusionSetCard(0x5f50) and c:IsFusionType(TYPE_MONSTER)
end
function s.mfilter3(c)
	return c:IsFusionSetCard(0x3f50) and c:IsFusionType(TYPE_MONSTER)
end
function s.splimit0(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function s.poolfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5f50,0x3f50) and c:IsAbleToHand()
end
function s.th3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.poolfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetAttribute)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,3,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.check(g)
	return g:GetClassCount(Card.GetAttribute)>=3
end
function s.th3op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.poolfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local sg=g:SelectSubGroup(tp,s.check,false,3,3,nil)
	if #sg==3 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function s.attrcostfilter(c) 
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable() 
end
function s.attrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.attrcostfilter,tp,LOCATION_HAND,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,s.attrcostfilter,tp,LOCATION_HAND,0,2,2,nil)
	if g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND) and g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER) then 
		e:SetLabel(1)
	elseif g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH) and g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER) then
		e:SetLabel(2)
	elseif g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE) and g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND) then
		e:SetLabel(3)
	elseif g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH) and g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT) then
		e:SetLabel(4)
	elseif g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE) and g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT) then
		e:SetLabel(5)
	end
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3f50)
end
function s.attrop(e,tp,eg,ep,ev,re,r,rp)
	local et=e:GetLabel()
	local b1= et==1 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil)
	local b2= et==2 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)
	local b3= et==3 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
	local b4= et==4 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
	local b5= et==5 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
	if b1 then
		local g1=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
	end
	if b2 then
		local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
		Duel.SendtoGrave(g2,REASON_EFFECT)
	end
	if b3 then
		local g3=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
		Duel.Remove(g3,POS_FACEUP,REASON_EFFECT)
	end
	if b4 then
		local g4=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(g4) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetDescription(aux.Stringid(id,1))
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			tc:RegisterEffect(e2)
		end
	end
	if b5 then
		local g5=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(g5) do
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(s.efilter)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e4:SetOwnerPlayer(tp)
			tc:RegisterEffect(e4)
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
		end
	end
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end