--蠕动潜行的爱丽丝
function c95101137.initial_effect(c)
	c:SetSPSummonOnce(95101137)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,95101001,c95101137.ffilter,4,63,true,true)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c95101137.sumsuc)
	c:RegisterEffect(e1)
	--spsummon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95101137,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e2:SetCondition(c95101137.con)
	--e2:SetTarget(c95101137.tg)
	e2:SetOperation(c95101137.op)
	c:RegisterEffect(e2)
	--material check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c95101137.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c95101137.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0xbbe) and (not sg or not sg:Filter(Card.IsFusionSetCard,nil,0xbbe):IsExists(Card.IsFusionCode,1,c,c:IsFusionCode()))
end
function c95101137.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) then Duel.SetChainLimitTillChainEnd(aux.FALSE) end
end
function c95101137.valcheck(e,c)
	local ct=e:GetHandler():GetMaterial():GetClassCount(Card.GetCode)
	e:GetLabelObject():SetLabel(ct)
end
function c95101137.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if ct>=5 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	if ct>=7 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	if ct>=9 then
		local g1=Duel.GetDecktopGroup(tp,10)
		local g2=Duel.GetDecktopGroup(1-tp,10)
		g1:Merge(g2)
		Duel.DisableShuffleCheck()
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	end
	if ct>=11 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_EXTRA,LOCATION_HAND+LOCATION_EXTRA,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
