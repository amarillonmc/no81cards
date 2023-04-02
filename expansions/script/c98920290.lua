--水晶机巧-顶点黄玉
function c98920290.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
 --synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920290,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920290)
	e1:SetCondition(c98920290.sycon)
	e1:SetTarget(c98920290.sytg)
	e1:SetOperation(c98920290.syop)
	c:RegisterEffect(e1)
--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,98930290)
	e3:SetCondition(c98920290.spcon)
	e3:SetTarget(c98920290.sptg)
	e3:SetOperation(c98920290.spop)
	c:RegisterEffect(e3)
end
function c98920290.sycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c98920290.syfilter(c)
	return c:IsSynchroSummonable(nil)
end
function c98920290.sytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920290.syfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920290.syop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98920290.syfilter,tp,LOCATION_EXTRA,0,nil,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local mg=aux.GetSynMaterials(tp,sg:GetFirst())
		for tc in aux.Next(mg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetTarget(c98920290.syntg)
			e1:SetValue(1)
			e1:SetOperation(c98920290.synop)
			tc:RegisterEffect(e1)
		end
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end
function c98920290.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te and aux.GetValueType(te)=="Effect" then te:Reset() end
	e:Reset()
end
function c98920290.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
	g:AddCard(c)
	local ct=g:GetCount()
	local res=c98920290.syngoal(g,tp,lv,syncard,minc,ct) or (ct<maxc and mg:IsExists(c98920290.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
	g:RemoveCard(c)
	return res
end
function c98920290.syngoal(g,tp,lv,syncard,minc,ct)
	return ct>=minc and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard) and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
end
function c98920290.syntg(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() then return false end
	local g=Group.FromCards(c)
	local mg=aux.GetSynMaterials(tp,syncard):Filter(f,nil,syncard)
	return mg:IsExists(c98920290.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function c98920290.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=aux.GetSynMaterials(tp,syncard):Filter(f,nil,syncard)
	for i=1,maxc do
		local cg=mg:Filter(c98920290.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
		if #cg==0 then break end
		local minct=1
		if c98920290.syngoal(g,tp,lv,syncard,minc,i) then
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=cg:Select(tp,minct,1,nil)
		if #sg==0 then break end
		g:Merge(sg)
	end
	Duel.SetSynchroMaterial(g)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		local fid=c:GetFieldID()
		local og=Duel.GetOperatedGroup()
		for oc in aux.Next(og) do
			oc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		end
	end
end
function c98920290.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c98920290.spfilter(c,e,tp)
	return c:IsSetCard(0xea) and not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c98920290.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920290.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920290.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920290.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		fid=g:GetFirst():GetFieldID()
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c98920290.ftarget)
	e2:SetLabel(fid)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c98920290.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end