--悠悠的无限增殖
local m=79630045
local set=0x183
local cm=_G["c"..m]
function cm.initial_effect(c)
	--魔陷发动
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.acttg)
	e1:SetOperation(cm.actop)
	c:RegisterEffect(e1)
end
--魔陷发动
function cm.spdeckfilter(c,e,tp)
	return c:IsSetCard(set) and c:IsType(TYPE_NORMAL)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.togravefilter(c)
	return c:IsSetCard(set) and c:IsAbleToGraveAsCost()
end
function cm.onlyempty(tp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if g:GetCount()==0 then return true end
	for tc in aux.Next(g) do
		if not tc:IsType(TYPE_NORMAL) then
			return false
		end
	end
	return true
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
			and Duel.IsExistingMatchingCard(cm.spdeckfilter,tp,LOCATION_DECK,0,2,nil,e,tp)
		local b2=Duel.IsExistingMatchingCard(cm.togravefilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		return b1 or b2
	end
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
		and Duel.IsExistingMatchingCard(cm.spdeckfilter,tp,LOCATION_DECK,0,2,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(cm.togravefilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
	if not b1 and not b2 then return end
	local op
	if b1 and b2 then
		if cm.onlyempty(tp) then
			op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,0),aux.Stringid(m,1))
		else
			op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
		end
	elseif b1 then
		op=0
	else
		op=1
	end
	--同时发动两个效果
	if b1 and b2 and cm.onlyempty(tp) and op==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.spdeckfilter,tp,LOCATION_DECK,0,2,2,nil,e,tp)
			if #g>0 then
				for tc in aux.Next(g) do
					Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				end
				Duel.SpecialSummonComplete()
			end
		end
		if Duel.IsExistingMatchingCard(cm.togravefilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(tp,cm.togravefilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
			if #sg>0 and Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
				Duel.BreakEffect()
				Duel.Draw(tp,2,REASON_EFFECT)
			end
		end
	elseif ( (not (b1 and b2 and cm.onlyempty(tp))) and op==0 ) or (b1 and b2 and cm.onlyempty(tp) and op==1) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.spdeckfilter,tp,LOCATION_DECK,0,2,2,nil,e,tp)
			if #g>0 then
				for tc in aux.Next(g) do
					Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				end
				Duel.SpecialSummonComplete()
			end
		end
	else
		if Duel.IsExistingMatchingCard(cm.togravefilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(tp,cm.togravefilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
			if #sg>0 and Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
				Duel.BreakEffect()
				Duel.Draw(tp,2,REASON_EFFECT)
			end
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	if not c then return false end
	return not (c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT))
end