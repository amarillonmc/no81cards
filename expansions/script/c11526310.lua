--炭酸装姬·叁矢
function c11526310.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,11526310)
	e1:SetCondition(c11526310.discon)
	e1:SetTarget(c11526310.distg)
	e1:SetOperation(c11526310.disop)
	c:RegisterEffect(e1)	
end
c11526310.SetCard_Carbonic_Acid_Girl=true 
--
function c11526310.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>=2
end
function c11526310.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11526310.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local card=0
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.BreakEffect()
			local dg=Group.CreateGroup()
			for i=1,ev do
				local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
				if tgp==tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and te:GetHandler().SetCard_Carbonic_Acid_Girl then
					local tc=te:GetHandler()
					card=card+1
				end
			end 
			if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11526310,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local gg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,card,nil)
				if gg:GetCount()>0 then
					Duel.HintSelection(gg)
					Duel.SendtoDeck(gg,nil,2,REASON_EFFECT)
				end
			end
		end 
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(11526310,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(c)
		e1:SetCondition(c11526310.thcon)
		e1:SetOperation(c11526310.thop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c11526310.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(11526310)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c11526310.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetLabelObject(),nil,2,REASON_EFFECT)
end