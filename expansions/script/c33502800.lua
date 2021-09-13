--魔女之旅·过往归章
function c33502800.initial_effect(c)
--
	aux.AddCodeList(c,33502800)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33502800.tg1)
	e1:SetOperation(c33502800.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33502800,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,33502800)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c33502800.cost2)
	e2:SetTarget(c33502800.tg2)
	e2:SetOperation(c33502800.op2)
	c:RegisterEffect(e2)
--
end
--
function c33502800.tfilter1_1(c,rc)
	return c:GetRitualLevel(rc)>=rc:GetLevel()
end
function c33502800.tfilter1_2(c)
	return aux.IsCodeListed(c,33502800) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGrave()
end
function c33502800.tfilter1(c,e,tp,mg)
	if bit.band(c:GetType(),0x81)~=0x81
		or not aux.IsCodeListed(c,33502800)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
--
	local lg=mg:Filter(Card.IsCanBeRitualMaterial,c,c)
	return mg:IsExists(c33502800.tfilter1_1,1,nil,c)
		or Duel.IsExistingMatchingCard(c33502800.tfilter1_2,tp,LOCATION_SZONE,0,1,nil)
end
function c33502800.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(c33502800.tfilter1,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetChainLimit(c33502800.dislimit)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c33502800.dislimit(e,ep,tp)
	return not (e:IsActiveType(TYPE_SPELL+TYPE_TRAP) and tp~=ep and Duel.GetFieldGroupCount(ep,LOCATION_EXTRA,0)<1)
end
--
function c33502800.ofilter1(c,e,tp,mg,tc)
	local b1=c:IsLocation(LOCATION_MZONE+LOCATION_HAND)
		and c:GetRitualLevel(tc)>=tc:GetLevel()
	local b2=c:IsLocation(LOCATION_SZONE)
		and aux.IsCodeListed(c,33502800) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGrave()
	return (b1 or b2) and Duel.GetMZoneCount(tp,c)>0
end
function c33502800.op1(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c33502800.tfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local lg=Duel.SelectMatchingCard(tp,c33502800.ofilter1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,tc,e,tp,mg,tc)
		if lg:GetCount()<1 then return end
		tc:SetMaterial(lg)
		local lc=lg:GetFirst()
		local ng=Group.CreateGroup()
		while lc do
			if lc:IsType(TYPE_MONSTER) then ng:AddCard(lc) end
			lc=lg:GetNext()
		end
		if ng:GetCount()>0 then
			lg:Sub(ng)
			Duel.ReleaseRitualMaterial(ng)
		end
		if lg:GetCount()>0 then
			Duel.SendtoGrave(lg,REASON_EFFECT)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
--
function c33502800.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
--
function c33502800.tfilter2(c,e,tp,exg,chk)
	if bit.band(c:GetOriginalType(),0x81)~=0x81
		or not aux.IsCodeListed(c,33502800)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		or not c:IsFaceup() then return false end
	local lv=c:GetOriginalLevel()
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv,"Greater")
	local res=exg:CheckSubGroup(aux.RitualCheck,1,lv,tp,c,lv,"Greater")
	aux.GCheckAdditional=nil
	return res
end
function c33502800.exfilter2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:GetLevel()>0 and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c33502800.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local exg=Duel.GetMatchingGroup(c33502800.exfilter2,tp,LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(c33502800.tfilter2,tp,LOCATION_SZONE,0,1,nil,e,tp,exg,true)
	end
	Duel.SetChainLimit(c33502800.dislimit)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
--
function c33502800.op2(e,tp,eg,ep,ev,re,r,rp)
	local exg=Duel.GetMatchingGroup(c33502800.exfilter2,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c33502800.tfilter2,tp,LOCATION_SZONE,0,1,1,nil,e,tp,exg,true)
	local tc=tg:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local lv=tc:GetOriginalLevel()
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,lv,"Greater")
		local mat=exg:SelectSubGroup(tp,aux.RitualCheck,false,1,lv,tp,tc,lv,"Greater")
		aux.GCheckAdditional=nil
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
--
