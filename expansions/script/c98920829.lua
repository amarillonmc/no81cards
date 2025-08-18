--混沌之七皇
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,98920829)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c98920829.eftg)
	e2:SetOperation(c98920829.efop)
	c:RegisterEffect(e2)
	--draw count
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c98920829.drval)
	c:RegisterEffect(e2)
end
function c98920829.spfilter(c,e,tp)
	local no=aux.GetXyzNumber(c)
	return c:IsFaceup() and no and no>=101 and no<=107 and c:IsSetCard(0x48) and not c:IsSetCard(0x1048)
		and Duel.IsExistingMatchingCard(c98920829.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,no)
end
function c98920829.filter2(c,e,tp,mc,no)
	return aux.GetXyzNumber(c)==no and c:IsSetCard(0x1048) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c98920829.eqfilter1(c,tp)
	local no=aux.GetXyzNumber(c)
	return c:IsFaceup() and c:IsSetCard(0x1048) and no and no>=101 and no<=107 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c98920829.eqfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,no)
end
function c98920829.eqfilter2(c,no)
	return c:IsSetCard(0x48) and not c:IsSetCard(0x1048)
		and aux.GetXyzNumber(c)==no and c:IsCanOverlay()
end
function c98920829.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98920829.spfilter(chkc,e,tp)
		else return chkc:IsLocation(LOCATION_GRAVE) and c98920829.eqfilter1(chkc,tp) end
	end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c98920829.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c98920829.eqfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(98920829,1),aux.Stringid(98920829,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(98920829,1))
	else op=Duel.SelectOption(tp,aux.Stringid(98920829,2))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c98920829.spfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		e:SetCategory(CATEGORY_EQUIP)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c98920829.eqfilter1,tp,LOCATION_GRAVE,0,1,1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
	end
end
function c98920829.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then	
	   local tc=Duel.GetFirstTarget()
	   local no=aux.GetXyzNumber(tc)
	   if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	   if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=Duel.SelectMatchingCard(tp,c98920829.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,no)
	   local sc=g:GetFirst()
	   if sc then
		  local mg=tc:GetOverlayGroup()
		  if mg:GetCount()~=0 then
			  Duel.Overlay(sc,mg)
		  end
		  sc:SetMaterial(Group.FromCards(tc))
		  Duel.Overlay(sc,Group.FromCards(tc))
		  Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		  sc:CompleteProcedure()
	 	end
	else
		local tc=Duel.GetFirstTarget()
		local no=aux.GetXyzNumber(c)
		if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local g=Duel.GetMatchingGroup(c98920829.eqfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,no)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local sg=g:Select(tp,1,1,nil)
				Duel.Overlay(tc,sg)
			end
		end
	end
end
function c98920829.drfilter(c)
	local no=aux.GetXyzNumber(c)
	return c:IsFaceup() and no and no>=101 and no<=107 and c:IsSetCard(0x1048)
end
function c98920829.drval(e)
	local g=Duel.GetMatchingGroup(c98920829.drfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return g:GetCount()+1
end