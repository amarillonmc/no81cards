--陈
function c9951156.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
 --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c9951156.descon)
	e2:SetTarget(c9951156.destg)
	e2:SetOperation(c9951156.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c9951156.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951156,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9951156)
	e1:SetTarget(c9951156.sptg)
	e1:SetOperation(c9951156.spop)
	c:RegisterEffect(e1)
   --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951156.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951156.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951156,0))
end
function c9951156.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function c9951156.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*1000)
end
function c9951156.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if Duel.Damage(1-tp,ct*1000,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c9951156.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_LINK) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c9951156.spfilter(c,e,tp,mc)
	return c:IsRace(RACE_WYRM) and mc:IsCanBeXyzMaterial(c) and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and not c:IsCode(9951156)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9951156.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c9951156.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9951156.matfilter(c,e)
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function c9951156.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Group.FromCards(c)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9951156.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
		local tc=g:GetFirst()
		if tc then
			Duel.BreakEffect()
			tc:SetMaterial(mg)
			Duel.Overlay(tc,mg)
			if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
				tc:CompleteProcedure()
				if Duel.IsExistingMatchingCard(c9951156.matfilter,tp,LOCATION_PZONE,0,1,nil,e)
					and Duel.SelectYesNo(tp,aux.Stringid(9951156,1)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local sg=Duel.SelectMatchingCard(tp,c9951156.matfilter,tp,LOCATION_PZONE,0,1,1,nil,e)
					Duel.HintSelection(sg)
					Duel.Overlay(tc,sg)
				end
			end
		end
	end
end