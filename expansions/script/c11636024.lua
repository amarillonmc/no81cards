--渊洋打捞
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)  
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.postg)  
	e2:SetOperation(s.posop)
	c:RegisterEffect(e2)
end
function s.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6223) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetHandler())
	if #g>0 then
		local tc=g:GetFirst()
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.ovfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,tc,e)
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 
			and #mg>0 and Duel.CheckLPCost(tp,2000)and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.PayLPCost(tp,2000)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local xg=mg:Select(tp,2,2,nil)
			local tc1=xg:GetFirst()
			while tc1 do
				tc1:CancelToGrave()
				local og=tc1:GetOverlayGroup()
				if #og>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				tc1=xg:GetNext()
			end
			Duel.Overlay(tc,xg)
		end
	end
end

function s.ovfilter(c)
	return c:IsFaceup() and c:IsCanOverlay() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3223) 
end
function s.posfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6223) and c:IsCanTurnSet()
end
function s.posfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x223) and c:IsCanChangePosition()
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.posfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,s.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 then
		local tg=Duel.GetMatchingGroup(s.posfilter2,tp,LOCATION_MZONE,0,nil)
		if Duel.CheckLPCost(tp,1000)and Duel.SelectYesNo(tp,aux.Stringid(id,2))then
		Duel.PayLPCost(tp,1000)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local g=Duel.SelectMatchingCard(tp,s.posfilter2,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.HintSelection(g)
			Duel.ChangePosition(g,POS_FACEUP_ATTACK)
		end
	end
end