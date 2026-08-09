local m=31400188
local cm=_G["c"..m]
cm.name="恐龙世界连接"
if not cm.hack then
	cm.hack=true
	cm._GetLinkMaterials=aux.GetLinkMaterials
	aux.GetLinkMaterials=function(tp,f,lc,e)
		local mg=Duel.GetMatchingGroup(aux.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc,e)
		local mg2=Duel.GetMatchingGroup(aux.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE+LOCATION_DECK,LOCATION_ONFIELD,nil,f,lc,tp)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
		return mg
	end 
	cm._LExtraMaterialCount=aux.LExtraMaterialCount
	aux.LExtraMaterialCount=function(mg,lc,tp)
		local cg=Group.CreateGroup()
		local ce=nil
		for tc in Auxiliary.Next(mg) do
			local le={tc:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
			for _,te in pairs(le) do
				local sg=mg:Filter(Auxiliary.TRUE,tc)
				local f=te:GetValue()
				local related,valid=f(te,lc,sg,tc,tp)
				if related and valid then
					if te:GetHandler():IsCode(m) then
						cg:AddCard(tc)
						ce=te
					else
						te:UseCountLimit(tp)
					end
				end
			end
		end
		if #cg>0 then
			ce:UseCountLimit(ce:GetHandlerPlayer())
			Duel.Hint(HINT_CARD,0,m)
			Duel.ConfirmCards(1-cg:GetFirst():GetControler(),cg)
		end
	end
end
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_DECK)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_DECK,0)
	e2:SetCountLimit(1,m)
	e2:SetValue(cm.matval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetValue(LOCATION_HAND)
	e3:SetTarget(cm.thtg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.costfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsCode(90173539) and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetActivateEffect():IsActivatable(tp,true,true) end
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
	end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_FZONE,POS_FACEUP,true)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local te=tc:GetActivateEffect()
	Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
end
function cm.mfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function cm.exmfilter(c,tc)
	return c:IsLocation(LOCATION_DECK) and c:IsCode(tc:GetCode())
end
function cm.matval(e,lc,mg,c,tp)
	if not lc:IsSetCard(0x11a) then return false,nil end
	return c:IsAbleToHand(),not mg or mg:IsExists(cm.mfilter,1,nil,tp) and not mg:IsExists(cm.exmfilter,1,nil,c)
end
function cm.thtg(e,c)
	return c:IsLocation(LOCATION_DECK) and c:IsReason(REASON_LINK) and c:IsControler(e:GetHandlerPlayer())
end
function cm.chkfilter1(c,e,tp)
	return c:IsSetCard(0x11a) and c:IsType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_REVIVE_LIMIT) and Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP_ATTACK,tp,c) and Duel.IsExistingMatchingCard(cm.chkfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function cm.chkfilter2(c,e,tp,cd)
	return c:IsSetCard(0x11a) and c:IsType(TYPE_MONSTER) and not c:IsCode(cd) and not c:IsHasEffect(EFFECT_REVIVE_LIMIT) and Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP_ATTACK,1-tp,c)
end
function cm.filter1(c,e,tp)
	return c:IsSetCard(0x11a) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function cm.filter2(c,e,tp,cd)
	return c:IsSetCard(0x11a) and c:IsType(TYPE_MONSTER) and not c:IsCode(cd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>-Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0) and Duel.IsExistingMatchingCard(cm.chkfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	if sg:GetCount()>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		local g1=sg:Select(tp,1,1,nil)
		local tc1=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local g2=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc1:GetCode())
		local tc2=g2:GetFirst()
		Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		Duel.SpecialSummon(tc2,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
	end
end