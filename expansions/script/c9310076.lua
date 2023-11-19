--热炎融合异种 单调慈鲷
function c9310076.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_FIRE),aux.FilterBoolFunction(Card.IsRace,RACE_FISH),true)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9310076,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9310076)
	e1:SetTarget(c9310076.sptg)
	e1:SetOperation(c9310076.spop)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(c9310076.tnval)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9310076,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,9311076)
	e3:SetOperation(c9310076.tgop)
	c:RegisterEffect(e3)
end
function c9310076.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (re:IsActiveType(TYPE_SPELL)
		or e:GetHandler():GetFlagEffect(33332257)~=0)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_MONSTER,OPCODE_ISTYPE,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c9310076.spfilter(c,e,tp,ac)
	return c:IsCode(ac) and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false)
end
function c9310076.spfilter1(c,e,tp,ac)
	return c:IsCode(ac) and c:GetOwner()==tp and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false)
end
function c9310076.spfilter2(c,e,tp,ac)
	return c:IsCode(ac) and c:GetOwner()==1-tp and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false)
end
function c9310076.cfilter(c,g,mc)
	return g:CheckSubGroup(c9310076.mtfilter,1,#g,mc,c)
end
function c9310076.mtfilter(g,mc,c)
	local sg=g:Clone()
	sg:AddCard(mc)
	return sg:GetSum(Card.GetSynchroLevel,c)==c:GetLevel() and c:IsSynchroSummonable(nil,sg)
			and c:IsType(TYPE_TUNER)
end
function c9310076.spop(e,tp,eg,ep,ev,re,r,rp)
	local kc=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local sg=Duel.GetMatchingGroup(c9310076.spfilter,tp,0,LOCATION_HAND,nil,e,tp,ac)
	local sg1=Duel.GetMatchingGroup(c9310076.spfilter1,tp,0,LOCATION_HAND,nil,e,tp,ac)
	local sg2=Duel.GetMatchingGroup(c9310076.spfilter2,tp,0,LOCATION_HAND,nil,e,tp,ac)
	Duel.ConfirmCards(tp,hg)
	if g:GetCount()>0 then
		local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
		if ft1<=0 and ft2<=0 then return end
		if ft1>0 and ft2>0 and sg:GetCount()>0 then  
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local sc=sg:Select(1-tp,1,1,nil):GetFirst()
			Duel.SpecialSummon(sc,0,1-tp,sc:GetOwner(),false,false,POS_FACEUP)
		elseif ft1>0 and ft2<=0 and sg1:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local oc=sg1:Select(1-tp,1,1,nil):GetFirst()
			Duel.SpecialSummon(oc,0,1-tp,oc:GetOwner(),false,false,POS_FACEUP)
		elseif ft1<=0 and ft2>0 and sg2:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local tc=sg2:Select(1-tp,1,1,nil):GetFirst()
			Duel.SpecialSummon(tc,0,1-tp,tc:GetOwner(),false,false,POS_FACEUP)
		end
	else
		local dg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_MZONE,0,kc)
		local kg=Duel.GetMatchingGroup(c9310076.cfilter,tp,LOCATION_EXTRA,0,nil,dg,kc)
		if kg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9310076,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local dc=kg:Select(tp,1,1,nil):GetFirst()
				local dg1=dg:SelectSubGroup(tp,c9310076.mtfilter,false,1,#dg,kc,dc)
				dg1:Merge(Group.FromCards(kc))
				dc:SetMaterial(dg1)
				Duel.SynchroSummon(tp,dc,nil,dg1)
				dc:CompleteProcedure()	
		end
	end
	Duel.ShuffleHand(1-tp)
end
function c9310076.tnval(e,c)
	return e:GetHandler():IsDefensePos()
end
function c9310076.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE)
			and c:IsRace(RACE_FISH) and c:IsLevelBelow(4) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c9310076.tgop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetCondition(c9310076.thcon)
	e1:SetOperation(c9310076.operation)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9310076.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9310076.tgfilter,tp,LOCATION_DECK,0,1,nil)
end
function c9310076.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c9310076.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end