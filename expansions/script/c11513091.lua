--百夫骑兵·起誓
local m=11513091
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro custom
	--special summon and synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11513091,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,11513091)
	e2:SetCondition(c11513091.spcon)
	e2:SetTarget(c11513091.sptg)
	e2:SetOperation(c11513091.spop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,11514091)
	e3:SetCondition(c11513091.stcon)
	e3:SetTarget(c11513091.sttg)
	e3:SetOperation(c11513091.stop)
	c:RegisterEffect(e3)
	--spsummon from szone
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,11516091)
	e4:SetHintTiming(0,TIMING_MAIN_END)
	e4:SetCondition(c11513091.spcon2)
	e4:SetTarget(c11513091.sptg2)
	e4:SetOperation(c11513091.spop2)
	c:RegisterEffect(e4)
	--synchro level
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_HAND)
	e7:SetValue(1)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_HAND,0)
	--e6:SetTarget(c11513091.eftg)
	e6:SetLabelObject(e7)
	c:RegisterEffect(e6)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_TUNER_MATERIAL_LIMIT)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetTarget(c11513091.synlimit2)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(LOCATION_HAND,0)
	e9:SetLabelObject(e8)
	c:RegisterEffect(e9)
end

function c11513091.synlimit2(e,c)
	return c:IsLocation(LOCATION_MZONE) and c:IsOriginalCodeRule(11513091)
end
function c11513091.syncon(e)
	return e:GetHandler():IsLocation(LOCATION_MZONE)
end
function c11513091.syntfilter(e,c)
	return c:IsSynchroType(TYPE_TUNER)
end
function c11513091.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

function c11513091.syncfilter(c)
	return c:IsSetCard(0x1a2) and c:IsSynchroSummonable(nil)
end
function c11513091.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11513091.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c11513091.syncfilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11513091,0)) then
		local g=Duel.GetMatchingGroup(c11513091.syncfilter,tp,LOCATION_EXTRA,0,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11513091.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c11513091.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(11513091)
end
function c11513091.stcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c11513091.stfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c11513091.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11513091.stfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c11513091.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11513091.stfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
function c11513091.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c11513091.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11513091,0x1a2,TYPE_MONSTER+TYPE_EFFECT,3000,2000,8,RACE_MACHINE,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11513091.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~0 and c:IsFaceup() and c:IsLevelAbove(5) and Duel.SelectYesNo(tp,aux.Stringid(11513091,1)) and not c:IsImmuneToEffect(e) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(-4)
	c:RegisterEffect(e1)
	end
end


function c11513091.synfilter(c,syncard,tuner,f)
	return c:IsFaceupEx() --and c:IsCanBeSynchroMaterial(syncard,tuner)
 and (f==nil or f(c,syncard))
end
function c11513091.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
	g:AddCard(c)
	local ct=g:GetCount()
	local res=c11513091.syngoal(g,tp,lv,syncard,minc,ct)
		or (ct<maxc and mg:IsExists(c11513091.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
	g:RemoveCard(c)
	return res
end
function c11513091.syngoal(g,tp,lv,syncard,minc,ct)
	return ct>=minc
		and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
		and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
		and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<=1
		and aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL)
end
function c11513091.syntg(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() then return false end
	local g=Group.FromCards(c)
	local mg=Duel.GetSynchroMaterial(tp):Filter(c11513091.synfilter,c,syncard,c,f)
	local exg=Duel.GetMatchingGroup(c11513091.synfilter,tp,LOCATION_HAND,0,c,syncard,c,f)
	mg:Merge(exg)




	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetValue(s.matval)
	c:RegisterEffect(e1)







	return mg:IsExists(c11513091.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function c11513091.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=Duel.GetSynchroMaterial(tp):Filter(c11513091.synfilter,c,syncard,c,f)
	local exg=Duel.GetMatchingGroup(c11513091.synfilter,tp,LOCATION_HAND,0,c,syncard,c,f)
	mg:Merge(exg)
	for i=1,maxc do
		local cg=mg:Filter(c11513091.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if c11513091.syngoal(g,tp,lv,syncard,minc,i) then
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=cg:Select(tp,minct,1,nil)
		if sg:GetCount()==0 then break end
		g:Merge(sg)
	end
	Duel.SetSynchroMaterial(g)
end

