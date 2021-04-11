--圣夜魔女·玛姬纱
function c72411410.initial_effect(c)
	aux.AddCodeList(c,72411270,72411290,72411400,72411420,72411430)
		--xyz summon
	aux.AddXyzProcedure(c,nil,5,2,c72411410.ovfilter,aux.Stringid(72411410,0),3,c72411410.xyzop)
	c:EnableReviveLimit()
	--boost
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72411410,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c72411410.cost1)
	e1:SetTarget(c72411410.sptg1)
	e1:SetOperation(c72411410.op1)
	c:RegisterEffect(e1)
	--search def
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72411410,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,72411410)
	e2:SetTarget(c72411410.target1)
	e2:SetOperation(c72411410.operation1)
	c:RegisterEffect(e2)
end
function c72411410.ovfilter(c)
	return c:IsFaceup() and c:GetRank()==4 and c:IsRace(RACE_SPELLCASTER)
end
function c72411410.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,72411410)==0 end
	Duel.RegisterFlagEffect(tp,72411410,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c72411410.defilter1(c)
	return c:IsCode(72411270) and c:IsFaceup()
end
function c72411410.tffilter(c,tp)
	return c:IsOriginalCodeRule(72411270) and not c:IsType(TYPE_FIELD+TYPE_MONSTER) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c72411410.tfffilter(c,tp)
	return c:IsOriginalCodeRule(72411290,72411400,72411420,72411430) and not c:IsType(TYPE_FIELD+TYPE_MONSTER) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end

function c72411410.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c72411410.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local m1=Duel.GetMatchingGroupCount(c72411410.defilter1,tp,LOCATION_ONFIELD,0,nil)
	local m2=Duel.GetMatchingGroupCount(c72411410.tffilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local m3=Duel.GetMatchingGroupCount(c72411410.tfffilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if chk==0 then return ((m1==0 and m2~=0) or (m1~=0 and m3~=0)) end
	if m1~=0 then
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	end
end
function c72411410.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c72411410.defilter1,tp,LOCATION_ONFIELD,0,nil)
	local ng1=Duel.GetMatchingGroup(c72411410.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
	if ct==0 and ng1:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c72411410.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
	local ng2=Duel.GetMatchingGroup(c72411410.tfffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
	if ct>=1 and ng2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=-1 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,c72411410.defilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
		if Duel.Destroy(dg,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local tc2=Duel.SelectMatchingCard(tp,c72411410.tfffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
			if tc2 then
				Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
		end
	end
end
function c72411410.filter1(c,tp)
	return c:IsCode(72411270) and c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0
end
function c72411410.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c72411410.filter1,tp,LOCATION_ONFIELD,0,1,nil,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c72411410.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c72411410.filter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsFaceup() and c:IsType(TYPE_XYZ) and Duel.SelectYesNo(tp,aux.Stringid(72411410,1)) then
			Duel.Overlay(c,g)
		end
	end
end