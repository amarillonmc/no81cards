--坚 毅 的 人 偶 ·奥 契 丝
local m=22348177
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,22348157)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22348177.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348177,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c22348177.imcost)
	e3:SetTarget(c22348177.imtg)
	e3:SetOperation(c22348177.imop)
	c:RegisterEffect(e3)
end
function c22348177.lvtg(e,c)
	return c:IsLevelAbove(1) and c:IsCode(22348165)
end
function c22348177.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 6
	else return lv end
end
function c22348177.indcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c22348177.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22348177.imfilter(c)
	return aux.IsCodeListed(c,22348157) and c:IsFaceup()
end
function c22348177.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c22348177.imfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) and Duel.GetFlagEffect(tp,22348177)==0
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22348177.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,22349177)==0
	if chk==0 then return b1 or b2 end
	if b2 and not b1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
	end
end
function c22348177.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c22348177.spfilter(c,e,tp)
	return c:IsCode(22348157) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348177.recfilter(c)
	return c:IsFaceup() and c:IsCode(22348157)
end
function c22348177.imop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c22348177.imfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) and Duel.GetFlagEffect(tp,22348177)==0
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22348177.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,22349177)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(22348177,1),aux.Stringid(22348177,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(22348177,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(22348177,2))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
			local g1=Duel.GetMatchingGroup(c22348177.imfilter,tp,LOCATION_ONFIELD,0,nil)
			local tc=g1:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
				e1:SetValue(c22348177.efilter)
				tc:RegisterEffect(e1)
				tc=g1:GetNext()
			end
		end
		Duel.RegisterFlagEffect(tp,22348177,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348177.spfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local ct=Duel.GetMatchingGroupCount(c22348177.recfilter,p,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			if ct>0 then
				Duel.BreakEffect()
			Duel.Recover(tp,ct*800,REASON_EFFECT)
			end
		end
		Duel.RegisterFlagEffect(tp,22349177,RESET_PHASE+PHASE_END,0,1)
	end
end
