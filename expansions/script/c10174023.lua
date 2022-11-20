--次元充能
function c10174023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10174023.target)
	e1:SetOperation(c10174023.operation)
	c:RegisterEffect(e1)	
end
function c10174023.cfilter(c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_DECK+LOCATION_EXTRA,0)>0
end
function c10174023.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) and c10174023.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10174023.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10174023.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,g:GetFirst():GetControler(),LOCATION_DECK+LOCATION_EXTRA)
end
function c10174023.operation(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if not tc:IsRelateToEffect(e) then return end
	local p=tc:GetControler()
	local g=Duel.GetFieldGroup(p,LOCATION_DECK+LOCATION_EXTRA,0)
	if #g<=0 then return end
	Duel.ConfirmCards(tp,g)
	local rg=g:Filter(c10174023.cfilter2,nil)
	local rg2=Group.CreateGroup()
	local tbl={ TYPE_RITUAL,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK }
	if #rg<=0 then return end
	for i=1,5 do
		if rg:IsExists(Card.IsType,1,nil,tbl[i]) and Duel.SelectYesNo(tp,aux.Stringid(10174023,i)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
			local tc=rg:FilterSelect(tp,Card.IsType,1,1,nil,tbl[i]):GetFirst()
			rg2:AddCard(tc)
			rg:Remove(Card.IsType,nil,tbl[i])
		end
	end
	if #rg2>0 then
		local ct=Duel.Remove(rg2,POS_FACEUP,REASON_EFFECT)
		if ct<=0 or tc:IsFacedown() then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(ct*1000)
		tc:RegisterEffect(e1)   
	end
end
function c10174023.cfilter2(c)
	return c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and c:IsAbleToRemove()
end