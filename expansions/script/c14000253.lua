--四象荒神仪
local m=14000253
local cm=_G["c"..m]
cm.named_with_war=1
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--effct flag
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetCode(EVENT_TO_GRAVE)
	e10:SetRange(1)
	e10:SetOperation(cm.reop)
	c:RegisterEffect(e10)
end
function cm.war(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_war
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	if re and cm.war(re:GetHandler()) then
		local tc=eg:GetFirst()
		while tc do
			if tc and tc:IsLocation(LOCATION_GRAVE) and tc:IsType(TYPE_MONSTER) then
				tc:RegisterFlagEffect(14000241,RESET_EVENT+0x1fe0000,0,0,0)
			end
			tc=eg:GetNext()
		end
	end
end
function cm.tgfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.thfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.spfilter(c,e,tp)
	return cm.war(c) and bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function cm.spfilter1(c,e,tp)
	return cm.war(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsType(TYPE_RITUAL)
end
function cm.cfilter1(c,e,tp)
	return cm.war(c) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FUSION)
end
function cm.cfilter2(c,e,tp)
	return cm.war(c) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_SYNCHRO)
end
function cm.cfilter3(c,e,tp)
	return cm.war(c) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_XYZ)
end
function cm.cfilter4(c,e,tp)
	return cm.war(c) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_LINK)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a1=Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_MZONE,0,1,nil)
	local a2=Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_MZONE,0,1,nil)
	local a3=Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_MZONE,0,1,nil)
	local a4=Duel.IsExistingMatchingCard(cm.cfilter4,tp,LOCATION_MZONE,0,1,nil)
	if a1==false and a2==false and a3==false and a4==false then
		return 
	else
		if a1 then b1=Duel.IsExistingMatchingCard(cm.tgfilter,tp,0,LOCATION_ONFIELD,1,nil,e,tp) else b1=true end
		if a2 then b2=Duel.IsExistingMatchingCard(cm.thfilter,tp,0,LOCATION_ONFIELD,1,nil,e,tp) else b2=true end
		if a3 then b3=Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) else b3=true end
		if a4 then b4=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) else b4=true end
		if chk==0 then return b1 and b2 and b3 and b4 end
		if a1 then
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
		end
		if a2 then
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
		end
		if a3 then
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),tp,LOCATION_ONFIELD)
		end
		if a4 then
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
		end
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local a1=Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_MZONE,0,1,nil)
	local a2=Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_MZONE,0,1,nil)
	local a3=Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_MZONE,0,1,nil)
	local a4=Duel.IsExistingMatchingCard(cm.cfilter4,tp,LOCATION_MZONE,0,1,nil)
	if a1 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,0,LOCATION_ONFIELD,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,0,LOCATION_ONFIELD,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
	if a2 and Duel.IsExistingMatchingCard(cm.thfilter,tp,0,LOCATION_ONFIELD,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,0,LOCATION_ONFIELD,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
		end
	end
	if a3 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	if a4 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsAbleToGrave() and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.BreakEffect()
				Duel.SendtoGrave(tc,REASON_EFFECT)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
				local tc=g:GetFirst()
				if tc then
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
				end
			end
		end
	end
end