--混沌帝龙 -宵暗的使者-
function c98920566.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--attribute light
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920566,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c98920566.spcon)
	e3:SetOperation(c98920566.spop)
	e3:SetLabel(ATTRIBUTE_LIGHT)
	e3:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCondition(c98920566.spcon1)
	e4:SetDescription(aux.Stringid(98920566,1))
	e4:SetLabel(ATTRIBUTE_DARK)
	c:RegisterEffect(e4)
	--remove
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98920566,2))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c98920566.rmcon)
	e5:SetCost(c98920566.rmcost)
	e5:SetTarget(c98920566.rmtg)
	e5:SetOperation(c98920566.rmop)
	c:RegisterEffect(e5)
	e3:SetLabelObject(e5)
	e4:SetLabelObject(e5)
end
function c98920566.spfilter(c,att)
	return c:IsAttribute(att) and c:IsAbleToRemoveAsCost()
end
function c98920566.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ct=Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_LIGHT)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and ct>Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_DARK)
		and Duel.IsExistingMatchingCard(c98920566.spfilter,tp,LOCATION_GRAVE,0,ct,nil,e:GetLabel())
end
function c98920566.spcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ct=Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_LIGHT)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and ct<Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_DARK)
		and Duel.IsExistingMatchingCard(c98920566.spfilter,tp,LOCATION_GRAVE,0,ct,nil,e:GetLabel())
end
function c98920566.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c98920566.spfilter,tp,LOCATION_GRAVE,0,nil,e:GetLabel())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetLabelObject():SetLabel(e:GetLabel())
end
function c98920566.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function c98920566.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98920566.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920566.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then
		if e:GetLabel()==ATTRIBUTE_LIGHT then
			return Duel.IsExistingMatchingCard(c98920566.spfilter1,tp,LOCATION_REMOVED,0,1,nil,e,tp)
		else
			return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil,tp)
		end
	end
	if e:GetLabel()==ATTRIBUTE_LIGHT then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_MZONE)
	end
	e:SetProperty(0)
end
function c98920566.rmop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==ATTRIBUTE_LIGHT then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
		if ft>0 and ct>0 then
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
			ct=math.min(ct,ft)
			local g=Duel.GetMatchingGroup(c98920566.spfilter1,tp,LOCATION_REMOVED,0,nil,e,tp)
			local sf=g:GetCount()
			ct=math.min(ct,sf)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,ct,ct,nil)
			if sg then
			   Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	else
		local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
		local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
		if ct>0 then
		   Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
		   local sg=g:FilterSelect(1-tp,Card.IsAbleToRemove,ct,ct,nil,1-tp)
		   Duel.Remove(sg,POS_FACEUP,REASON_RULE)
		end
	end
end