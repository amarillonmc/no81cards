--炽热的信仰 佐仓杏子
function c60152003.initial_effect(c)
	--sp
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_SPSUMMON_PROC)
	e12:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e12:SetRange(LOCATION_HAND)
	e12:SetCondition(c60152003.spcon2)
	e12:SetOperation(c60152003.spop2)
	c:RegisterEffect(e12)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60152003,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,60152003)
    e1:SetCondition(c60152003.con)
	e1:SetTarget(c60152003.target)
	e1:SetOperation(c60152003.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60152003,1))
    e3:SetCategory(CATEGORY_RELEASE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,6012003)
    e3:SetCondition(c60152003.con)
    e3:SetTarget(c60152003.target2)
    e3:SetOperation(c60152003.activate2)
    c:RegisterEffect(e3)
end
function c60152003.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c60152003.spfilter2(c)
	return ((c:IsSetCard(0x6b25) and c:IsType(TYPE_MONSTER)) 
		or (c:IsType(TYPE_TOKEN) and c:IsAttribute(ATTRIBUTE_FIRE))) and c:IsReleasable()
end
function c60152003.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 then 
		return Duel.IsExistingMatchingCard(c60152003.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
			and Duel.IsExistingMatchingCard(c60152003.spfilter2,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.IsExistingMatchingCard(c60152003.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
	end
end
function c60152003.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,c60152003.spfilter2,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
		local tc2=g:GetFirst()
		while tc2 do
			if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
			tc2=g:GetNext()
		end
		Duel.Release(g,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g1=Duel.SelectMatchingCard(tp,c60152003.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
		local tc=g1:GetFirst()
		while tc do
			if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
			tc=g1:GetNext()
		end
		Duel.Release(g1,REASON_COST)
	end
end
function c60152003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60152003.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsPlayerCanDraw(tp,1) end
		local g=Duel.GetMatchingGroup(c60152003.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60152003.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c60152003.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        if Duel.Release(g,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.Draw(p,d,REASON_EFFECT)
		end
    end
end
function c60152003.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60152003.spfilter2,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(c60152003.spfilter2,tp,LOCATION_DECK,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function c60152003.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c60152003.spfilter2,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT+REASON_RELEASE)
    end
end