--升阶魔法 萝卜-Refit 重整 
function c98930211.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,98930211)
	e1:SetTarget(c98930211.target)
	e1:SetOperation(c98930211.activate)
	c:RegisterEffect(e1)  
  --to deck
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_TODECK)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_GRAVE)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e10:SetCondition(aux.exccon)
	e10:SetCountLimit(1,98940211)
	e10:SetTarget(c98930211.tdtg)
	e10:SetOperation(c98930211.tdop)
	c:RegisterEffect(e10)
end
function c98930211.filter1(c,e,tp)
	local rk=c:GetAttack()
	return c:IsFaceup() and c:IsSetCard(0xad2) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c98930211.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1000,c:GetAttribute())
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c98930211.filter2(c,e,tp,mc,rk,att)
	return c:IsAttack(rk) and mc:IsCanBeXyzMaterial(c) and c:IsRace(RACE_MACHINE) and c:IsAttribute(att)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c98930211.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c98930211.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c98930211.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c98930211.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98930211.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98930211.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetAttack()+1000,tc:GetAttribute())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then   
		   if not sc:IsSetCard(0xad2) then
			  sc:RegisterFlagEffect(98930211,RESET_EVENT+RESETS_STANDARD,0,1)
		   end
		   sc:CompleteProcedure() 
		   local e1=Effect.CreateEffect(e:GetHandler())
		   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		   e1:SetCode(EVENT_PHASE+PHASE_END)
		   e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		   e1:SetLabelObject(sc)
		   e1:SetCondition(c98930211.descon)
		   e1:SetOperation(c98930211.desop)
		   e1:SetCountLimit(1)
		   Duel.RegisterEffect(e1,tp)
		end
	end
end
function c98930211.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(98930211)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c98930211.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
function c98930211.tdfilter(c)
	return c:IsAbleToExtra() and c:IsType(TYPE_XYZ)
end
function c98930211.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98930211.tdfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingTarget(c98930211.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c98930211.tdfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c98930211.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local g=Group.FromCards(c,tc)
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==0 then return end
		Duel.ShuffleDeck(tp)
	end
end