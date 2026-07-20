--黑兽之主 惜春
function c43990233.initial_effect(c)
	aux.AddCodeList(c,43990120)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990233,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,43990233)
	e1:SetTarget(c43990233.drtg)
	e1:SetOperation(c43990233.drop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990233,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,43990233+1)
	e2:SetCondition(c43990233.rmcon)
	e2:SetTarget(c43990233.rmtg)
	e2:SetOperation(c43990233.rmop)
	c:RegisterEffect(e2)
end
function c43990233.rmfilter(c)
	return (c:IsCode(43990120) or c:IsSetCard(0x6510)) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and c:IsAbleToRemove()
end
function c43990233.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c43990233.rmfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,e:GetHandler())
	if chk==0 then return #g>0 and e:GetHandler():IsAbleToRemove() and Duel.IsPlayerCanDraw(tp,2) end
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c43990233.spfilter(c,e,tp)
	return c:IsCode(43990120) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43990233.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c43990233.rmfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	if Duel.Remove(Group.FromCards(c,tc),POS_FACEUP,REASON_EFFECT)==0 then return end
	local og=Duel.GetOperatedGroup()
	Duel.Draw(tp,2,REASON_EFFECT)
	local sg=og:Filter(c43990233.spfilter,nil,e,tp)
	if #sg>0 and Duel.GetMZoneCount(tp)>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c43990233.chkfilter(c)
	return c:IsSetCard(0x6510) and not c:IsCode(43990233) and c:IsFaceup()
end
function c43990233.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c43990233.chkfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function c43990233.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return rg:FilterCount(Card.IsAbleToRemove,nil)==3 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,3,0,0)
end
function c43990233.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,3)
	if #g<=0 then return end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
