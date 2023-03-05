--赋型镜·影镜
local m=11630204
local cm=_G["c"..m]
function c11630204.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
end
cm.SetCard_xxj_Mirror=true
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) or Duel.IsPlayerCanSpecialSummon(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_MONSTER,OPCODE_ISTYPE}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.spfilter2(c,e,tp,ac)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and not c:IsCode(ac)
end
function cm.cfilter(c,tc,ac)
	return c:IsCode(ac) and (not c:IsRace(tc:GetRace()) or not c:IsAttribute(tc:GetAttribute()) or not c:IsLevel(tc:GetLevel()) )
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,ac)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.ConfirmCards(1-tp,g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(ac)
		tc:RegisterEffect(e1)
		--
		if Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,tc,ac) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			local cg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,tc,ac)
			if cg:GetCount()==0 then return end
			Duel.ConfirmCards(1-tp,cg)
			local ec=cg:GetFirst()
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_RACE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(ec:GetRace())
			tc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e3:SetValue(ec:GetAttribute())
			tc:RegisterEffect(e3)
			local e4=e2:Clone()
			e4:SetCode(EFFECT_CHANGE_LEVEL)
			e4:SetValue(ec:GetLevel())
			tc:RegisterEffect(e4)
		end
	end
end
