--教导雷怒
function c11634017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,11634017+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11634017.actg)
	e1:SetOperation(c11634017.acop)
	c:RegisterEffect(e1)
end 
function c11634017.tarfil1(c,e,tp) 
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsSetCard(0x145) and Duel.IsExistingTarget(c11634017.tarfil2,tp,0,LOCATION_MZONE,1,nil,e,tp,c)
end 
function c11634017.tarfil2(c,e,tp,sc) 
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil) 
	local cg=Group.FromCards(sc,c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and g:CheckSubGroup(c11634017.tgck,1,2,cg) 
end  
function c11634017.tgck(g,cg) 
	return g:GetSum(Card.GetAttack)<=cg:GetSum(Card.GetAttack) and g:GetClassCount(Card.GetCode)==g:GetCount() 
end 
function c11634017.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c11634017.tarfil1,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(nil,1-tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=Duel.SelectTarget(tp,c11634017.tarfil1,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	Duel.SelectTarget(tp,c11634017.tarfil2,tp,0,LOCATION_MZONE,1,1,nil,e,tp,tc) 
end
function c11634017.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local rg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if #rg>0 then
		Duel.ConfirmCards(tp,rg)
	end 
	if cg:GetCount()==2 then 
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil) 
		if g:CheckSubGroup(c11634017.tgck,1,2,cg) then 
			local sg=g:SelectSubGroup(tp,c11634017.tgck,false,1,2,cg) 
			if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then 
				Duel.BreakEffect() 
				Duel.Release(cg,REASON_EFFECT) 
			end 
		end 
	end 
end 






