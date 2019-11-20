--刻刻帝 「六之弹」
function c33400106.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33400106+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c33400106.target)
	e1:SetOperation(c33400106.activate)
	c:RegisterEffect(e1)
end
function c33400106.cfilter(c,e,tp)
	return c:IsSetCard(0x3341) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400106.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return  Duel.IsExistingTarget(c33400106.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	and Duel.IsCanRemoveCounter(tp,1,0,0x34f,2,REASON_COST)
	end
	local sc=Duel.GetMatchingGroupCount(c33400106.cfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return sc>0  end
	local cn=Duel.GetCounter(tp,1,0,0x34f)
	local lvt={} 
	 if cn>=2 and sc>=1 then lvt[1]=1	end
	 if cn>=2 and sc>=2 and Duel.GetFlagEffect(tp,33400101)>=2 then lvt[2]=2 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400106,1))
	local sc1=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.RemoveCounter(tp,1,0,0x34f,2,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33400106.cfilter,tp,LOCATION_GRAVE,0,sc1,sc1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
	local v=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
end
function c33400106.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
	 while tc do 
	  if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(0)
		tc:RegisterEffect(e3)
	  end
	 tc=g:GetNext()
	 end
	end
	Duel.SpecialSummonComplete()
   Duel.RegisterFlagEffect(tp,33400101,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)
   
end
