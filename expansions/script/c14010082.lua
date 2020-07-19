--鱼自·我
local m=14010082
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.sprcon)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.spcon)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.sprcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and (not Duel.IsExistingMatchingCard(aux.TRUE,c:GetControler(),LOCATION_GRAVE,0,1,nil) or not Duel.IsExistingMatchingCard(aux.TRUE,1-c:GetControler(),LOCATION_GRAVE,0,1,nil))
end
function cm.spcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==1
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_FISH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,c:GetOwner(),LOCATION_GRAVE,0,nil)
		local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,1-tp,LOCATION_GRAVE,0,nil)
		local b1=g1:GetCount()>0
		local b2=g2:GetCount()>0
		if b1 or b2 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			local sel=0
			if b1 and b2 then
				if c:GetOwner()==1-tp then
					Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
				else
					Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPTION)
					sel=Duel.SelectOption(1-tp,aux.Stringid(m,0),aux.Stringid(m,1))+1
					if sel==1 then
						Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
					elseif sel==2 then
						Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
					end
				end
			elseif b1 then
				Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
			elseif b2 then
				Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
			end
		end
	end
end