--被遗忘的研究 星火羽再燃式
function c43480060.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,43480060)
	e1:SetCondition(c43480060.condition)
	e1:SetTarget(c43480060.target)
	e1:SetOperation(c43480060.activate)
	c:RegisterEffect(e1)
	--equip 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,43480061)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c43480060.eqtg)
	e2:SetOperation(c43480060.eqop)
	c:RegisterEffect(e2)
end
function c43480060.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3f13)  
end
function c43480060.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c43480060.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then return false end
	if not Duel.IsChainNegatable(ev) then return false end
	return rp==1-tp 
end
function c43480060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0) 
end
function c43480060.spfil(c,e,tp)  
	if not (c:IsSetCard(0x3f13) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end 
	if c:IsLocation(LOCATION_EXTRA) then  
		return c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
	else 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	end 
end 
function c43480060.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and Duel.IsExistingMatchingCard(c43480060.spfil,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(43480060,0)) then 
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,c43480060.spfil,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end
end
function c43480060.eqfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3f13) and c:IsType(TYPE_LINK) and Duel.IsExistingMatchingCard(c43480060.eqeqfilter,tp,LOCATION_DECK,0,1,nil,c,tp)
end
function c43480060.eqeqfilter(c,tc,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x3f13) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c43480060.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c43480060.eqfilter(chkc,tp) end 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c43480060.eqfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c43480060.eqfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c43480060.eqop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,c43480060.eqeqfilter,tp,LOCATION_DECK,0,1,1,nil,tc,tp):GetFirst()
		if ec then
			Duel.Equip(tp,ec,tc) 
			--equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
			e1:SetLabelObject(tc)
			e1:SetValue(function(e,c)
			return c==e:GetLabelObject() end)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e1) 
		end
	end
end


