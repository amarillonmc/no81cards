--海中列车
local cm,m=GetID()
function cm.initial_effect(c)
	--twist spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC_G)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(cm.spcon)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(0xff)
	e1:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(3,m)
	e2:SetCost(cm.drcost)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,e,tp)
	return c:IsPublic() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	local bg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND,0,c,e,tp)
	if #bg==0 then return false end
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	local bg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND,0,c,e,tp)
	if #bg==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local bc=bg:Select(tp,1,1,nil):GetFirst()
	sg:AddCard(bc)
	sg:AddCard(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e1:SetValue(LOCATION_REMOVED)
	bc:RegisterEffect(e1,true)
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHandAsCost,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 end
	Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.setfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local dg=Duel.GetOperatedGroup()
	local dc=dg:GetFirst()
	if dc:IsRace(RACE_MACHINE) and dc:IsLevel(10) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		dc:RegisterEffect(e1,true)
	end
end