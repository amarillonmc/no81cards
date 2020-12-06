--虚拟主播 有栖Mana SP
function c33710902.initial_effect(c)
	c:EnableReviveLimit() 
	--Actto
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33710902,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c33710902.tgtg)
	e2:SetOperation(c33710902.tgop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c33710902.valcheck)
	e1:SetLabelObject(e2)
	c:RegisterEffect(e1)
end
function c33710902.tgfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function c33710902.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33710902.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) or (e:GetLabel()==1 and Duel.IsExistingMatchingCard(c33710902.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,LOCATION_DECK,1,nil)) end
	if e:GetLabel()==0 then
		local sg=Duel.SelectMatchingCard(tp,c33710902.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SetTargetCard(sg)
	end
	if e:GetLabel()==1 then
			local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
			Duel.ConfirmCards(tp,g)
			local sg=Duel.SelectMatchingCard(tp,c33710902.tgfilter,tp,LOCATION_DECK,LOCATION_DECK,1,1,nil)
			Duel.SetTargetCard(sg)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,1,tp,2100)
end
function c33710902.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
				Duel.Recover(tp,2100,REASON_EFFECT)
			end
		else
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
				Duel.Recover(tp,2100,REASON_EFFECT)
			end
		end
	end
	local tg=Duel.GetOperatedGroup()
	if tg:GetCount()~=0 and tg:GetFirst():IsCode(33701330)  then
		Duel.SetLP(tp,Duel.GetLP(tp)*2)
	end
end
function c33710902.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0x344c) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end