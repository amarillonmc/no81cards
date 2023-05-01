--腐坏的异梦怪物
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400030.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,yume.YumeLMGFilterFunction(c))
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetCondition(yume.nonRustCon)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e1a)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetDescription(aux.Stringid(71400030,0))
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c71400030.con1)
	e2:SetTarget(c71400030.tg1)
	e2:SetOperation(c71400030.op1)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2a)
end
function c71400030.con1(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and not yume.IsRust(tp)
end
function c71400030.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(Card.IsAbleToRemove,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c71400030.filter1(c,e)
	return c:IsRelateToEffect(e) and c:IsAbleToRemove()
end
function c71400030.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c71400030.op1(e,tp,eg,ep,ev,re,r,rp)
	local g1=eg:Filter(c71400030.filter1,nil,e)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		local mg=Duel.GetMatchingGroup(c71400030.filter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,aux.ExceptThisCard(e))
		mg:Sub(sg1)
		if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71400032,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg2=mg:Select(tp,1,2,nil)
			sg1:Merge(sg2)
		end
		Duel.HintSelection(sg1)
		if Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.SetLP(tp,Duel.GetLP(tp)-sg1:GetCount()*600)
		end
	end
end
