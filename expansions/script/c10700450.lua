--魔偶甜点·巴伐露管理员
function c10700450.initial_effect(c)
	--Copy Code
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700450,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c10700450.thtg)
	e1:SetOperation(c10700450.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700450,3))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c10700450.retcon)
	e3:SetTarget(c10700450.rettg)
	e3:SetOperation(c10700450.retop)
	c:RegisterEffect(e3)   
end
function c10700450.mfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x71) and c:IsRace(RACE_BEAST)
end
function c10700450.filter1(c)
	return c:IsSetCard(0x71) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c10700450.mfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x71) and c:IsRace(RACE_FAIRY)
end
function c10700450.filter2(c,e,tp)
	return c:IsSetCard(0x71) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c10700450.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	local b1=Duel.IsExistingMatchingCard(c10700450.filter1,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c10700450.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local d1=Duel.IsExistingMatchingCard(c10700450.mfilter1,tp,LOCATION_MZONE,0,1,nil)
	local d2=Duel.IsExistingMatchingCard(c10700450.mfilter2,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return (b1 and d1) or (b2 and d2) end
	local op=0
	if b1 and d1 and b2 and d2 then op=Duel.SelectOption(tp,aux.Stringid(10700450,1),aux.Stringid(10700450,2))
	elseif (b1 and d1) and not (b2 and d2) then op=Duel.SelectOption(tp,aux.Stringid(10700450,1))
	elseif (b2 and d2) and not (b1 and d1) then op=Duel.SelectOption(tp,aux.Stringid(10700450,2))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	else
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function c10700450.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET) 
		local g1=Duel.SelectMatchingCard(tp,c10700450.filter1,tp,LOCATION_GRAVE,0,1,1,nil) 
		if g1:GetCount()>0 then
			Duel.HintSelection(g1)
			Duel.SSet(tp,g1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c10700450.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g2:GetCount()>0 then
			Duel.HintSelection(g2)
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP_DEFENSE) 
		end
	end
end
function c10700450.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():GetReasonPlayer()==1-tp
		and e:GetHandler():GetPreviousControler()==tp
end
function c10700450.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c10700450.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end