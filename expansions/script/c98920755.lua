--玄化龙骑士女王
function c98920755.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920755,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920755)
	e1:SetCondition(c98920755.spcon1)
	e1:SetCost(c98920755.spcost)
	e1:SetTarget(c98920755.sptg)
	e1:SetOperation(c98920755.spop)
	c:RegisterEffect(e1)	
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920755,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,98930755)
	e2:SetTarget(c98920755.rtgtg)
	e2:SetOperation(c98920755.rtgop)
	c:RegisterEffect(e2)
end
function c98920755.cfilter(c)
	return c:IsSetCard(0x105) and c:IsAbleToRemoveAsCost() and not c:IsCode(98920755) and c:IsType(TYPE_MONSTER)
end
function c98920755.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c98920755.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920755.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98920755.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c98920755.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920755.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98920755.rtgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x105) and c:IsType(TYPE_MONSTER) and not c:IsCode(98920755)
end
function c98920755.rtgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end
function c98920755.geteffect(c)
	cregister=Card.RegisterEffect
	table_effect={}
	Card.RegisterEffect=function(card,effect,flag)
		if effect and effect:GetCode()==(EVENT_PHASE+PHASE_STANDBY) then
			local eff=effect:Clone()
			table.insert(table_effect,eff)
		end
		return 
	end
	table_effect={}
	Duel.CreateToken(0,c:GetOriginalCode())
	Card.RegisterEffect=cregister
	return table_effect
end
function c98920755.rtgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c98920755.rtgfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetCategory(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c98920755.rtgfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local xuanhua_table_effect=c98920755.geteffect(tc)
	local te=table.unpack(xuanhua_table_effect)
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	e:SetProperty(te:GetProperty())
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(tc)
	Duel.ClearOperationInfo(0)
end
function c98920755.rtgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local xuanhua_table_effect=c98920755.geteffect(tc)
	local te=table.unpack(xuanhua_table_effect)
	if tc and tc:IsRelateToEffect(e) then
		e:SetLabel(te:GetLabel())
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		te:SetLabel(e:GetLabel())
		te:SetLabelObject(e:GetLabelObject())
	end
end