--神影依 亚舍拉
function c98920003.initial_effect(c)
		--fusion material
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c98920003.FShaddollCondition())
	e1:SetOperation(c98920003.FShaddollOperation())
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c98920003.splimit)
	c:RegisterEffect(e2)  
  --summon success
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920003,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,98920003)
	e3:SetTarget(c98920003.sptg)
	e3:SetOperation(c98920003.spop)
	c:RegisterEffect(e3)  
   --change position
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)   
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c98920003.poscon)
	e4:SetTarget(c98920003.postg)
	e4:SetOperation(c98920003.posop)
	c:RegisterEffect(e4)  
  --to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98920003,1))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,98930003)
	e5:SetTarget(c98920003.thtg)
	e5:SetOperation(c98920003.thop)
	c:RegisterEffect(e5)
end
function c98920003.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c98920003.FShaddollFilter(c,fc)
	return c:IsFusionSetCard(0x9d) and c:IsCanBeFusionMaterial(fc)
end
function c98920003.FShaddollExFilter(c,fc,fe)
	return c:IsFaceup() and not c:IsImmuneToEffect(fe) and c98920003.FShaddollFilter(c,fc)
end
function c98920003.FShaddollFilter1(c,g)
	return c:IsFusionSetCard(0x9d) and g:IsExists(c98920003.FShaddollFilter2,1,c) and not g:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute())
end
function c98920003.FShaddollFilter2(c)
	return c:IsFusionSetCard(0x9d)
end
function c98920003.FShaddollSpFilter1(c,fc,tp,mg,exg,chkf)
	return mg:IsExists(c98920003.FShaddollSpFilter2,1,c,fc,tp,c,chkf)
		or (exg and exg:IsExists(c98920003.FShaddollSpFilter2,1,c,fc,tp,c,chkf))
end
function c98920003.FShaddollSpFilter2(c,fc,tp,mc,chkf)
	local sg=Group.FromCards(c,mc)
	if sg:IsExists(aux.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then return false end
	if not aux.MustMaterialCheck(sg,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,sg,fc)
		or aux.FGoalCheckAdditional and not aux.FGoalCheckAdditional(tp,sg,fc) then return false end
	return ((c98920003.FShaddollFilter1(c,sg) and c98920003.FShaddollFilter2(mc))
		or (c98920003.FShaddollFilter1(mc,sg) and c98920003.FShaddollFilter2(c)))
		and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
end
function c98920003.FShaddollCondition()
	return  function(e,g,gc,chkf)
			if g==nil then return aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
			local c=e:GetHandler()
			local mg=g:Filter(c98920003.FShaddollFilter,nil,c)
			local tp=e:GetHandlerPlayer()
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			local exg=nil
			if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
				local fe=fc:IsHasEffect(81788994)
				exg=Duel.GetMatchingGroup(c98920003.FShaddollExFilter,tp,0,LOCATION_MZONE,mg,c,fe)
			end
			if gc then
				if not mg:IsContains(gc) then return false end
				return c98920003.FShaddollSpFilter1(gc,c,tp,mg,exg,chkf)
			end
			return mg:IsExists(c98920003.FShaddollSpFilter1,1,nil,c,tp,mg,exg,chkf)
		end
end
function c98920003.FShaddollOperation()
	return  function(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
			local c=e:GetHandler()
			local mg=eg:Filter(c98920003.FShaddollFilter,nil,c)
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			local exg=nil
			if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
				local fe=fc:IsHasEffect(81788994)
				exg=Duel.GetMatchingGroup(c98920003.FShaddollExFilter,tp,0,LOCATION_MZONE,mg,c,fe)
			end
			local g=nil
			if gc then
				g=Group.FromCards(gc)
				mg:RemoveCard(gc)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				g=mg:FilterSelect(tp,c98920003.FShaddollSpFilter1,1,1,nil,c,tp,mg,exg,chkf)
				mg:Sub(g)
			end
			if exg and exg:IsExists(c98920003.FShaddollSpFilter2,1,nil,c,tp,g:GetFirst(),chkf)
				and (mg:GetCount()==0 or (exg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81788994,0)))) then
				fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=exg:FilterSelect(tp,c98920003.FShaddollSpFilter2,1,1,nil,c,tp,g:GetFirst(),chkf)
				g:Merge(sg)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=mg:FilterSelect(tp,c98920003.FShaddollSpFilter2,1,1,nil,c,tp,g:GetFirst(),chkf)
				g:Merge(sg)
			end
			Duel.SetFusionMaterial(g)
		end
end
function c98920003.filter(c,e,tp)
	return c:IsSetCard(0x9d) and not c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920003.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c98920003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920003.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920003.posfilter(c)
	return c:IsAttackPos() or c:IsFacedown()
end
function c98920003.poscon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c98920003.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920003.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c98920003.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98920003.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
end
function c98920003.thfilter(c)
	return c:IsSetCard(0x9d) and c:IsAbleToHand()
end
function c98920003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920003.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c98920003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920003.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():IsLocation(LOCATION_HAND) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		end
	end
end