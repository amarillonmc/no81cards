--新电王·强袭形态
function c9980606.initial_effect(c)
	 c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980606,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9980606)
	e1:SetTarget(c9980606.tg1)
	e1:SetOperation(c9980606.op1)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980606.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980606,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,0x1e0)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,99806061)
	e3:SetTarget(c9980606.eqtg)
	e3:SetOperation(c9980606.eqop)
	c:RegisterEffect(e3)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980606,2))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99806060)
	e1:SetCost(c9980606.rmcost)
	e1:SetTarget(c9980606.rmtg)
	e1:SetOperation(c9980606.rmop)
	c:RegisterEffect(e1)
end
function c9980606.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980606,3))
end 
function c9980606.mat_filter(c)
	return c:IsRace(RACE_FIEND,RACE_WARRIOR)
end
function c9980606.tfilter1(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,4,rc)
	else return false end
end
function c9980606.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsCanBeRitualMaterial,c,c)
		local ft=Duel.GetMZoneCount(tp)
		if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
		if ft>0 then
			return mg:CheckWithSumGreater(Card.GetRitualLevel,4,c)
		else
			return mg:IsExists(c9980606.tfilter1,1,nil,tp,mg,c)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9980606.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetMZoneCount(tp)
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,4,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c9980606.tfilter1,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,4,tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		e:SetLabel(mat:GetCount())
		if not tc:IsRelateToEffect(e) then return end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c9980606.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c9980606.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
	local atk=tc:GetTextAttack()
	if tc:IsFacedown() then atk=0 end
	if atk<0 then atk=0 end
	if not Duel.Equip(tp,tc,c,false) then return end
	--Add Equip limit
	tc:RegisterFlagEffect(1000712,RESET_EVENT+0x1fe0000,0,0)
	e:SetLabelObject(tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c9980606.eqlimit)
	tc:RegisterEffect(e1)
	if atk>0 then
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetValue(atk/2)
	tc:RegisterEffect(e2)
	end
	else Duel.SendtoGrave(tc,REASON_EFFECT) end
end
function c9980606.eqlimit(e,c)
	return e:GetOwner()==c
end
function c9980606.cfilter(c)
	return c:IsRace(RACE_FIEND,RACE_WARRIOR) and c:IsAbleToRemoveAsCost()
end
function c9980606.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980606.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9980606.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9980606.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c9980606.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980606,4))
	end
end