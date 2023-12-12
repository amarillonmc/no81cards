--海冥灯
ncode={}
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition1)
	e1:SetCost(cm.cost1)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tp=eg:GetFirst():GetOwner()
	Duel.NegateSummon(eg)
	if Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)~=0 then
		Debug.Message("1")
		local bg=Duel.GetOperatedGroup()
		local tbg=bg:Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		local t=#tbg
		ncode={}
		local nc=tbg:GetFirst()
		for i=1,t do
			ncode[i]=nc:GetCode()
			nc=tbg:GetNext()
		end
		Debug.Message(t)
		local csg=Duel.GetMatchingGroup(cm.fil,tp,LOCATION_DECK,0,nil,t,e,tp)
		local spg=csg:RandomSelect(tp,math.min(#csg,t))
		Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
		if #csg<t then
			Duel.Draw(tp,t-#csg,REASON_EFFECT)
		end
	end
end

function cm.fil(c,t,e,tp)
	local ccode=0
	for i=1,t do
		if ncode[i]==c:GetCode() then
			ccode=ccode+1
		end
	end
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ccode==0
end












