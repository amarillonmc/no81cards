--星光歌剧 爱城华恋Revue
function c64832001.initial_effect(c)
	--summon with 1 tribute
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(64832001,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c64832001.otcon)
	e0:SetOperation(c64832001.otop)
	e0:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c64832001.thcon)
	e2:SetCost(c64832001.thcost)
	e2:SetTarget(c64832001.thtg)
	e2:SetOperation(c64832001.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c64832001.spcon)
	e3:SetTarget(c64832001.sptg)
	e3:SetOperation(c64832001.spop)
	c:RegisterEffect(e3)
end
function c64832001.otfilter(c)
	return c:IsSetCard(0x6410)
end
function c64832001.otcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c64832001.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c64832001.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c64832001.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c64832001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c64832001.thcostfil(c)
	return c:IsSetCard(0x6410) and c:IsAbleToGraveAsCost()
end
function c64832001.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64832001.thcostfil,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c64832001.thcostfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c64832001.thfil(c)
	return c:IsSetCard(0x6410) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c64832001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64832001.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c64832001.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c64832001.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c64832001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and Duel.GetTurnPlayer()~=tp
end
function c64832001.spfilter(c,e,tp)
	return c:IsSetCard(0x6410) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c64832001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c64832001.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c64832001.tgfil(c,def)
	return c:IsAttackBelow(def) and c:IsFaceup()
end
function c64832001.spop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c64832001.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local fid=e:GetHandler():GetFieldID()
			tc:RegisterFlagEffect(64832001,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetLabel(fid)
			e1:SetLabelObject(tc)
			e1:SetCondition(c64832001.thacon)
			e1:SetOperation(c64832001.thaop)
			Duel.RegisterEffect(e1,tp)
			if Duel.IsExistingMatchingCard(c64832001.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,def) and Duel.SelectYesNo(tp,aux.Stringid(64832001,1)) then
				Duel.BreakEffect()
				local def=tc:GetDefense()
				local tgg=Duel.SelectMatchingCard(tp,c64832001.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,def)
				Duel.SendtoGrave(tgg,REASON_EFFECT)
			end
			end
		end
end
function c64832001.thacon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(64832001)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c64832001.thaop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end