--七色之魂
local m=33711601
local cm=_G["c"..m]
function cm.initial_effect(c)
   --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--maintain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(cm.mtop)
	c:RegisterEffect(e1) 
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.negcon)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--Skip Phase
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCost(cm.skipcost)
	e4:SetTarget(cm.skiptg)
	e4:SetOperation(cm.skipop)
	c:RegisterEffect(e4)
end
function cm.remfilter(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN,REASON_COST)
end
function cm.typefilter(c)
	if c:GetType()&(TYPE_SPELL+TYPE_TRAP)~=0 then
		return c:GetType()&(TYPE_SPELL+TYPE_TRAP)
	elseif c:GetType()&(TYPE_NORMAL+TYPE_RITUAL+TYPE_FUSION+TYPE_XYZ+TYPE_SYNCHRO+TYPE_LINK)~=0 then
		return c:GetType()&(TYPE_NORMAL+TYPE_RITUAL+TYPE_FUSION+TYPE_XYZ+TYPE_SYNCHRO+TYPE_LINK)
	else
		return TYPE_EFFECT
	end
end
function cm.typefilter1(c,tc)
	return cm.typefilter(c)==cm.typefilter(tc)
end
function cm.gfilter(g)
	return g:GetClassCount(cm.typefilter)==#g
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.remfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	local sg=Group.CreateGroup()
	if g:GetClassCount(cm.typefilter)>=9 then
		for i=1,7 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			if tc then
				sg:AddCard(tc)
				g:Remove(cm.typefilter1,nil,tc)
			end
		end
		Duel.Remove(sg,POS_FACEDOWN,REASON_COST)
	else
		Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainDisablable(ev) and Duel.GetFlagEffect(tp,m)==0
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.NegateEffect(ev)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.rvfilter(c)
	return not c:IsPublic() and c:IsCode(83764718)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rvfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rg=Duel.SelectMatchingCard(tp,cm.rvfilter,tp,LOCATION_HAND,0,1,nil)
	Duel.ConfirmCards(1-tp,rc)
end
function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.HintSelection(tc)
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.skipcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.remfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	if chk==0 then return c:IsAbleToRemove(tp,POS_FACEDOWN,REASON_COST) and g:GetClassCount(cm.typefilter)>=9 end
	local sg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	for i=1,9 do
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	   local tc=g:Select(tp,1,1,nil):GetFirst()
	   if tc then
		   sg:AddCard(tc)
		   g:Remove(cm.typefilter1,nil,tc)
	   end
	end
	sg:AddCard(c)
	Duel.Remove(sg,POS_FACEDOWN,REASON_COST)
end
function cm.skiptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN) end
end
function cm.skipop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end