--救世之章 夜语
local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	if not s.global_check then
		local _SelectSynchroMaterial=Duel.SelectSynchroMaterial
		function Duel.SelectSynchroMaterial(p,sc,f1,f2,min,max,smat,mg)
			if mg and #mg==min+1 then return mg end
			if not smat then smat=nil end
			if not mg then mg=nil end
			return _SelectSynchroMaterial(p,sc,f1,f2,min,max,smat,mg)
		end
		local _SelectTunerMaterial=Duel.SelectTunerMaterial
		function Duel.SelectTunerMaterial(p,sc,tuner,f1,f2,min,max,mg)
			if mg and #mg==min+1 then return mg end
			if not mg then mg=nil end
			return _SelectTunerMaterial(p,sc,tuner,f1,f2,min,max,mg)
		end
	end
end
function s.synfilter(c,mg)
	return c:IsRace(RACE_SPELLCASTER) and c:IsSynchroSummonable(nil,mg,1,1)
end
function s.spfilter(c,ec)
	local mg=Group.FromCards(c,ec)
	return c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsLevelAbove(1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	if lv>0 then
		local tt={Duel.TossDice(tp,lv)}
		local num=0
		for _,v in pairs(tt) do
			num=num+v
		end
		Duel.ConfirmDecktop(tp,num)
		local g=Duel.GetDecktopGroup(tp,num)
		local mg=g:Filter(s.spfilter,nil,c)
		if c:IsRelateToChain(0) and c:IsFaceup() and c:IsControler(tp) and mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local mc=mg:Select(tp,1,1,nil):GetFirst()
			local mg=Group.FromCards(c,mc)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(tp,s.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg):GetFirst()
			Duel.SynchroSummon(tp,sc,nil,mg,1,1)
		end
	end
end