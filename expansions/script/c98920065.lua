--升阶魔法-叛逆之力
function c98920065.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_DESTROY+TIMING_END_PHASE)
	e1:SetTarget(c98920065.target)
	e1:SetOperation(c98920065.activate)
	c:RegisterEffect(e1)
end
function c98920065.filter1(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c98920065.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+2)
end
function c98920065.filter2(c,e,tp,mc,rk)
	return c:IsRank(rk) and (c:IsSetCard(0xba) or c:IsSetCard(0x10db) or c:IsSetCard(0x13b)) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c98920065.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c98920065.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c98920065.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c98920065.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,tp,LOCATION_EXTRA)
end
function c98920065.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920065.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+2)
	local sc=g:GetFirst()
	if sc then
		Duel.BreakEffect()
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		if tc:IsSetCard(0xba,0x10db,0x13b) then
		   local id=sc:GetRealFieldID()
		   local e1=Effect.CreateEffect(e:GetHandler())
		   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		   e1:SetCode(EVENT_CHAINING)
		   e1:SetRange(0xff)
		   e1:SetLabelObject(g)
		   e1:SetLabel(id)
		   e1:SetOperation(c98920065.chainop)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		   e:GetHandler():RegisterEffect(e1)
		else
		   local e1=Effect.CreateEffect(e:GetHandler())
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_DISABLE)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		   sc:RegisterEffect(e1)
		   local e2=Effect.CreateEffect(e:GetHandler())
		   e2:SetType(EFFECT_TYPE_SINGLE)
		   e2:SetCode(EFFECT_DISABLE_EFFECT)
		   e2:SetValue(RESET_TURN_SET)
		   e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		   sc:RegisterEffect(e2)
		   local e3=Effect.CreateEffect(e:GetHandler())
		   e3:SetType(EFFECT_TYPE_SINGLE)
		   e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		   e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		   sc:RegisterEffect(e3)
	   end
	end
end
function c98920065.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local tc=e:GetLabelObject():GetFirst()
	local id=e:GetLabel()
	if not tc or not id then return end
	if rc==tc and tc:GetRealFieldID()==id then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function c98920065.chainlm(e,rp,tp)
	return tp==rp
end