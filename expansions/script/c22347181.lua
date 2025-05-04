--蕾宗忍者古神 哈姆
function c22347181.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x5705),3,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--spsummon
	local pe0=Effect.CreateEffect(c)
	pe0:SetType(EFFECT_TYPE_FIELD)
	pe0:SetCode(EFFECT_SPSUMMON_PROC)
	pe0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	pe0:SetRange(LOCATION_EXTRA)
	pe0:SetCondition(c22347181.sprcon)
	pe0:SetTarget(c22347181.sprtg)
	pe0:SetOperation(c22347181.sprop)
	c:RegisterEffect(pe0)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c22347181.postg)
	e1:SetOperation(c22347181.posop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FLIP)
	--e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c22347181.regop)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22347181.actcon)
	e3:SetOperation(c22347181.chainop)
	c:RegisterEffect(e3)
end
function c22347181.matfilter(c)
	return c:IsDiscardable() and c:IsSetCard(0x3705) and c:IsType(TYPE_SPELL) and c:IsPublic()
end
function c22347181.sprcon(e,c)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c22347181.matfilter,c:GetOwner(),LOCATION_HAND,0,nil)
	return mg:GetCount()>=2
end
function c22347181.selectcheck(mg)
	return true
end
function c22347181.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(c22347181.matfilter,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=mg:SelectSubGroup(tp,c22347181.selectcheck,true,2,2)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c22347181.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=e:GetLabelObject()
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_DISCARD)
	mg:DeleteGroup()
end
function c22347181.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c22347181.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22347181,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,2,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.HintSelection(g)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
function c22347181.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(22347181,RESET_EVENT+RESETS_STANDARD,0,1)
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	for tc in aux.Next(g) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
end
function c22347181.actcon(e)
	return e:GetHandler():GetFlagEffect(22347181)~=0
end
function c22347181.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x3705) and ep==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) then
		Duel.SetChainLimit(c22347181.chainlm)
	end
end
function c22347181.chainlm(e,rp,tp)
	return tp==rp
end
