--落入蛛网的蝴蝶
local m=16150004
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},nil,nil,nil,nil,nil,cm.thop)
	--disable spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,3))
	e5:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_SUMMON)
	e5:SetCondition(cm.dscon)
	e5:SetCountLimit(1,m)
	e5:SetTarget(cm.dstg)
	e5:SetOperation(cm.dsop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e7)
end
function cm.thfilter(c,e)
	return c:IsFaceup() and not c:IsImmuneToEffect(e) and c:IsCanChangePosition()
end
function cm.thop(e,tp)
	rsop.SelectSolve(HINTMSG_POSITION,tp,cm.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,{cm.solvefun,tp})
end
function cm.solvefun(g,tp)
	local tc=g:GetFirst()
	local b1=c:IsFaceup() and not c:IsImmuneToEffect(e) and c:IsCanChangePosition()
	if b1 then
		Duel.ChangePosition(tc,dd)   
	end
end
function cm.dscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(Card.IsRace,1,nil,RACE_INSECT)
end
function cm.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spfilter(c,e,tp,og)
	return not og:IsExists(Card.IsCode,1,nil,c:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and (c:IsRace(RACE_INSECT) or c:IsType(TYPE_FLIP))
end
function cm.dsop(e,tp,eg,ep,ev,re,r,rp)
	local ng=eg:Filter(Card.IsRace,nil,RACE_INSECT)
	if Duel.NegateSummon(ng) and Duel.SendtoHand(ng,tp,REASON_EFFECT) then
		local og=Duel.GetOperatedGroup()
		if Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,og) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,og)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		end
	end
end