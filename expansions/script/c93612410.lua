--装弹枪管处刑龙
function c93612410.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(93612410,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,93612410)
	e1:SetCondition(c93612410.spcon)
	e1:SetTarget(c93612410.sptg)
	e1:SetOperation(c93612410.spop)
	c:RegisterEffect(e1)
end
function c93612410.cfilter(c)
	return c:GetSequence()<5
end
function c93612410.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c93612410.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c93612410.spfilter(c,e,tp)
	return c:IsSetCard(0x102) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c93612410.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c93612410.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c93612410.spop(e,tp,eg,ep,ev,re,r,rp)
	local fc1=Duel.GetFieldCard(tp,LOCATION_MZONE,0)
	local fc2=Duel.GetFieldCard(tp,LOCATION_MZONE,4)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) or fc1 or fc2 then return end
	local zone=bit.bor(1,16)
	local c=e:GetHandler()
	if zone==0 or not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c93612410.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,c,e,tp)
	if g:GetCount()>0 then
		g:AddCard(c)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)>1 then
			if not aux.PendulumChecklist then
				aux.PendulumChecklist=0
				local ge1=Effect.GlobalEffect()
				ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
				ge1:SetOperation(aux.PendulumReset)
				Duel.RegisterEffect(ge1,0)
			end
			local tc1=g:GetFirst()
			local tc2=g:GetNext()
			if tc1:GetSequence()~=0 then tc1,tc2=tc2,tc1 end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(1163)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SPSUMMON_PROC_G)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetLabelObject(tc2)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCondition(c93612410.pendcon)
			e1:SetOperation(c93612410.pendop)
			e1:SetValue(SUMMON_TYPE_PENDULUM)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc1:RegisterEffect(e1)
			tc1:RegisterFlagEffect(93612410,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,tc2:GetFieldID())
			tc2:RegisterFlagEffect(93612410,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,tc1:GetFieldID())
		end
	end
end
function c93612410.PConditionFilter(c,e,tp,lscale,rscale,eset)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local bool=aux.PendulumSummonableBool(c)
	return c:IsSetCard(0x102) and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)
		and not c:IsForbidden()
		and (aux.PendulumChecklist&(0x1<<tp)==0 or aux.PConditionExtraFilter(c,e,tp,lscale,rscale,eset))
end
function c93612410.pendcon(e,c,og)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	if aux.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
	local rpz=e:GetLabelObject()
	if rpz==nil or rpz:GetFieldID()~=c:GetFlagEffectLabel(93612410) then return false end
	local lscale=c:GetLevel()
	local rscale=rpz:GetLevel()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if og then
		return og:IsExists(c93612410.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
	else
		return Duel.IsExistingMatchingCard(c93612410.PConditionFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,lscale,rscale,eset)
	end
end
function c93612410.pendop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local tp=e:GetHandlerPlayer()
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	local rpz=e:GetLabelObject()
	local lscale=c:GetLevel()
	local rscale=rpz:GetLevel()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local tg=nil
	if og then
		tg=og:Filter(Card.IsLocation,nil,LOCATION_GRAVE|LOCATION_HAND):Filter(c93612410.PConditionFilter,nil,e,tp,lscale,rscale,eset)
	else
		tg=Duel.GetMatchingGroup(c93612410.PConditionFilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp,lscale,rscale,eset)
	end
	local ce=nil
	local b1=aux.PendulumChecklist&(0x1<<tp)==0
	local b2=#eset>0
	if b1 and b2 then
		local options={1163}
		for _,te in ipairs(eset) do
			table.insert(options,te:GetDescription())
		end
		local op=Duel.SelectOption(tp,table.unpack(options))
		if op>0 then
			ce=eset[op]
		end
	elseif b2 and not b1 then
		local options={}
		for _,te in ipairs(eset) do
			table.insert(options,te:GetDescription())
		end
		local op=Duel.SelectOption(tp,table.unpack(options))
		ce=eset[op+1]
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:FilterSelect(tp,aux.PConditionExtraFilterSpecific,0,ft,nil,e,tp,lscale,rscale,ce)
	if #g==0 then return end
	if ce then
		Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
		ce:Reset()
	else
		aux.PendulumChecklist=aux.PendulumChecklist|(0x1<<tp)
	end
	Duel.Hint(HINT_CARD,0,93612410)
	sg:Merge(g)
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
end
