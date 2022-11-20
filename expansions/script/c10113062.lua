--魔法实验室
function c10113062.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--Activate
	local ea=Effect.CreateEffect(c)
	ea:SetCategory(CATEGORY_SPECIAL_SUMMON)
	ea:SetType(EFFECT_TYPE_ACTIVATE)
	ea:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(ea) 
	--add counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_SZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(c10113062.acop)
	c:RegisterEffect(e1)	
	--selfdestroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c10113062.sdcon)
	c:RegisterEffect(e2)
	--count
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetOperation(c10113062.contop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10113062,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c10113062.spcon)
	e4:SetTarget(c10113062.sptg)
	e4:SetOperation(c10113062.spop)
	c:RegisterEffect(e4)
	e4:SetLabelObject(e3)
end
function c10113062.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1,2)
	end
end
function c10113062.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
end
function c10113062.spfilter(c,e,tp,ct)
	return ((c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or c:IsAbleToHand()) and c:IsLevelBelow(ct)
end
function c10113062.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10113062.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetLabelObject():GetLabel()) end
end
function c10113062.spop(e,tp,eg,ep,ev,re,r,rp)
	local g,ft,op,c=Duel.GetMatchingGroup(c10113062.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,e:GetLabelObject():GetLabel()),Duel.GetLocationCount(tp,LOCATION_MZONE),0,e:GetHandler()
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10113062,1))
	local tc=Duel.SelectMatchingCard(tp,c10113062.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetLabelObject():GetLabel()):GetFirst()
	if tc then
		local f1=ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local f2=tc:IsAbleToHand()
		if f1 and f2 then
		   op=Duel.SelectOption(tp,aux.Stringid(10113062,3),aux.Stringid(10113062,2))
		elseif f1 then
		   op=0
		elseif f2 then
		   op=1
		end
		if op==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c10113062.contop(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetCounter(0x1))
end
function c10113062.sdcon(e)
	return e:GetHandler():GetCounter(0x1)>=8
end